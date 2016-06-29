//
//  MemeDetailViewController.swift
//  MemeMe1.0
//
//  Created by Leqi Long on 6/4/16.
//  Copyright © 2016 Student. All rights reserved.
//

import UIKit

class MemeDetailViewController: UIViewController {
    
    var meme: Meme!

    @IBOutlet weak var memeDetailImageView: UIImageView!
    
    let segueIdentifier = "fromDetailViewToEditor"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        memeDetailImageView.image = meme.memeImage
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Edit", style: .Plain, target: self, action:#selector(MemeDetailViewController.editSentMeme))

    }
    
    func editSentMeme(){
        performSegueWithIdentifier(segueIdentifier, sender: self)
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == segueIdentifier{
            if let editorVC = segue.destinationViewController as? MemeEditorViewController{
                editorVC.isEditingSentMeme = true
                editorVC.sentMemeToBeEdited = meme
            }
        }
    }

}
