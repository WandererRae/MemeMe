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
    
//    var memeUniqueIdentity: String
    
    var topMemeText: String
    var bottomMemeText: String
    
    var originalImageData: Data
    var originalImage: UIImage

    var finishedMemeImageData: Data
    var finishedMemeImage: UIImage
    
    
    
    
    
//
//    var json: Data? {
//
//        return try? JSONEncoder().encode(self)
//    }
//
//
    
//    init? (json: Data) {
//
//        if let newValue = try? JSONDecoder().decode(Meme.self, from: json) {
//
//            self = newValue
//
//        } else {
//
//            return nil
//        }
//    }
    
    init (
        topMemeText: String,
        bottomMemeText: String,
        
        originalImageData: Data,
        originalImage: UIImage,
        
        finishedMemeImageData: Data,
        finishedMemeImage: UIImage
        ) {
        
        self.topMemeText = topMemeText
        self.bottomMemeText = bottomMemeText
        self.originalImageData = originalImageData
        self.originalImage = originalImage
        self.finishedMemeImageData = finishedMemeImageData
        self.finishedMemeImage = finishedMemeImage
    }
}

