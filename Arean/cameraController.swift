//
//  cameraController.swift
//  Arean
//
//  Created by minwoo jung on 03/02/2019.
//  Copyright © 2019 WW. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation
import Firebase
import CoreLocation


class CameraController:UIViewController,AVCapturePhotoCaptureDelegate,CLLocationManagerDelegate{
    
    
    @IBOutlet weak var camearaView: UIImageView!
    
     var captureSession = AVCaptureSession()
    var stillImageOutput: AVCapturePhotoOutput?
    var previewLayer: AVCaptureVideoPreviewLayer?
    var backCamera: AVCaptureDevice?
    var frontCamera: AVCaptureDevice?
    var currentCamera: AVCaptureDevice?
    var photoOutput:AVCapturePhotoOutput?
    
    var cameraPreviewLayer:AVCaptureVideoPreviewLayer?
    var photoImage : UIImage?
    
    var ableCapture = true
    
    let locationManager = CLLocationManager()
    var x:String?
    var y:String?
    var l_do:String?
    var l_si:String?
    var l_dong:String?


    
    
    @IBAction func takeBt(_ sender: Any) {
        if l_si != nil{
        
        let settingForMonitoring = AVCapturePhotoSettings()
        settingForMonitoring.flashMode = .off
        settingForMonitoring.isAutoStillImageStabilizationEnabled = true
        if ableCapture {
       photoOutput?.capturePhoto(with: settingForMonitoring, delegate: self)
        }
        }
    }
  
    
    override func viewDidLoad() {
        locationManager.delegate = self
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse{
            startGps()
        }else{
            locationManager.requestWhenInUseAuthorization()
      //권한 취소시
            
        }

       
        
        if AVCaptureDevice.authorizationStatus(for: .video) == .authorized{
            setupCaptureSession()
            setupDevice()
            setupInputOutput()
             setupPreviewLayer()
            
        }else {
            AVCaptureDevice.requestAccess(for: .video, completionHandler: {(granted: Bool) in
                if granted {
                    self.setupCaptureSession()
                    self.setupDevice()
                    self.setupInputOutput()
                    self.setupPreviewLayer()
                    
                }else{
                    //권한 취소시
                    
                    
                }
            })
            
        }
        
    }
    
    func startGps(){
        
        locationManager.startUpdatingLocation()
    }
    
    override func viewDidLayoutSubviews() {
   
     
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
   
            startRiunning()
        
    }
    override func viewDidDisappear(_ animated: Bool) {
        stopRiunning()
    }
    
    func setupCaptureSession(){
         captureSession.sessionPreset = AVCaptureSession.Preset.high
        
    }
    func setupDevice(){
        
        let deviceDiscoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [AVCaptureDevice.DeviceType.builtInWideAngleCamera], mediaType: AVMediaType.video, position: AVCaptureDevice.Position.unspecified)
        let devices = deviceDiscoverySession.devices
        
        for device in devices{
            if device.position == AVCaptureDevice.Position.back{
                backCamera=device
                
                do{
                try device.lockForConfiguration()
                device.focusMode = .continuousAutoFocus
                device.unlockForConfiguration()
                }catch{
                    print(error)
                }
            }else if device.position == AVCaptureDevice.Position.front{
                frontCamera=device
            }
            
        }
        
        currentCamera = backCamera
        
        
    }
    func setupInputOutput(){
        do{
            let captureDeviceInput = try AVCaptureDeviceInput(device: currentCamera!)
            captureSession.addInput(captureDeviceInput)
            photoOutput = AVCapturePhotoOutput()
            photoOutput?.setPreparedPhotoSettingsArray([AVCapturePhotoSettings(format: [AVVideoCodecKey:AVVideoCodecType.jpeg])], completionHandler: nil)
            captureSession.addOutput(photoOutput!)
        }catch{
            print(error)
        }
        
    }
    
    func setupPreviewLayer(){
        cameraPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        cameraPreviewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
        cameraPreviewLayer?.connection?.videoOrientation = AVCaptureVideoOrientation.portrait
        cameraPreviewLayer?.frame = self.view.bounds
        self.view.layer.insertSublayer(cameraPreviewLayer!, at: 0)
    }
    
    func startRiunning(){
        captureSession.startRunning()
        
    }
    func stopRiunning(){
        captureSession.stopRunning()
    }
    
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        if let imageData = photo.fileDataRepresentation() {
            ableCapture = false
            photoImage=UIImage(data: imageData)
            CameraControllerData().sendImage(ImageData: imageData, si_l: self.l_si!, do_l: self.l_do!, dong_l: self.l_dong!,x:self.x!,y:self.y!)
        }
        
        let captureImageView=UIImageView()
        
        captureImageView.layer.frame = self.view.bounds
        captureImageView.image=photoImage

        
        self.view.addSubview(captureImageView)
       
        UIView.animate(withDuration: 0.7, delay: 0.25, options: .curveEaseIn, animations: {
            captureImageView.frame.origin.y = self.view.frame.minY - self.view.frame.maxY
        }, completion: {f in self.ableCapture = true
            self.view.willRemoveSubview(captureImageView)
        })
        
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
                
            })
        }
        
    }
    

    
}

