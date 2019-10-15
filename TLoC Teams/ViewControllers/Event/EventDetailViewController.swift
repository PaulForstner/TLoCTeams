//
//  EventDetailViewController.swift
//  TLoC Teams
//
//  Created by Paul Forstner on 14.10.19.
//  Copyright © 2019 TLoC. All rights reserved.
//

import UIKit
import Firebase

final class EventDetailViewController: UIViewController {
    
    // MARK: - Typealias
    
    private typealias NameCompletion = (String?) -> Void
    
    // MARK: - IBOutlet
    
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var eventImageView: UIImageView!
    @IBOutlet private weak var nameDateLabel: UILabel!
    @IBOutlet private weak var gameLabel: UILabel!
    @IBOutlet private weak var locationLabel: UILabel!
    @IBOutlet private weak var acceptButton: UIButton!
    @IBOutlet private weak var declineButton: UIButton!
    
    // MARK: - Lazy
    
    private lazy var dataSource: EventDetailDataSource = {
        return EventDetailDataSource(addHandler: { [weak self] (index) in
            self?.tableView.insertRows(at: [IndexPath(row: index, section: 0)], with: .fade)
        }, removeHandler: { [weak self] (index) in
            self?.tableView.deleteRows(at: [IndexPath(row: index, section: 0)], with: .fade)
        })
    }()
    
    // MARK: - Properties
    
    private var event: Event?
    private var user: User?
    private let db = Firestore.firestore()
    
    // MARK: - Life cycle
    
    deinit {
        cancel()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Event Detail"
        let deleteButton = UIBarButtonItem(title: "Delete", style: .plain, target: self, action: #selector(deleteEvent))
        deleteButton.tintColor = .red
        navigationItem.rightBarButtonItem = deleteButton
        
        setupDataSource()
        setupUI()
        UserService.getCurrentUser { [weak self] (user) in
            
            self?.user = user
            self?.acceptButton.isEnabled = true
            self?.declineButton.isEnabled = true
        }
    }
    
    // MARK: - Setup
    
    private func setupDataSource() {
        
        dataSource.configure(tableView: tableView)
        
        for id in event?.memberIds ?? [] {
            getMember(with: id) { [weak self] (name) in
                self?.dataSource.append(EventDetailDataSource.CellModel(id: id, name: name ?? "Unkown"))
            }
        }
    }
    
    private func setupUI() {
        
        guard let event = event else {
            return
        }
        
        nameDateLabel.text = "\(event.name) at \(event.date)"
        
        if let game = event.game {
            gameLabel.text = "Game: \(game.name)"
        } else {
            gameLabel.text = "No game selected."
        }
        
        if let location = event.location {
            locationLabel.text = "Location: \(location.name)"
        } else {
            locationLabel.text = "No location selected."
        }
        
        loadImage(url: URL(string: event.imageUrl), placeholderImage: Asset.eventPlaceholder.image)
        setupButton(acceptButton, title: "Accept", color: ColorName.green.color)
        setupButton(declineButton, title: "Decline", color: .red)
    }
    
    private func setupButton(_ button: UIButton, title: String, color: UIColor) {
        
        button.layer.cornerRadius = 12
        button.setTitle(title, for: .normal)
        button.backgroundColor = color
        button.tintColor = .black
        button.isEnabled = false
    }
        
    // MARK: - IBActions
    
    @IBAction func accept(_ sender: Any) {
        
        guard let user = user, let userId = Auth.auth().currentUser?.uid else {
            return
        }
        dataSource.append(EventDetailDataSource.CellModel(id: userId, name: user.name))
    }
    
    @IBAction func decline(_ sender: Any) {
        
        guard let userId = Auth.auth().currentUser?.uid else {
            return
        }
        dataSource.removeItemWith(userId)
    }
    
    // MARK: - Helper
    
    @objc private func deleteEvent() {
        
        guard let event = event else {
            return
        }
        db.collection("events").document(event.id).delete()
        navigationController?.popViewController(animated: true)
    }
    
    private func getMember(with id: String, completion: @escaping NameCompletion) {
        
        db.collection("users").document(id).getDocument { (snapShot, error) in
            
            guard let snapShot = snapShot else {
                completion(nil)
                return
            }
            
            let dic = snapShot.data()
            completion(dic?[Constants.UserFields.name] as? String)
        }
    }
}
    
// MARK: - StoryboardInitializable

extension EventDetailViewController: StoryboardInitializable {
    
    static func makeFromStoryboard() -> EventDetailViewController {
        return StoryboardScene.Main.eventDetailViewController.instantiate()
    }
    
    static func makeFromStoryboard(with event: Event) -> EventDetailViewController {
        
        let vc = makeFromStoryboard()
        vc.event = event
        return vc
    }
}

extension EventDetailViewController: ImageLoadable {
    
    var imageLoadableView: UIImageView {
        return eventImageView
    }
}
