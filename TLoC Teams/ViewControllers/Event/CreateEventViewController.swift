//
//  CreateEventViewController.swift
//  TLoC Teams
//
//  Created by Paul Forstner on 01.10.19.
//  Copyright © 2019 TLoC. All rights reserved.
//

import UIKit
import Firebase

final class CreateEventViewController: UIViewController {
    
    // MARK: - IBOutlet
    
    @IBOutlet private weak var scrollView: UIScrollView!
    @IBOutlet private weak var eventImageView: UIImageView!
    @IBOutlet private weak var setImageButton: UIButton!
    @IBOutlet private weak var eventNameInputView: InputView!
    @IBOutlet private weak var datePicker: UIDatePicker!
    @IBOutlet private weak var gameHelperView: UIView!
    @IBOutlet private weak var gameLabel: UILabel!
    @IBOutlet private weak var clearGameButton: UIButton!
    @IBOutlet private weak var locationHelperView: UIView!
    @IBOutlet private weak var locationLabel: UILabel!
    @IBOutlet private weak var clearLocationButton: UIButton!
    @IBOutlet private weak var createButton: BaseButton!
    
    // MARK: - Properties
    
    private let textFieldDelegate = TextFieldDelegate()
    private let dateFormatter = DateFormatter()
    private var imageUrl: String?
    private var game: Game? {
        didSet {
            didSetGame()
        }
    }
    private var location: EventLocation? {
        didSet {
            didSetLocation()
        }
    }
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        addObserver()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        removeObserver()
    }
    
    // MARK: - Setup
    
    private func setupUI() {
        
        createButton.setTitle("Create", for: .normal)
        createButton.isEnabled = false
        eventNameInputView.configure(title: "Name", delegate: textFieldDelegate, icon: nil, didChanged: textFieldDidChanged)
        
        datePicker.minimumDate = Date()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .short
        
        gameLabel.text = "Select a game"
        gameHelperView.addGestureRecognizer(UITapGestureRecognizer(target: self,
                                                                   action: #selector(showGameSelection)))
        clearGameButton.isEnabled = false
        clearGameButton.tintColor = ColorName.green.color
        
        locationLabel.text = "Choose a location"
        locationHelperView.addGestureRecognizer(UITapGestureRecognizer(target: self,
                                                                       action: #selector(showLocationSelection)))
        clearLocationButton.isEnabled = false
        clearLocationButton.tintColor = ColorName.green.color
    }
    
    // MARK: - Keyboard
    
    private func addObserver() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    private func removeObserver() {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func keyboardWillShow(_ notification: NSNotification){
        
        guard let userInfo = notification.userInfo,
            var keyboardFrame = (userInfo[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue else {
                return
        }
        
        keyboardFrame = view.convert(keyboardFrame, from: nil)
        
        var contentInset:UIEdgeInsets = scrollView.contentInset
        contentInset.bottom = keyboardFrame.size.height
        scrollView.contentInset = contentInset
    }
    
    @objc func keyboardWillHide(_ notification: NSNotification){
        scrollView.contentInset = .zero
    }
    
    // MARK: - IBAction
    
    @IBAction func setImageAction(_ sender: Any) {

        let optionMenu = UIAlertController(title: nil, message: "Choose an Option", preferredStyle: .actionSheet)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        let cameraAction = UIAlertAction(title: "Camera", style: .default) { [weak self] (_) in
            self?.presentImagePicker(with: .camera)
        }
        let albumAction = UIAlertAction(title: "Album", style: .default) { [weak self] (_) in
            self?.presentImagePicker(with: .photoLibrary)
        }
        
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            optionMenu.addAction(albumAction)
        }
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            optionMenu.addAction(cameraAction)
        }
        
        optionMenu.addAction(cancelAction)
        
        present(optionMenu, animated: true, completion: nil)
    }
    
    @IBAction func clearGame(_ sender: Any) {
        game = nil
    }
    
    @IBAction func clearLocation(_ sender: Any) {
        location = nil
    }
    
    @IBAction func createAction(_ sender: Any) {
        
        guard let name = eventNameInputView.text, let userId = Auth.auth().currentUser?.uid else {
            return
        }
        
        let event = Event(name: name,
                          id: "",
                          date: dateFormatter.string(from: datePicker.date),
                          imageUrl: "",
                          game: game,
                          location: location,
                          memberIds: [userId])
        let reference = Firestore.firestore().collection("events").addDocument(data: event.dictionary) { [weak self] (error) in
            
            if error != nil {
                self?.showAlert(with: Alerts.ErrorTitle, message: Alerts.ErrorMessage)
            } else {
                self?.navigationController?.popViewController(animated: true)
            }
        }
        
        guard let image = eventImageView.image else {
            return
        }
        
        StorageService.uploadImage(image, path: reference.documentID, type: .eventImage) { (url) in
            
            guard let urlString = url?.absoluteString else {
                return
            }

            reference.setData([Constants.EventFields.imageUrl: urlString], merge: true)
        }
    }
    
    // MARK: - Helper
    
    @objc private func showGameSelection() {
        
        let vc = GameListViewController.makeFromStoryboard { [weak self] (game) in
            self?.game = game
        }
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc private func showLocationSelection() {
        
        let vc = LocationViewController.makeFromStoryboard { [weak self] (location) in
            self?.location = location
        }
        navigationController?.pushViewController(vc, animated: true)
    }
    
    private func didSetGame() {
        
        clearGameButton.isEnabled = game != nil
        gameLabel.text = game?.name ?? "Select a game"
    }
    
    private func didSetLocation() {
        
        clearLocationButton.isEnabled = location != nil
        locationLabel.text = location?.name ?? "Choose a location"
    }
    
    private func presentImagePicker(with sourceType: UIImagePickerController.SourceType) {
        
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = sourceType
        present(imagePicker, animated: true, completion: nil)
    }
    
    private func setImage() {
        
    }
    
    private func textFieldDidChanged() {
        createButton.isEnabled = eventNameInputView.isFilled
    }
}

// MARK: - StoryboardInitializable

extension CreateEventViewController: StoryboardInitializable {
    
    static func makeFromStoryboard() -> CreateEventViewController {
        return StoryboardScene.Main.createEventViewController.instantiate()
    }
}

// MARK: - UIImagePickerControllerDelegate, UINavigationControllerDelegate

extension CreateEventViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            eventImageView.image = image
        }
        
        dismiss(animated: false, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: false, completion: nil)
    }
}
