//
//  SentMemesCollectionViewController.swift
//  MemeMe1.0
//
//  Created by Leqi Long on 6/3/16.
//  Copyright © 2016 Student. All rights reserved.
//


import UIKit


class SentMemesCollectionViewController: UICollectionViewController{
    
    
    var memes: [Meme] {
        return (UIApplication.sharedApplication().delegate as! AppDelegate).memes
    }

    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    
    struct Constants{
        static let segueToEditorIdentifier = "fromCollectionToEditor"
        static let reuseableCellIdentifier = "SentMemeItem"
        static let memeDetailViewIdentifier = "MemeDetailViewController"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "＋", style: .Plain, target: self, action: #selector(SentMemesCollectionViewController.editMeme))
        self.navigationItem.title = "Sent Meme"
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        collectionView?.reloadData()
    }
    
    
    func editMeme(){
        performSegueWithIdentifier(Constants.segueToEditorIdentifier, sender: self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    // MARK: UICollectionViewDataSource

    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }


    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return memes.count
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(Constants.reuseableCellIdentifier, forIndexPath: indexPath) as! SentMemeCollectionViewCell
        let meme = memes[indexPath.item]
        cell.sentMemeImage.image = meme.memeImage
    
        return cell
    }
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
            let detailViewController = storyboard!.instantiateViewControllerWithIdentifier(Constants.memeDetailViewIdentifier) as? MemeDetailViewController
            detailViewController!.meme = memes[indexPath.item]
            navigationController!.pushViewController(detailViewController!, animated: true)
    }
    
    
    //when the orientation of the device changes, flowLayout would get recalcualted
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        flowLayout.invalidateLayout()
    }
}

extension SentMemesCollectionViewController: UICollectionViewDelegateFlowLayout{
    func collectionView(collectionView: UICollectionView,
                                   layout collectionViewLayout: UICollectionViewLayout,
                                          sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize{
        let frameSize = collectionView.frame.size
        
        let space: CGFloat = 1.0
        
        let dimension: CGFloat = frameSize.width >= frameSize.height ? (frameSize.width - (3 * space)) / 4.0 : (frameSize.width - (2 * space)) / 3.0
        
        flowLayout.minimumInteritemSpacing = space
        flowLayout.minimumLineSpacing = space
        flowLayout.itemSize = CGSizeMake(dimension, dimension)
        
        return flowLayout.itemSize
        
    }

    
}
