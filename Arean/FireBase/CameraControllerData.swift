//
//  FireBase.swift
//  Arean
//
//  Created by minwoo jung on 04/02/2019.
//  Copyright © 2019 WW. All rights reserved.
//

import Foundation
import FirebaseStorage
import Firebase
import FirebaseDatabase

class CameraControllerData {

    
    let storage = Storage.storage()
    var DBref:DatabaseReference!
    

    
    func sendImage(ImageData : Data,si_l:String,do_l:String,dong_l:String,x:String,y:String){
        
        let storageRef = storage.reference().child("AreaImage")
        
        let dateFormatter = DateFormatter()
     
        
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let date = dateFormatter.string(from: Date())
        
        
        let uuid = UUID().uuidString
       
        let filepath = date+"/"+uuid+".jpg"
        
        let imageRef = storageRef.child(filepath)
        
        let uploadTask = imageRef.putData(ImageData, metadata: nil){
            (metadata, error) in
            if error == nil {
                self.sendDataBase(date:date,uuid: uuid, si_l: si_l, do_l: do_l, dong_l: dong_l,x:x,y:y)
            }
        }
        
       
        


    }
    
    func sendDataBase(date :String,uuid:String,si_l:String,do_l:String,dong_l:String,x:String,y:String){
        DBref = Database.database().reference()
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "Ko_KR")
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let timestamp = dateFormatter.string(from: Date())
        self.DBref.child("AreaImage").child(uuid).setValue([
            "x":x,
            "y":y,
            "date":date,
            "timestamp":timestamp,
            "do":do_l,
            "si":si_l,
            "dong":dong_l
            ])
        //self.DBref.child("Dic").child(do_l).child(si_l).child(dong_l).setValue(["t":"t"])

        
        
    }
    
}
