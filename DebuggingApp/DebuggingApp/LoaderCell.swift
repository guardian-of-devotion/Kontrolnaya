//
//  LoaderCell.swift
//  DebuggingApp
//
//  Created by Саркис Катвалян on 16/11/2020.
//
import UIKit

class LoaderCell: UITableViewCell {
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    override func prepareForReuse() {
        super.prepareForReuse()
        if let spinner = self.spinner {
            spinner.startAnimating()
    }
}
}

