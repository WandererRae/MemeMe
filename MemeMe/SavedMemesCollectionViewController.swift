//
//  SavedMemesCollectionViewController.swift
//  MemeMe
//
//  Created by Bogue Shannon on 4/13/18.
//  Copyright © 2018 Shannon. All rights reserved.
//

import UIKit

private let reuseIdentifier = "SavedMemeCell"

class SavedMemesCollectionViewController: UICollectionViewController {
    
    @IBOutlet weak var createNewMemeButton: UIBarButtonItem!

    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
    }

    

    // MARK: - Navigation


    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return SavedMemes.allSavedMemes.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SavedMemeCell", for: indexPath)
            
        if let memeCell = cell as? SavedMemeCollectionViewCell {
            memeCell.savedMemeImageView.image = SavedMemes.allSavedMemes[indexPath.item].finishedMemeImage
        }
        
        return cell
    }

    // MARK: UICollectionViewDelegate
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let memeEditor = self.storyboard!.instantiateViewController(withIdentifier: "MemeEditorViewController") as! MemeEditorViewController
        memeEditor.memeImageView.image = SavedMemes.allSavedMemes[indexPath.row].originalImage
        memeEditor.topTextField.text = SavedMemes.allSavedMemes[indexPath.row].topMemeText
        memeEditor.bottomTextField.text = SavedMemes.allSavedMemes[indexPath.row].bottomMemeText
    }
}
