//
//  GameListViewController.swift
//  TLoC Teams
//
//  Created by Paul Forstner on 02.10.19.
//  Copyright © 2019 TLoC. All rights reserved.
//

import UIKit

final class GameListViewController: UIViewController {

    // MARK: - Typealias
    
    typealias GameSelectionHandler = (_ game: Game) -> Void
    
    // MARK: - IBOutlets
    
    @IBOutlet private weak var searchBar: UISearchBar!
    @IBOutlet private weak var tableView: UITableView!
    
    // MARK: - Lazy
    
    private lazy var dataSource: GameListDataSource = {
        return GameListDataSource(didSelectHandler: { [weak self] (game) in
            self?.didSelect(game)
        }, updateHandler: { [weak self] in
            self?.tableView.reloadData()
        })
    }()
    
    // MARK: - Properties
    
    private var gameSelectionHandler: GameSelectionHandler?
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Games"
        setupUI()
        dataSource.configure(tableView: tableView)
    }
    
    // MARK: - Setup
    
    private func setupUI() {
        
        searchBar.delegate = self
        searchBar.placeholder = "Game.."
    }
    
    // MARK: - Helper
    
    @objc private func searchAction() {
        
        guard let text = searchBar.text else {
            return
        }
        
        RAWGNetworkService.search(game: text) { [weak self] (games, error) in
            
            self?.dataSource.set(games)
            self?.searchBar.resignFirstResponder()
        }
    }
    
    private func didSelect(_ game: Game) {
        
        gameSelectionHandler?(game)
        navigationController?.popViewController(animated: true)
    }
}

// MARK: - StoryboardInitializable

extension GameListViewController: StoryboardInitializable {
    
    static func makeFromStoryboard() -> GameListViewController {
        return StoryboardScene.Main.gameListViewController.instantiate()
    }
    
    static func makeFromStoryboard(gameSelectionHandler: GameSelectionHandler?) -> GameListViewController {
        
        let vc = makeFromStoryboard()
        vc.gameSelectionHandler = gameSelectionHandler
        return vc
    }
}

// MARK: - UISearchbarDelegate

extension GameListViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(searchAction), object: nil)
        perform(#selector(searchAction), with: nil, afterDelay: 1.0)
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.becomeFirstResponder()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}
