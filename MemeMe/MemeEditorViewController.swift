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
    
    // MARK: Meme Editor Definitions
    
    // Storyboard
    
    @IBOutlet weak var entireMemeView: UIView!
    
    @IBOutlet weak var memeImageView: UIImageView!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    
    @IBOutlet weak var toolbar: UIToolbar!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var photoLibraryButton: UIBarButtonItem!
    
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var shareButton: UIBarButtonItem!


    
    // Other
    
    private(set) var finishedMeme: UIImage?
    
    public var originalImage: UIImage?
    
    public var defaultTopText: String = "TOP"
    public var defaultBottomText: String = "BOTTOM"
    
    private let imagePickerController = UIImagePickerController()
    
    
    
    // MARK: View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
               
        topTextField.delegate = self
        bottomTextField.delegate = self
        
        updateTextFields()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        enableButtons()
        
        subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        unsubscribeFromKeyboardNotifications()
    }
    

    
    // MARK: Text Fields
    
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
    
    private func updateTextFields() {
        
        updateMemeTextAttributes(topTextField)
        updateMemeTextAttributes(bottomTextField)
        
        topTextField.text = defaultTopText
        bottomTextField.text = defaultBottomText
    }

    
    
    // MARK: Navigation Bar
    
    @IBAction func cancelMemeCreation(_ sender: UIBarButtonItem) {

        self.dismiss(animated: true)
    }
    
    @IBAction func shareMyMeme() {
        
        generateFinishedMeme()
        
        let shareController = UIActivityViewController(activityItems: [finishedMeme!], applicationActivities: nil)
        
        present(shareController, animated: true)
        
        shareController.completionWithItemsHandler = {(activityType: UIActivityType?, completed: Bool, returnedItems: [Any]?, activityError: Error?) -> Void in
            
            if completed {
                self.save()
            }
        }
    }
    
    private func enableButtons() {
        
        if memeImageView.image != nil {
            
            shareButton.isEnabled = true
            
        } else {
            
            shareButton.isEnabled = false
        }
        
        cameraButton?.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
    }
    
    
    
    // MARK: Finish the meme
    
    private func generateFinishedMeme() {
        
        finishedMeme = entireMemeView.snapshot
    }
    
    private func generateNewMemeIdentity() -> String {
        return String(Date.timeIntervalSinceReferenceDate)
    }
    
    func save() {
        
        generateFinishedMeme()
        
            let newMeme = Meme.init(topMemeText: topTextField.text!, bottomMemeText: bottomTextField.text!, originalImage: memeImageView.image!, finishedMemeImage: finishedMeme!)

            SavedMemes.allSavedMemes.append(newMeme)
    }
    
    
    
    //MARK: Toolbar
    
    @IBAction func photoLibraryImage(_ sender: UIBarButtonItem) {
        
        addImageFromSource(.photoLibrary)
    }
    
    @IBAction func newCameraImage(_ sender: UIBarButtonItem) {
        
        let authStatus = AVCaptureDevice.authorizationStatus(for: AVMediaType.video)
        
        if authStatus == AVAuthorizationStatus.denied {
            
            let alert = UIAlertController(
                title: "Unable to access the Camera",
                message: "To enable access, go to Settings > Privacy > Camera and turn on Camera access for this app.",
                preferredStyle: UIAlertControllerStyle.alert
            )
            
            let okAction = UIAlertAction(
                title: "OK",
                style: .cancel,
                handler: nil
            )
            
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
    
    
    
    //MARK: Image Picker Protocol
    
    private func addImageFromSource(_ sourceType: UIImagePickerControllerSourceType){
        
        imagePickerController.modalPresentationStyle = .currentContext
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = false
        
        switch sourceType {
            
        case .photoLibrary:
            imagePickerController.sourceType = .photoLibrary
            
        case .camera:
            imagePickerController.sourceType = .camera
            
        default: break
        }
        
        present(imagePickerController, animated:true, completion: nil)
    }
    
    func imagePickerController (_ imagePickerController:UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]){
        
        if let selectedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            
            memeImageView.image = selectedImage
        }
        
        imagePickerController.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ imagePickerController:UIImagePickerController){
        
        imagePickerController.dismiss(animated: true, completion: nil)
    }
    
    
    
    //MARK: Text Field and Keyboard Protocol
    
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
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: .UIKeyboardWillHide, object: nil)
    }
    
    private func unsubscribeFromKeyboardNotifications() {
        
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillHide, object: nil)
    }
}



extension UIView {
    var snapshot: UIImage? {
        UIGraphicsBeginImageContext(bounds.size)
        drawHierarchy(in: bounds, afterScreenUpdates: true)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}

