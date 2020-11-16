//
//  CreateSweetViewController.swift
//  DebuggingApp
//
//  Created by Teacher on 02.11.2020.
//

import UIKit

class CreateSweetViewController: UIViewController {
    private var sweetService: SweetService = MockSweetService()

    @IBOutlet private var titleTextField: UITextField!
    @IBOutlet private var textView: UITextView!

    override func viewDidLoad() {
        super.viewDidLoad()

        textView.layer.borderWidth = 1 / UIScreen.main.scale
        textView.layer.borderColor = UIColor.gray.withAlphaComponent(0.5).cgColor
        textView.layer.cornerRadius = 6
    }

    @IBAction private func sendTap() {
        sweetService.postSweet(withTitle: titleTextField?.text, text: textView.text) { result in
        }
    }
}
