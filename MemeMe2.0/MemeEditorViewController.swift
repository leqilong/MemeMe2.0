//
//  ViewController.swift
//  MemeMe1.0
//
//  Created by Leqi Long on 5/31/16.
//  Copyright © 2016 Student. All rights reserved.
//

import UIKit

class MemeEditorViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate, UIPopoverPresentationControllerDelegate, FontsPickerViewControllerDelegate{
    
    @IBOutlet weak var imagePickerView: UIImageView!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var buttomTextField: UITextField!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var buttomToolBar: UIToolbar!
    @IBOutlet weak var topToolBar: UIToolbar!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    
//default font on launch is "HelveticaNeue-CondensedBlack", chosenFont reflects the user's own choice
    
    struct SegueIdentifier{
        static let toSentMeme = "fromEditorToSentMeme"
        static let showFonts = "showFonts"
    }
    
    var sentMemeToBeEdited: Meme!
    var isEditingSentMeme = false
    var chosenFont = "HelveticaNeue-CondensedBlack"{
        willSet(newValue){
            print("About to set new font to \(newValue)")
        }
    }
    
    var memeTextAttributes = [
        NSStrokeColorAttributeName: UIColor.blackColor(),
        NSForegroundColorAttributeName: UIColor.whiteColor(),
        NSFontAttributeName : UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSStrokeWidthAttributeName: -3.0,
        ]
    
    let textFieldDelegate = TextFieldDelegate()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        subscribeToKeyboardNotifications()
        shareButton.enabled = false
        configureLaunchScreen()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        cameraButton.enabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
        if isEditingSentMeme{
            topTextField.text = sentMemeToBeEdited.topText
            buttomTextField.text = sentMemeToBeEdited.buttomText
            imagePickerView.image = sentMemeToBeEdited.originalImage
            shareButton.enabled = true
        }
    }
    
    
    func configureLaunchScreen(){
        imagePickerView.image = nil
        topTextField.text = "TOP"
        buttomTextField.text = "Bottom"
        setTextAttributesAndDelegates(topTextField)
        setTextAttributesAndDelegates(buttomTextField)
        let topTextGesture = UIPanGestureRecognizer(target: self, action: #selector(MemeEditorViewController.topTextDragged))
        let bottomTextGesture = UIPanGestureRecognizer(target: self, action: #selector(MemeEditorViewController.bottomTextDragged))
        topTextField.addGestureRecognizer(topTextGesture)
        buttomTextField.addGestureRecognizer(bottomTextGesture)
    }
    
    
    func setTextAttributesAndDelegates(textField: UITextField){
        textField.defaultTextAttributes = memeTextAttributes
        textField.textAlignment = .Center
        textField.delegate = textFieldDelegate
        textField.userInteractionEnabled = true
    }
    
    
// MARK -Textfields and keyboard settings
    
    func topTextDragged(topTextGesture: UIPanGestureRecognizer){
        let loc = topTextGesture.locationInView(self.view)
        self.topTextField.center = loc
    }
    
    func bottomTextDragged(bottomTextGesture: UIPanGestureRecognizer){
        let loc = bottomTextGesture.locationInView(self.view)
        self.buttomTextField.center = loc
    }
    
    override func viewWillDisappear(animated: Bool) {
        self.unsubscribeFromKeyboardNotification()
    }

    func keyboardWillShow(notification: NSNotification){
        if buttomTextField.isFirstResponder(){
            view.frame.origin.y = getKeyboardHeight(notification) * (-1)
        }
    }
    
    func keyboardWillHide(notification: NSNotification){
        if buttomTextField.isFirstResponder(){
            view.frame.origin.y = 0
        }
    }
    
    func getKeyboardHeight(notification: NSNotification) -> CGFloat{
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue //of CGRect
        return keyboardSize.CGRectValue().height
    }
    
    func subscribeToKeyboardNotifications(){
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(MemeEditorViewController.keyboardWillShow(_:)), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(MemeEditorViewController.keyboardWillHide(_:)), name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func unsubscribeFromKeyboardNotification(){
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardDidShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardDidHideNotification, object: nil)
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
  
// MARK -choose an image, from camera or album
    @IBAction func pickAnImage(sender: AnyObject) {
        showImagePicker(UIImagePickerControllerSourceType.PhotoLibrary)
    }
 
    @IBAction func takeAPicFromCamera(sender: AnyObject) {
        showImagePicker(UIImagePickerControllerSourceType.Camera)
    }
    
    
    func showImagePicker(imageSource: UIImagePickerControllerSourceType){
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        switch imageSource{
        case UIImagePickerControllerSourceType.PhotoLibrary:
            self.presentViewController(imagePicker, animated: true, completion:
                nil)
        case UIImagePickerControllerSourceType.Camera:
            self.presentViewController(imagePicker, animated: true, completion:
                nil)
        default:
            break
        }
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imagePickerView.image = image
            shareButton.enabled = true
        }
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
// MARK -create the meme object and save
    func save(memedImage: UIImage){
        
        //create the meme
        let meme = Meme(topText: topTextField.text!, buttomText: buttomTextField.text!, originalImage: imagePickerView.image!, memeImage: memedImage)
        
        (UIApplication.sharedApplication().delegate as! AppDelegate).memes.append(meme)
    }
    
    func generateMemedImage() -> UIImage
    {
       
        //temporarly hide the tool bars so they do not become part of the memed image
        topToolBar.hidden = true
        buttomToolBar.hidden = true
        
        var memedImage: UIImage?
        
        if view.bounds.width > view.bounds.height && imagePickerView.image!.size.width > imagePickerView.image!.size.height{
            memedImage = imagePickerView.image!.resizeToWidth(imagePickerView)
        }else if view.bounds.width < view.bounds.height && imagePickerView.image!.size.width < imagePickerView.image!.size.height{
            memedImage = imagePickerView.image!.resizeToHeight(imagePickerView)
        }else if view.bounds.width < view.bounds.height && imagePickerView.image!.size.width > imagePickerView.image!.size.height{
            memedImage = imagePickerView.image!.resizeToHeight(imagePickerView)
        }else if view.bounds.width > view.bounds.height && imagePickerView.image!.size.width < imagePickerView.image!.size.height{
            memedImage = imagePickerView.image!.resizeToWidth(imagePickerView)
        }

        topToolBar.hidden = false
        buttomToolBar.hidden = false
        return memedImage!
    }
    
    
    @IBAction func shareMeme(sender: AnyObject) {
        
        let memedImage = generateMemedImage()
        
        let activityViewController = UIActivityViewController(activityItems: [memedImage], applicationActivities: nil)
        
        self.presentViewController(activityViewController, animated: true, completion: nil)
        
        activityViewController.completionWithItemsHandler = {
            
            (s: String?, ok: Bool, items: [AnyObject]?, err:NSError?) -> Void in
            
            if ok{
                self.save(memedImage)
                
                activityViewController.dismissViewControllerAnimated(true, completion: nil)
                
                self.seeSentMeme()
            }
        }

    }
    
    
    @IBAction func cancelMeme(sender: AnyObject) {
        topTextField.resignFirstResponder()
        buttomTextField.resignFirstResponder()
        seeSentMeme()
    }
    
    func seeSentMeme(){
        dismissViewControllerAnimated(true, completion: nil)
    }
    

//MARK -segue to fonts picker view
    
    @IBAction func pickFont(sender: AnyObject) {
        performSegueWithIdentifier(SegueIdentifier.showFonts, sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == SegueIdentifier.showFonts{
            let fpvc = segue.destinationViewController as! FontsPickerViewController
            
            fpvc.delegate = self
            fpvc.savedFont = chosenFont 
            
            let fontsPickerPopover = fpvc.popoverPresentationController
            
            if fontsPickerPopover != nil{
                fpvc.preferredContentSize = CGSizeMake(self.view.frame.width, self.view.frame.height / 2)
                fontsPickerPopover?.delegate = self
            }
        }
    }
    
    func userSelectedFont(fontName: String){
        chosenFont = fontName
        topTextField.font = UIFont(name: chosenFont, size: 40)
        buttomTextField.font = UIFont(name: chosenFont, size: 40)
    }
    
    //Make the popover show up not only on iPad but also iPhone
    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle {
        return .None
    }
}

