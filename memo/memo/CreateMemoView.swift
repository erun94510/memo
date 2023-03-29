//
//  CreateMemoView.swift
//  memo
//
//  Created by Donghoon Bae on 2023/03/16.
//

import Foundation
import UIKit

class CreateMemoView: UIViewController, UITextFieldDelegate {

    lazy var textView: UITextView = {
        let width: CGFloat = self.view.bounds.width
        let height: CGFloat = self.view.bounds.height
        let posX: CGFloat = (self.view.bounds.width - width) / 2
        let posY: CGFloat = (self.view.bounds.height - height) / 2
        let textView = UITextView(frame: CGRect(x: posX, y: posY, width: width, height: height))
        textView.font = UIFont.systemFont(ofSize: 15)
        return textView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(self.textView)
        self.view.backgroundColor = .white
        
        let createButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(createMemoButton(_:)))
        self.navigationItem.rightBarButtonItem = createButton
    }
    
    @objc func createMemoButton(_ sender: Any) {
        let content = self.textView.text
        _ = ViewController().createMemoData(content: content ?? "", createdOrEditAtDate: Date.now)
        _ = self.navigationController?.popViewController(animated: true)
    }
    
}

