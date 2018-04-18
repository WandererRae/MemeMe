//
//  SavedMemesTableViewController.swift
//  MemeMe
//
//  Created by Bogue Shannon on 4/13/18.
//  Copyright © 2018 Shannon. All rights reserved.
//

import UIKit

class SavedMemesTableViewController: UITableViewController {

    @IBOutlet weak var createNewMemeButton: UIBarButtonItem!
    

    
    // MARK: View Lifecycle

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tableView.reloadData()
    }

    
    
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

    
    // MARK: - Table view protocols

    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return SavedMemes.allSavedMemes.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "SavedMemeTableViewCell", for: indexPath)
        
        if let memeCell = cell as? SavedMemeTableViewCell {
            
            memeCell.savedMemeImage.image = SavedMemes.allSavedMemes[indexPath.row].finishedMemeImage
            memeCell.savedMemeConcatenatedTextLabel.text = "\(SavedMemes.allSavedMemes[indexPath.row].topMemeText) \(SavedMemes.allSavedMemes[indexPath.row].bottomMemeText)"
        }
        
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "ShowMemeDetail", sender: SavedMemes.allSavedMemes[indexPath.row])
    }
}
