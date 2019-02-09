//
//  areaView.swift
//  Arean
//
//  Created by minwoo jung on 04/02/2019.
//  Copyright © 2019 WW. All rights reserved.
//

import Foundation
import UIKit
import FirebaseDatabase
import FirebaseStorage
class AreaViewController:UIViewController{
    
    var DBRef :DatabaseReference!
    
    
    @IBOutlet weak var mainView: UIView!
    
    var afterView : UIView?
    
    
    override func viewDidLoad() {
         let storage = Storage.storage()
        DBRef = Database.database().reference()
        
        /*
        DBRef.child("Dic").observe(.childAdded) { (do_Snapshot) in
            
            self.DBRef.child("Dic").child(do_Snapshot.key).observe(.childAdded, with: { (si_Snapshot) in
                
                self.DBRef.child("Dic").child(do_Snapshot.key).child(si_Snapshot.key).observe(.childAdded, with: { (dong_Snapshot) in
                    
                    self.DBRef.child("Dic").child(do_Snapshot.key).child(si_Snapshot.key).child(dong_Snapshot.key).observe(.childAdded, with: { (data_Snapshot) in
                        
                        let dateFormatter = DateFormatter()
                        
                        dateFormatter.locale = Locale(identifier: "ko_KR")
                        dateFormatter.dateFormat = "yyyy-MM-dd"
                        let date = dateFormatter.string(from: Date())
                        
                        
                        self.DBRef.child("AreaImage").child(do_Snapshot.key).child(si_Snapshot.key).child(dong_Snapshot.key).child(date).queryOrdered(byChild: "timestamp").queryLimited(toLast: 1).observe(.childAdded, with: { (DataSnapshot) in
                            
                            Storage.storage().reference(withPath: "AreaImage/"+date+"/"+DataSnapshot.key+".jpg").getData(maxSize: 5*1024*1024 , completion: { iData, error in
                                if let Err = error {
                                    print(Err)
                                }else{
                                    print(DataSnapshot.key)
                                    let image = UIImage(data: iData!)
                                    let imageView = UIImageView()
                                    imageView.image=image
                                    let beFrame = CGRect(x: 0, y: (self.mainView.frame.maxY+self.mainView.frame.height)*(-1), width: self.mainView.frame.width, height: self.mainView.frame.height)
                                    imageView.frame = beFrame
                                    self.mainView.addSubview(imageView)
                                    
                                 
                                    UIView.animate(withDuration: 2, animations: {
                                         imageView.frame = self.mainView.frame
                                    }, completion: { (Bool) in
                                        if self.afterView != nil {
                                        self.mainView.willRemoveSubview(self.afterView!)
                                        }
                                    })
                                    self.afterView = imageView
                                    
                                }
                            })
                        }, withCancel: { (Error) in
                            print(Error)
                        })
                        
                        
                    })
                    
                })
            })
            
            
        }*/
        
        let dateFormatter = DateFormatter()
        
        dateFormatter.locale = Locale(identifier: "ko_KR")
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let date = dateFormatter.string(from: Date())
        
        DBRef.child("AreaImage").queryOrdered(byChild: "timestamp").queryLimited(toLast: 1).observe(.childAdded) { (DataSnapshot) in
            
            Storage.storage().reference(withPath: "AreaImage/"+date+"/"+DataSnapshot.key+".jpg").getData(maxSize: 5*1024*1024 , completion: { iData, error in
                if let Err = error {
                    print(Err)
                }else{
                    print(DataSnapshot.key)
                    let image = UIImage(data: iData!)
                    let imageView = UIImageView()
                    imageView.image=image
                    let beFrame = CGRect(x: 0, y: (self.mainView.frame.maxY+self.mainView.frame.height)*(-1), width: self.mainView.frame.width, height: self.mainView.frame.height)
                    imageView.frame = beFrame
                    self.mainView.addSubview(imageView)
                    
                    
                    UIView.animate(withDuration: 2, animations: {
                        imageView.frame = self.mainView.frame
                    }, completion: { (Bool) in
                        if self.afterView != nil {
                            self.mainView.willRemoveSubview(self.afterView!)
                        }
                    })
                    self.afterView = imageView
                    
                }
            })
        }
    
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        
    
        
        /*
        DBRef.child("AreaImage").child("경기도").child("안양시").child("석수동").child("2019-02-05").queryLimited(toLast: 1).observe(.childAdded , with: { (DataSnapshot) -> Void in
            print(DataSnapshot)
    })
        */
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        DBRef.child("AreaImage").removeAllObservers()
    }
}
