//
//  SavedMemesCollectionViewController.swift
//  MemeMe
//
//  Created by Bogue Shannon on 4/13/18.
//  Copyright © 2018 Shannon. All rights reserved.
//

import UIKit

class SavedMemesCollectionViewController: UICollectionViewController {
    
    @IBOutlet weak var createNewMemeButton: UIBarButtonItem!
    
<<<<<<< Updated upstream
=======
    private var selectedMeme: Meme?

>>>>>>> Stashed changes
    
    
    // MARK: View Lifecycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
<<<<<<< Updated upstream
        collectionView?.reloadData()
    }

    
    
=======
        print(SavedMemes.allSavedMemes.count)
        
        
        
        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.collectionView?.reloadData()
    }

>>>>>>> Stashed changes
    // MARK: - Navigation
    
    @IBAction func createNewMeme(_ sender: UIBarButtonItem) {
        
        performSegue(withIdentifier: "ShowMemeEditor", sender: createNewMemeButton)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "ShowMemeDetail" {
            
            if let selectedMeme = sender as? Meme {
                
                if let memeDetailController = segue.destination as? MemeDetailViewController {
                    
                    memeDetailController.meme = selectedMeme
                }
            }
        }
    }


    
    // MARK: - Collection view protocols

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return SavedMemes.allSavedMemes.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SavedMemeCollectionViewCell", for: indexPath)

        if let memeCell = cell as? SavedMemeCollectionViewCell {

            memeCell.savedMemeImageView.image = SavedMemes.allSavedMemes[indexPath.item].finishedMemeImage
        }

        return cell
    }

    // MARK: UICollectionViewDelegate
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "ShowMemeDetail", sender: SavedMemes.allSavedMemes[indexPath.item])
    }
}
