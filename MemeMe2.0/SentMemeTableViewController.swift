//
//  SentMemeTableViewController.swift
//  MemeMe1.0
//
//  Created by Leqi Long on 6/4/16.
//  Copyright © 2016 Student. All rights reserved.
//

import UIKit

class SentMemeTableViewController: UITableViewController {
    
    var memes: [Meme] {
        get{return (UIApplication.sharedApplication().delegate as! AppDelegate).memes}
        set{(UIApplication.sharedApplication().delegate as! AppDelegate).memes = newValue}
    }
    
    struct Constants{
        static let segueToEditorIdentifier = "fromTableToEditor"
        static let reusableCellIdentifier = "SentMemeRow"
        static let memeDetailViewIdentifier = "MemeDetailViewController"
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "＋", style: .Plain, target: self, action: #selector(SentMemesCollectionViewController.editMeme))
        self.navigationItem.title = "Sent Meme"
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
        tableView.separatorStyle = UITableViewCellSeparatorStyle.None
    }
    
    func editMeme(){
        performSegueWithIdentifier(Constants.segueToEditorIdentifier, sender: self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memes.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(Constants.reusableCellIdentifier, forIndexPath: indexPath) as! SentMemeTableViewCell
        let meme = memes[indexPath.row]
        cell.sentMemeImage.image = meme.memeImage
        cell.memeText.text = meme.topText + " " + meme.buttomText
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let detailViewController = storyboard!.instantiateViewControllerWithIdentifier(Constants.memeDetailViewIdentifier) as? MemeDetailViewController
        detailViewController!.meme = memes[indexPath.row]
        navigationController!.pushViewController(detailViewController!, animated: true)
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete{
            memes.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        }
    }


}
