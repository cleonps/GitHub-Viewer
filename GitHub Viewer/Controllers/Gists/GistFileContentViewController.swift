//
//  GistFileContentViewController.swift
//  GitHub Viewer
//
//  Created by Christian León Pérez Serapio on 11/02/20.
//  Copyright © 2020 christianleon. All rights reserved.
//

import UIKit
import Highlightr
import WebKit
import Down

class GistFileContentViewController: UIViewController {
    public var content = ""
    public var gistTitle = ""
    
    @IBOutlet var contentTextView: UITextView!
    @IBOutlet var contentWebView: WKWebView!
    @IBOutlet var bottomTextViewConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = gistTitle
            
        let kbObserver = UIResponder.keyboardWillShowNotification
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: kbObserver, object: nil)
        hideKeyboardOnTap()
        
        if gistTitle.contains(".txt") {
            contentTextView.text = content
        } else if gistTitle.contains(".md") {
            let down = Down(markdownString: content)
            let body = try? down.toHTML()
            let html = """
            <!doctype html>
            <html lang="es">
            <head>
                <title>\(gistTitle)</title>
                <meta charset="utf-8">
                <meta name="viewport" content="width=device-width">
                <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/github-markdown-css/4.0.0/github-markdown.min.css" />
            </head>
            <body>
                \(body ?? "")
            </body>
            </html>
            """
            
            contentTextView.isHidden = true
            contentWebView.isHidden = false
            contentWebView.loadHTMLString(html, baseURL: nil)
            contentWebView.scrollView.bounces = false
        } else {
            let highlightr = Highlightr()
            highlightr?.setTheme(to: "paraiso-dark")
            highlightr?.theme.setCodeFont(RPFont(name: "FiraCode-Medium", size: 12)!)
            if let highlightedCode = highlightr?.highlight(content) {
                contentTextView.attributedText = highlightedCode
            } else {
                contentTextView.text = "Contenido no disponible"
            }
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        let value = UIInterfaceOrientation.portrait.rawValue
        UIDevice.current.setValue(value, forKey: "orientation")
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            bottomTextViewConstraint.constant = keyboardHeight - ((self.navigationController?.view.subviews[1].bounds.height) ?? 0)
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
    }
    
    override func dismissKeyboard() {
        super.dismissKeyboard()
        
        bottomTextViewConstraint.constant = 10
    }
}
