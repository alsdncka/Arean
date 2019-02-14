//
//  tabViewController.swift
//  Arean
//
//  Created by minwoo jung on 09/02/2019.
//  Copyright © 2019 WW. All rights reserved.
//

import Foundation
import UIKit

class tabViewController:UITabBarController{
    
    override func viewDidLoad() {
     
        let id = UserDefaults.standard.value(forKey: "id")
        
        if id == nil {
            
            UserDefaults.standard.set( UUID().uuidString, forKey: "id")
            
        }
    }
}
