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
import CoreLocation
class AreaViewController:UIViewController,CLLocationManagerDelegate{
    
    var DBRef :DatabaseReference!
    
    
    @IBOutlet weak var mainView: UIView!
    
   
    @IBOutlet weak var naviView: UIView!
    
    
    var afterView : UIView?
     let locationManager = CLLocationManager()
    var x:String?
    var y:String?
    var l_do:String?
    var l_si:String?
    var l_dong:String?
    var loadStatus = false
    
    override func viewDidLoad() {
    
        
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
             /*
        let dateFormatter = DateFormatter()
        
        dateFormatter.locale = Locale(identifier: "ko_KR")
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let date = dateFormatter.string(from: Date())
        
  
   
        DBRef.child("AreaImage").queryOrdered(byChild: "timestamp").queryLimited(toLast: 1).observe(.childAdded) { (DataSnapshot) in
            let value = DataSnapshot.value as? NSDictionary
            
            Storage.storage().reference(withPath: "AreaImage/"+(value?["date"] as! String)+"/"+DataSnapshot.key+".jpg").getData(maxSize: 5*1024*1024 , completion: { iData, error in
                if let Err = error {
                    print(Err)
                }else{
                   
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
                    
                   
                    self.DBRef.child("AreaView").child(DataSnapshot.key).setValue([UserDefaults.standard.value(forKey: "id") as! String:"true"])
                    
                    
                    
                }
            })
        }
    */
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        
        /*
        DBRef.child("AreaImage").child("경기도").child("안양시").child("석수동").child("2019-02-05").queryLimited(toLast: 1).observe(.childAdded , with: { (DataSnapshot) -> Void in
            print(DataSnapshot)
    })
        */
    }
    
    
    override func viewDidDisappear(_ animated: Bool) {
        //DBRef.child("AreaImage").removeAllObservers()
    }
    
    override func viewDidLayoutSubviews() {
      
    }
    
    override func viewWillLayoutSubviews() {
        let storage = Storage.storage()
        DBRef = Database.database().reference()
        
        locationManager.delegate = self
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse{
            startGps()
        }else{
            locationManager.requestWhenInUseAuthorization()
            //권한 취소시
            
        }
    }
    
    func startGps(){
        
        locationManager.startUpdatingLocation()
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if let coor=manager.location?.coordinate{
            self.x=String(coor.latitude)
            self.y=String(coor.longitude)
            
            
            let geo=CLGeocoder()
            let local=Locale(identifier: "Ko-kr")
            geo.reverseGeocodeLocation(CLLocation(latitude: coor.latitude, longitude: coor.longitude), completionHandler: {
                (place,error) in
                self.l_do=place?.last?.administrativeArea
                self.l_si=place?.last?.locality
                self.l_dong=place?.last?.subLocality
                
                self.locationManager.stopUpdatingLocation()
                if (self.l_do! != nil && self.l_si! != nil && self.l_dong! != nil){
                    print("location")
                    
                    self.loadImage()
                }
                
                
            })
        }
        
    }
    
    func loadImage(){
       //child(self.l_do!).child(self.l_si!).child(self.l_dong!)
        
        
        
        
        
         if self.loadStatus == false  {
        self.DBRef.child("ImageAreaV1").child(self.l_do!).queryOrdered(byChild: "timestamp").queryLimited(toLast: 1).observe(.childAdded) { (DataSnapshot) in
           
            
                let value = DataSnapshot.value as? NSDictionary
                print(value)
                Storage.storage().reference(withPath: "AreaImage/"+(value?["date"] as! String)+"/"+DataSnapshot.key+".jpg").getData(maxSize: 5*1024*1024 , completion: { iData, error in
                    if let Err = error {
                        print(Err)
                    }else{
                        
                        
                        
                        
                        
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
                        
                        
                        self.DBRef.child("AreaView").child(DataSnapshot.key).setValue([UserDefaults.standard.value(forKey: "id") as! String:"true"])
                        
                        
                        let labelView = UILabel()
                        labelView.textAlignment = NSTextAlignment.center
                        labelView.text = (value?["do"] as! String) + " " + (value?["si"] as! String) + " " + (value?["dong"] as! String)
                        labelView.backgroundColor = UIColor(displayP3Red: 255, green: 255, blue: 255, alpha: 0.5)
                        labelView.frame = CGRect(x: imageView.frame.maxX-150, y: imageView.frame.maxY-20, width: 150, height: 20)
                        
                        imageView.addSubview(labelView)
                        
                    }
                })
            
            
           
           
        }
             }
        self.loadStatus = true
    }
    
}
