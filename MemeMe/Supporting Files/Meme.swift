//
//  Meme.swift
//  MemeMe
//
//  Created by Shannon on 3/20/18.
//  Copyright © 2018 Shannon. All rights reserved.
//

import Foundation
import UIKit

struct Meme {
        
    var topMemeText: String
    var bottomMemeText: String
    
    var originalImage: UIImage

    var finishedMemeImage: UIImage
    

    init (topMemeText: String, bottomMemeText: String, originalImage: UIImage, finishedMemeImage: UIImage) {
        
        self.topMemeText = topMemeText
        self.bottomMemeText = bottomMemeText
        self.originalImage = originalImage
        self.finishedMemeImage = finishedMemeImage
    }
}

