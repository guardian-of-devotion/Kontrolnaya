//
//  SweetCell.swift
//  DebuggingApp
//
//  Created by Teacher on 02.11.2020.
//

import UIKit

class SweetCell: UITableViewCell {
    @IBOutlet private var authorLabel: UILabel!
    @IBOutlet private var dateLabel: UILabel!
    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet private var sweetLabel: UILabel!

    func set(sweet: Sweet) {
        authorLabel.text = sweet.author
        dateLabel.text = formatter.string(from: sweet.date)
        if let title = sweet.title {
            titleLabel.text = title
        } else {
            titleLabel.text = "[No title]"
            titleLabel.textColor = .gray
        }
        sweetLabel.text = sweet.text
    }

    private lazy var formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter
    }()

    private func dateString(from date: Date) -> String {
        formatter.string(from: date)
    }
}
