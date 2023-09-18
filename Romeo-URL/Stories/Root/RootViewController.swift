//
//  RootViewController.swift
//  Romeo-URL
//
//  Created by Alexander Suhodolov on 16/09/2023.
//

import UIKit

protocol RootPresenterInput: AnyObject {}

enum RootCellIdentifier: String {
    case romeo = "romeoCellIdentifier"
    case iTunes = "iTunesApiCellIdentifier"
}

final class RootViewController: UITableViewController {
    static let identifier = "RootViewController"
    
    var router: RootRouting?
    weak var interactor: RootInteractorInput?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Romeo & iTunes API"
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        guard let cell = tableView.cellForRow(at: indexPath),
              let cellIdentifier = RootCellIdentifier(rawValue: cell.reuseIdentifier ?? "")
        else {
            return
        }
        
        interactor?.userDidSelectCell(with: cellIdentifier)
    }
}

extension RootViewController: RootPresenterInput {}
