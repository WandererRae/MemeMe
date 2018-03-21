//
//  MemeEditorViewController.swift
//  MemeMe
//
//  Created by Shannon on 2/16/18.
//  Copyright © 2018 Shannon. All rights reserved.
//

import UIKit
import AVFoundation

class MemeEditorViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    
    //MARK: Meme Editor View Setup
    @IBOutlet weak var memeImageView: UIImageView!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var photoLibraryButton: UIBarButtonItem!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    @IBOutlet weak var toolbar: UIToolbar!
    
    private var defaultTopText: String = "TOP"
    private var defaultBottomText: String = "BOTTOM"
    
    private(set) var finishedMeme: UIImage!
    
    private let imagePickerController = UIImagePickerController()
    
    private func updateMemeTextAttributes (_ textField: UITextField) {
        let centerText = NSMutableParagraphStyle()
        centerText.alignment = .center
        let memeTextAttributes: [String:Any] = [
            NSAttributedStringKey.strokeColor.rawValue: UIColor.black,
            NSAttributedStringKey.foregroundColor.rawValue: UIColor.white,
            NSAttributedStringKey.font.rawValue: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
            NSAttributedStringKey.strokeWidth.rawValue: -6.0,
            NSAttributedStringKey.paragraphStyle.rawValue: centerText
        ]
        textField.defaultTextAttributes = memeTextAttributes
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navBarButtons()
        topTextField.delegate = self
        bottomTextField.delegate = self
        updateMemeTextAttributes(topTextField)
        updateMemeTextAttributes(bottomTextField)
        resetMemeEditor()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        enableShareButton()
        subscribeToKeyboardNotifications()
    }
    
    //MARK: Navigation Bar actions
    private func navBarButtons () {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(resetMemeEditor))
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareMyMeme))
    }
    
    @objc private func resetMemeEditor() {
        memeImageView.image = nil
        enableShareButton()
        topTextField.text = defaultTopText
        bottomTextField.text = defaultBottomText
    }
    
    @objc private func shareMyMeme() {
        finishedMeme = generateFinishedMeme()
        let shareController = UIActivityViewController(activityItems: [finishedMeme], applicationActivities: nil)
        present(shareController, animated: true)
        shareController.completionWithItemsHandler = {(
            activityType: UIActivityType?,
            completed: Bool,
            returnedItems: [Any]?,
            activityError: Error?
            ) -> Void in
            if completed {
                self.save()
            }
        }
    }
    
    private func enableShareButton() {
        navigationItem.leftBarButtonItem?.isEnabled = (memeImageView.image != nil) ? true : false
    }
    
    //MARK: Toolbar actions
    @IBAction func photoLibraryImage(_ sender: UIBarButtonItem) {
        addImageFromSource(.photoLibrary)
    }
    
    @IBAction func newCameraImage(_ sender: UIBarButtonItem) {
        let authStatus = AVCaptureDevice.authorizationStatus(for: AVMediaType.video)
        if authStatus == AVAuthorizationStatus.denied {
            let alert = UIAlertController(title: "Unable to access the Camera",
                                          message: "To enable access, go to Settings > Privacy > Camera and turn on Camera access for this app.",
                                          preferredStyle: UIAlertControllerStyle.alert)
            
            let okAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alert.addAction(okAction)
            let settingsAction = UIAlertAction(title: "Settings", style: .default, handler: { _ in
                guard let settingsUrl = URL(string: UIApplicationOpenSettingsURLString) else { return }
                if UIApplication.shared.canOpenURL(settingsUrl) {
                    UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                    })
                }
            })
            alert.addAction(settingsAction)
            
            present(alert, animated: true, completion: nil)
        } else if (authStatus == AVAuthorizationStatus.notDetermined) {
            AVCaptureDevice.requestAccess(for: AVMediaType.video, completionHandler: { (granted) in
                if granted {
                    self.addImageFromSource(.camera)
                }
            })
        } else {
            addImageFromSource(.camera)
        }
    }
    
    
    
    //MARK: Selecting an Image
    private enum ImageLocation {case photoLibrary, camera}
    
    private func addImageFromSource(_ sourceType: ImageLocation){
        imagePickerController.modalPresentationStyle = .currentContext
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
        switch sourceType {
        case .photoLibrary:
            imagePickerController.sourceType = .photoLibrary
        case .camera:
            imagePickerController.sourceType = .camera
        }
        present(imagePickerController, animated:true, completion: nil)
    }
    
    func imagePickerController (_ imagePickerController:UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]){
        if let selectedImage = info[UIImagePickerControllerEditedImage] as? UIImage {
            memeImageView.image = selectedImage
        }
        imagePickerController.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ imagePickerController:UIImagePickerController){
        imagePickerController.dismiss(animated: true, completion: nil)
    }
    
    //MARK: Keyboard and textfield behavior
    internal func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @objc private func keyboardWillShow(_ notification: Notification) {
        navigationController?.navigationBar.isHidden = true
        toolbar.isHidden = true
        if topTextField.isFirstResponder {
            if topTextField.text == defaultTopText {
                topTextField.text = ""
            }
        }
        if bottomTextField.isFirstResponder{
            view.frame.origin.y = -getKeyboardHeight(notification)
            if bottomTextField.text == defaultBottomText {
                bottomTextField.text = ""
            }
        }
    }
    
    @objc private func keyboardWillHide (_ notification: Notification) {
        view.frame.origin.y = 0
        navigationController?.navigationBar.isHidden = false
        toolbar.isHidden = false
        if topTextField.text == "" {
            topTextField.text = defaultTopText
        }
        if bottomTextField.text == "" {
            bottomTextField.text = defaultBottomText
        }
    }
    
    private func getKeyboardHeight(_ notification:Notification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.cgRectValue.height
    }
    
    private func subscribeToKeyboardNotifications() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow(_:)),
            name: .UIKeyboardWillShow,
            object: nil
        )
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide(_:)),
            name: .UIKeyboardWillHide,
            object: nil
        )
    }
    
    private func unsubscribeFromKeyboardNotifications() {
        NotificationCenter.default.removeObserver(
            self,
            name: .UIKeyboardWillShow,
            object: nil
        )
        NotificationCenter.default.removeObserver(
            self,
            name: .UIKeyboardWillHide,
            object: nil
        )
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }
    
    //MARK: Finish the meme
    private func generateFinishedMeme() -> UIImage {
        toolbar.isHidden = true
        navigationController?.navigationBar.isHidden = true
        
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let finishedMeme:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        toolbar.isHidden = false
        navigationController?.navigationBar.isHidden = false
        
        return finishedMeme
    }
    
    func save() {
        _ = Meme.init(topMemeText: topTextField.text, bottomMemeText: bottomTextField.text, originalImage: memeImageView.image!, finishedMeme: finishedMeme)
    }
    
}

