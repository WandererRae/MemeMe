//
//  Meme.swift
//  MemeMe
//
//  Created by Shannon on 3/20/18.
//  Copyright © 2018 Shannon. All rights reserved.
//

import Foundation

struct Meme: Codable {
    
    var memeUniqueIdentity: String
    
    var topMemeText: String
    var bottomMemeText: String
    
    var originalImageData: Data

    var finishedMemeImageData: Data
    
    
    
    
    
    
    var json: Data? {
        
        return try? JSONEncoder().encode(self)
    }
    
    
    
    init? (json: Data) {
        
        if let newValue = try? JSONDecoder().decode(Meme.self, from: json) {
            
            self = newValue
            
        } else {
            
            return nil
        }
    }
    
    init (memeUniqueIdentity: String, topMemeText: String, bottomMemeText: String, originalImageData: Data, finishedMemeImageData: Data) {
        
        self.memeUniqueIdentity = memeUniqueIdentity
        self.topMemeText = topMemeText
        self.bottomMemeText = bottomMemeText
        self.originalImageData = originalImageData
        self.finishedMemeImageData = finishedMemeImageData
    }
}

