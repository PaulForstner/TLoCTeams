//
//  ChatDetailViewController.swift
//  TLoC Teams
//
//  Created by Paul Forstner on 27.09.19.
//  Copyright © 2019 TLoC. All rights reserved.
//

import UIKit
import Firebase

final class ChatDetailViewController: UIViewController {

    // MARK: - Typealias
    
    typealias ClearHandler = () -> Void
    
    // MARK: - IBOutlet
    
    @IBOutlet private weak var scrollView: UIScrollView!
    @IBOutlet private weak var stackView: UIStackView!
    @IBOutlet private weak var groupImageView: UIImageView!
    @IBOutlet private weak var groupNameInputView: InputView!
    @IBOutlet private weak var setImageButton: UIButton!
    
    // MARK: - Lazy
    
    private lazy var createButton: BaseButton = {
        return BaseButton(title: "Create", onClickHandler: create)
    }()
    
    private lazy var deleteButton: BaseButton = {
        return BaseButton(title: "Delete", onClickHandler: deleteGroup)
    }()
    
    private lazy var clearHistoryButton: BaseButton = {
        return BaseButton(title: "Clear history", onClickHandler: clearHistory)
    }()
    
    // MARK: - Properties
    
    private let textFieldDelegate = TextFieldDelegate()
    private var chat: Chat?
    private var chatsReference: DatabaseReference?
    private var clearHandler: ClearHandler?
    private var imageUrl: String?
    private var imageUrlChanged = false {
        didSet {
            navigationItem.rightBarButtonItem?.isEnabled = imageUrlChanged
        }
    }
    
    // MARK: - Life cycle
    
    deinit {
         cancel()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        setupDatabase()
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
        
        groupNameInputView.configure(title: "Name", delegate: textFieldDelegate, icon: nil, didChanged: textFieldDidChanged)
        groupNameInputView.text = chat?.name
        loadImage(url: URL(string: chat?.imageUrl ?? ""), placeholderImage: Asset.groupPlaceholder.image)
        
        if chat == nil {
            
            title = "Create Chat"
            stackView.addArrangedSubview(createButton)
            createButton.isEnabled = false
        } else {
            
            title = "Chat Detail"
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(save))
            navigationItem.rightBarButtonItem?.isEnabled = false
            stackView.addArrangedSubview(clearHistoryButton)
            stackView.addArrangedSubview(deleteButton)
        }
    }
    
    private func setupDatabase() {
        
        chatsReference = Database.database().reference().child("chats")
        chatsReference?.keepSynced(true)
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
        
        optionMenu.addAction(cameraAction)
        optionMenu.addAction(albumAction)
        optionMenu.addAction(cancelAction)
        
        present(optionMenu, animated: true, completion: nil)
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
    
    // MARK: - Helper Create
    
    @objc private func create() {
        
        guard let name = groupNameInputView.text else {
            return
        }
        
        let chat = Chat(name: name, id: "", imageUrl: "")
        let ref = chatsReference?.childByAutoId()
        ref?.setValue(chat.dictionary)
        
        if let image = groupImageView.image, let id = ref?.key {
            
            StorageService.uploadImage(image, path: id, type: .groupImage) { (url) in
                
                guard let urlString = url?.absoluteString else {
                    return
                }

                ref?.child(Constants.ChatFields.imageUrl).setValue(urlString)
            }
        }
        
        navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Helper Detail
    
    @objc private func deleteGroup() {
        
        guard let chat = chat else {
            return
        }
        
        chatsReference?.child(chat.id).removeValue()
        
        guard let vcCount = navigationController?.viewControllers.count else {
            return
        }
        
        navigationController?.viewControllers.remove(at: vcCount - 2)
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func clearHistory() {
        
        guard let chat = chat else {
            return
        }
        
        chatsReference?.child(chat.id).child(Constants.ChatFields.messages).removeValue()
        clearHandler?()
    }
    
    @objc private func save() {

        guard var chat = chat else {
            return
        }
        
        chat.name = groupNameInputView.text ?? ""
        
        chatsReference?.child(chat.id).setValue(chat.dictionary)
        navigationItem.rightBarButtonItem?.isEnabled = false
        
        guard let image = groupImageView.image else {
            return
        }
        
        StorageService.uploadImage(image, path: chat.id, type: .groupImage) { [weak self] (url) in
            
            guard let urlString = url?.absoluteString else {
                return
            }

            self?.imageUrlChanged = false
            self?.chatsReference?.child(chat.id).child(Constants.ChatFields.imageUrl).setValue(urlString)
        }
    }
    
    // MARK: - Helper
    
    private func textFieldDidChanged() {
        
        if chat == nil {
            createButton.isEnabled = groupNameInputView.isFilled
        } else if let chat = chat{
            navigationItem.rightBarButtonItem?.isEnabled = groupNameInputView.text != chat.name
        }
    }
    
    private func presentImagePicker(with sourceType: UIImagePickerController.SourceType) {
        
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = sourceType
        present(imagePicker, animated: true, completion: nil)
    }
}

// MARK: - StoryboardInitializable

extension ChatDetailViewController: StoryboardInitializable {

    static func makeFromStoryboard() -> ChatDetailViewController {
        return StoryboardScene.Main.chatDetailViewController.instantiate()
    }
    
    static func makeFromStoryboard(with chat: Chat, clearHandler: ClearHandler?) -> ChatDetailViewController {
        
        let vc = StoryboardScene.Main.chatDetailViewController.instantiate()
        vc.clearHandler = clearHandler
        vc.chat = chat
        return vc
    }
}

// MARK: - UIImagePickerControllerDelegate, UINavigationControllerDelegate

extension ChatDetailViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            groupImageView.image = image
            imageUrlChanged = true
        }
        
        dismiss(animated: false, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: false, completion: nil)
    }
}

// MARK: - ImageLoadable

extension ChatDetailViewController: ImageLoadable {
    
    var imageLoadableView: UIImageView {
        return groupImageView
    }
}
