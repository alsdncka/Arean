//
//  mapViewController.swift
//  Arean
//
//  Created by minwoo jung on 17/02/2019.
//  Copyright © 2019 WW. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class mapViewController:UIViewController,MKMapViewDelegate{
    
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        
        mapView.delegate=self
        
    
        
    }
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        print("A")
    }

    
    
}

