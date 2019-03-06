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

class myGalleyController:UIViewController,UICollectionViewDelegate,UICollectionViewDataSource{
  
    
   
    var DBRef:DatabaseReference!
    var userUid:String?
    var images:[String]=[]
     var imageDate:[String]=[]
    @IBOutlet weak var collView: UICollectionView!
    
    override func viewDidLoad() {
        
        collView.delegate=self
        collView.dataSource=self
        let storage = Storage.storage()
        DBRef = Database.database().reference()
        
        userUid = UserDefaults.standard.value(forKey: "id") as! String
    }
    
    override func viewDidAppear(_ animated: Bool) {
       
        DBRef.child("AreaGellay").child(userUid!).queryOrdered(byChild: "timestamp").observe(.childAdded) { (DataSnapshot) in
            
           
            
            self.collView.performBatchUpdates({
                
                let value = DataSnapshot.value as? NSDictionary
                let index = IndexPath(row: self.images.count, section: 0)
                self.imageDate.append(value?["timestamp"] as! String)
                 self.images.append(DataSnapshot.key)
                self.collView.insertItems(at: [index])
                
            }, completion: nil)
            
        }
        /*
        
        */
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! collcell
        cell.cellDate=self.imageDate[indexPath.row]
        cell.cellData=self.images[indexPath.row]
        
        return cell
        
    }
    
}
