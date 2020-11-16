//
//  SweetViewController.swift
//  DebuggingApp
//
//  Created by Teacher on 01.11.2020.
//

import UIKit

class SweetViewController: UIViewController {
    var sweet: Sweet?
    var sweetBackAction: (() -> Void)?

    @IBOutlet private var authorLabel: UILabel!
    @IBOutlet private var dateLabel: UILabel!
    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet private var textLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        guard let sweet = sweet else { return }
        authorLabel.text = sweet.author
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .medium
        dateLabel.text = dateFormatter.string(from: sweet.date)
        if let title = sweet.title {
            titleLabel.text = title
        } else {
            titleLabel.text = "[No title]"
            titleLabel.textColor = .gray
        }
        textLabel.text = sweet.text
    }

    @IBAction private func sweetBackTap() {
        sweetBackAction?()
    }
}
