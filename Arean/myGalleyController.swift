//
//  myGalley.swift
//  Arean
//
//  Created by minwoo jung on 09/02/2019.
//  Copyright © 2019 WW. All rights reserved.
//

import Foundation
import UIKit
import FirebaseDatabase
import FirebaseStorage
class myGalleyController:UIViewController{
    
   
    var DBRef:DatabaseReference!
    let userUid = UserDefaults.standard.value(forKey: "id") as! String
    override func viewDidLoad() {
        
        let storage = Storage.storage()
        DBRef = Database.database().reference()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
       
        DBRef.child("AreaGellay").child(userUid).queryOrdered(byChild: "timestamp").observe(.childAdded) { (DataSnapshot) in
            
            print(DataSnapshot.value)
            
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        
    }
}
