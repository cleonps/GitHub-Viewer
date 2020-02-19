//
//  GistFileContentViewController.swift
//  GitHub Viewer
//
//  Created by Christian León Pérez Serapio on 11/02/20.
//  Copyright © 2020 christianleon. All rights reserved.
//

import UIKit
import Highlightr

class GistFileContentViewController: UIViewController {
    public var content = ""
    public var gistTitle = ""
    
    @IBOutlet var contentTextView: UITextView!
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
            contentTextView.text = content
        } else {
            let highlightr = Highlightr()
            highlightr?.setTheme(to: "paraiso-dark")
            if let highlightedCode = highlightr?.highlight(content) {
                contentTextView.attributedText = highlightedCode
            } else {
                contentTextView.text = "Contenido no disponible"
            }
        }
        
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
