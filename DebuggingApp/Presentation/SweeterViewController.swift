//
//  SweeterViewController.swift
//  DebuggingApp
//
//  Created by Teacher on 01.11.2020.
//

import UIKit

class SweeterViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    private let sweetService: SweetService = MockSweetService()
    private var sweets: [Sweet] = []

    @IBOutlet private var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    enum CellIdentifier: String {
        case create = "CreateCell"
        case sweet = "SweetCell"
        case loader = "LoaderCell"
    }

    // MARK: - UITableViewDataSource

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        sweets.count + 2
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
            case 0:
                return createCell(from: tableView, at: indexPath)
            case (sweets.isEmpty ? 0...0 : 1...sweets.count):
                return sweetCell(from: tableView, at: indexPath)
            case sweets.count + 1:
                return loaderCell(from: tableView, at: indexPath)
            default:
                fatalError("Unknown index")
        }
    }

    private func createCell(from tableView: UITableView, at indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.create.rawValue) {
            return cell
        } else {
            let cell = UITableViewCell(style: .default, reuseIdentifier: CellIdentifier.create.rawValue)
            cell.textLabel?.text = "New sweet"
            if let image = UIImage(systemName: "plus")?.withTintColor(cell.tintColor) {
                cell.accessoryView = UIImageView(image: image)
            }
            return cell
        }
    }

    private func sweetCell(from tableView: UITableView, at indexPath: IndexPath) -> UITableViewCell {
        guard let cell: SweetCell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.sweet.rawValue, for: indexPath) as? SweetCell
        else { fatalError("Could not deque sweet cell") }
        cell.set(sweet: sweets[indexPath.row - 1])
        return cell
    }

    private func loaderCell(from tableView: UITableView, at indexPath: IndexPath) -> UITableViewCell {
        loadMore()
        return tableView.dequeueReusableCell(withIdentifier: CellIdentifier.loader.rawValue, for: indexPath)
    }

    // MARK: - UITableViewDelegate

    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
            case 0:
                return 44
            case (sweets.isEmpty ? 0...0 : 1...(sweets.count)):
                return 80
            default:
                return 44
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
            case 0:
                return 44
            case (sweets.isEmpty ? 0...0 : 1...(sweets.count)):
                return UITableView.automaticDimension
            default:
                return 44
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
            case 0:
                sweet()
            case 1...(sweets.count):
                open(sweet: sweets[indexPath.row])
            default:
                fatalError("Wrong index!")
        }
    }

    private func sweet() {
        guard let createSweetViewController: CreateSweetViewController = storyboard?.instantiateViewController(identifier: "CreateSweetViewController")
        else {
            return
        }
        show(createSweetViewController, sender: nil)
    }

    private func open(sweet: Sweet) {
        guard let sweetViewController: SweetViewController = storyboard?.instantiateViewController(identifier: "SweetViewController") else {
            return
        }
        sweetViewController.sweet = sweet
        sweetViewController.sweetBackAction = {
            sweetViewController.dismiss(animated: true)
            self.sweetService.postSweet(withTitle: sweet.title, text: "Sweet back: \(sweet.text)") { result in
                if case .failure(let error) = result {
                    self.showAlert(with: error.localizedDescription)
                }
                self.sweets.insert(sweet, at: 0)
                self.tableView.reloadData()
            }
        }
        present(sweetViewController, animated: true)
    }

    // MARK: - Helpers

    private func loadMore() {
        sweetService.loadFeed(after: sweets.last?.id) { result in
            switch result {
                case .success(let sweets):
                    self.sweets.append(contentsOf: sweets)
                    self.tableView.reloadData()
                case .failure(let error):
                    self.showAlert(with: error.localizedDescription)
            }
        }
    }

    private func showAlert(with text: String) {
        let alertController = UIAlertController(title: nil, message: text, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .cancel))
        present(alertController, animated: true)
    }
}

