//
//  MemeDetailViewController.swift
//  MemeMe
//
//  Created by Bogue Shannon on 4/18/18.
//  Copyright © 2018 Shannon. All rights reserved.
//

import UIKit

class MemeDetailViewController: UIViewController {

    @IBOutlet weak var memeDetailImageView: UIImageView!
    
    public var meme: Meme?
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.memeDetailImageView.image = meme?.finishedMemeImage
    }
}
