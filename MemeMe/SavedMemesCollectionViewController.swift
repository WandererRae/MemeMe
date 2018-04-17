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
    
    private var selectedMeme: Meme?
    
    
    // MARK: View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(SavedMemes.allSavedMemes.count)

        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
    }

    

    // MARK: - Navigation
    
    @IBAction func createNewMeme(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "ShowMemeEditor", sender: createNewMemeButton)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowMemeEditor" {
            if (sender as? Meme) != nil { // The only way to get to this is by selecting a meme
                if let memeEditor = (segue.destination as? MemeEditorViewController) {
                    memeEditor.originalImage = selectedMeme?.originalImage
                    memeEditor.defaultTopText = (selectedMeme?.topMemeText)!
                    memeEditor.defaultBottomText = (selectedMeme?.bottomMemeText)!
                }
            }
        }
    }


    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    
    // MARK: CollectionView Protocol

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
        selectedMeme = SavedMemes.allSavedMemes[indexPath.item]
        performSegue(withIdentifier: "ShowMemeEditor", sender: selectedMeme)
    }
}
