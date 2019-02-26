//
//  collcell.swift
//  Arean
//
//  Created by minwoo jung on 27/02/2019.
//  Copyright © 2019 WW. All rights reserved.
//

import Foundation
import UIKit

import FirebaseStorage

class collcell:UICollectionViewCell{
    
    @IBOutlet weak var imageView: UIImageView!
    
    
    var cellDate : String?
    var cellData : String?{
        didSet{
        setImage()
        }
    }
    
    
    
    
    func setImage(){

         let storage = Storage.storage()
        
        storage.reference(withPath: "AreaImage/"+(cellDate!.split(separator: " ")[0])+"/"+cellData!+".jpg").getData(maxSize: 5*1024*1024 , completion: { iData, error in
            if let Err = error {
                print(Err)
            }else{
                
                self.imageView.image=UIImage(data: iData!)
                
            }
    })
    }
    
    
    
    
    
}
