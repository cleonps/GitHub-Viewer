//
//  RepoFileViewController.swift
//  GitHub Viewer
//
//  Created by Christian León Pérez Serapio on 12/02/20.
//  Copyright © 2020 christianleon. All rights reserved.
//

import UIKit
import Highlightr
import WebKit

class RepoFileViewController: UIViewController {
    let userDefaults = UserDefaults.standard
    lazy var user = userDefaults.string(forKey: UserDefaults.Keys.user)!
    public var repo = ""
    public var path = ""
    public var fileName = ""
    private var file = RepoFileContent()
    private var mdFile = String()
    
    @IBOutlet var contentTextView: UITextView!
    @IBOutlet var contentImage: UIImageView!
    @IBOutlet var contentWebView: WKWebView!
    @IBOutlet var bottomTextViewConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavBar()
        contentTextView.isEditable = false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        NetworkManager.shared.delegate = self
        if file.content == nil && mdFile == "" {
            if fileName.contains(".md") {
                NetworkManager.shared.getRepoMDFileContent(user: user, repo: repo, file: path)
            } else {
                NetworkManager.shared.getRepoFileContent(user: user, repo: repo, file: path)
            }
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        let value = UIInterfaceOrientation.portrait.rawValue
        UIDevice.current.setValue(value, forKey: "orientation")
    }
    
    private func configureNavBar() {
        let copyButton = UIBarButtonItem(title: "Copiar", style: .plain, target: self, action: #selector(copyAll))
        let copyFont = UIFont(name: "Avenir-book", size: 16)!
        let copyColor = UIColor(named: "TintColor")!
        let copyAttributes: [NSAttributedString.Key: Any] = [.foregroundColor: copyColor, .font: copyFont]
        copyButton.setTitleTextAttributes(copyAttributes, for: .normal)
        
        navigationItem.rightBarButtonItem = copyButton
        navigationItem.title = fileName
    }
    
    @objc func copyAll() {
        UIPasteboard.general.string = contentTextView.text
        presentSimpleAlert(title: "Portapapeles", message: "Texto copiado")
    }
}

extension RepoFileViewController: NetworkManagerDelegate {
    func response(withError error: String, endpoint: Router) {
        switch endpoint {
        case .getRepoFileContent:
            presentSimpleAlert(title: "Error", message: error)
        default:
            break
        }
    }
    
    func response<T: Codable>(dataModel: T, endpoint: Router, code: StatusCodes) {
        switch endpoint {
        case .getRepoFileContent:
            switch code {
            case .success, .accepted:
                file = (dataModel as? RepoFileContent) ?? RepoFileContent()
                let encodedData = file.content!
                let decodedData = Data(base64Encoded: encodedData, options: .ignoreUnknownCharacters)!
                
                if fileName.contains(".png") || fileName.contains(".jpg") || fileName.contains(".jpeg") || fileName.contains(".gif") || fileName.contains(".svg") {
                    let image = UIImage(data: decodedData)
                    contentImage.image = image
                    contentImage.contentMode = .scaleAspectFit
                    contentTextView.isHidden = true
                    contentImage.isHidden = false
                } else if let content = String(data: decodedData, encoding: .utf8) {
                    if fileName.contains(".txt") {
                        contentTextView.text = content
                    } else {
                        let highlightr = Highlightr()
                        highlightr?.setTheme(to: "paraiso-dark")
                        highlightr?.theme.setCodeFont(RPFont(name: "FiraCode-Medium", size: 12)!)
                        if let highlightedCode = highlightr?.highlight(content) {
                            contentTextView.attributedText = highlightedCode
                        } else {
                            contentTextView.text = "Contenido no disponible"
                            contentTextView.isUserInteractionEnabled = false
                        }
                    }
                } else {
                    contentTextView.text = "Contenido no disponible"
                }
                
            default:
                guard let error = dataModel as? ErrorResponse else { return }
                presentSimpleAlert(title: "Error", message: "\(error.message)")
            }
            
        case .getRepoMDFileContent:
            switch code {
            case .success, .accepted:
                let body = (dataModel as? String) ?? String()
                let html = """
                <!doctype html>
                <html lang="es">
                <head>
                    <title>\(fileName)</title>
                    <meta charset="utf-8">
                    <meta name="viewport" content="width=device-width">
                    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/github-markdown-css/4.0.0/github-markdown.min.css" />
                    </head>
                    <body>
                        \(body)
                    </body>
                </html>
                """
                
                mdFile = html
                
                contentTextView.isHidden = true
                contentWebView.isHidden = false
                contentWebView.loadHTMLString(mdFile, baseURL: nil)
                contentWebView.scrollView.bounces = false
            default:
                guard let error = dataModel as? ErrorResponse else { return }
                presentSimpleAlert(title: "Error", message: "\(error.message)")
            }
        default:
            break
        }
    }
}
