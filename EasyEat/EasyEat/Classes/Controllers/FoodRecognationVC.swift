//
//  FoodRecognationVC.swift
//  EasyEat
//
//  Created by Serhii on 11/24/18.
//  Copyright © 2018 GHW. All rights reserved.
//

import UIKit
import AVFoundation
import Vision

class FoodRecognationVC: UIViewController, AVCaptureVideoDataOutputSampleBufferDelegate {
    
    @IBOutlet weak var mainButtton: UIButton!
    @IBOutlet weak var cameraView: UIView!
    @IBOutlet weak var addmoreButton: UIButton!
    @IBOutlet weak var goToListButton: UIButton!
    @IBOutlet weak var placeImage: UIImageView!
    @IBOutlet weak var pushImage: UIImageView!
    
    
    
//    let captureSession = AVCaptureSession()
    var currentFood: String? {
        didSet {
          foodRecognation = false
        }
    }
    
    let appleLayer: UIImageView =  UIImageView.init(image: UIImage(named: "CameraShape"))
    
    var foodRecognation = false
    var foodList: [String] = [String]()
    
    var presetFood = ["banana":"Banana",
                      "Granny Smith":"Apple",
                      "pineapple, ananas":"Pineapple",
                      "lemon": "Lemon",
                      "cucumber, cuke": "Cucumber",
                      "head cabbage": "Cabbage",
                      "bell pepper": "Papper",
                      "orange": "Mandarine",
                      "mandarine":"Mandarine",
                      ]
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //setupCaptureSession()
        //setupLabel()
        setupButton()
    }
    
    override func viewDidLayoutSubviews() {
        setupCaptureSession()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toList" {
            if let nextViewController = segue.destination as? FoodListVC {
                nextViewController.foodList = foodList
            }
        }
    }
    
    func setupCaptureSession() {
        // search for available capture devices
        let captureSession = AVCaptureSession()
        let availableDevices = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInWideAngleCamera], mediaType: AVMediaType.video, position: .back).devices
        
        // setup capture device, add input to our capture session
        do {
            if let captureDevice = availableDevices.first {
                let captureDeviceInput = try AVCaptureDeviceInput(device: captureDevice)
                captureSession.addInput(captureDeviceInput)
            }
        } catch {
            print(error.localizedDescription)
        }
        
        // setup output, add output to our capture session
        
        let captureOutput = AVCaptureVideoDataOutput()
        captureOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label: "videoQueue"))
        captureSession.addOutput(captureOutput)
        
        let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        let bounds = self.cameraView.layer.bounds;
        previewLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill;
        previewLayer.bounds = bounds;
        previewLayer.position = CGPoint(x: bounds.width, y: bounds.height);
        previewLayer.frame = cameraView.bounds
        
        
        appleLayer.frame = previewLayer.frame
        appleLayer.backgroundColor = UIColor.init(white: 0.5, alpha: 0.0)
        
        previewLayer.addSublayer(appleLayer.layer)
        cameraView.layer.addSublayer(previewLayer)
        
        
        //cameraView.layer.addSublayer(AVCaptureVideoPreviewLayer(session: captureSession))
        //previewLayer.frame = view.frame
        //view.layer.addSublayer(previewLayer)
        
        captureSession.startRunning()
    }
    
    // called everytime a frame is captured
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        if !foodRecognation { return }
        guard let model = try? VNCoreMLModel(for: MobileNet().model) else {return}
        let request = VNCoreMLRequest(model: model) { (finishedRequest, error) in
            
            guard let results = finishedRequest.results as? [VNClassificationObservation] else { return }
            guard let Observation = results.first else { return }
            
            DispatchQueue.main.async(execute: {
                let key = "\(Observation.identifier)"
                print(key)
                if (self.presetFood.keys.contains(key) && self.currentFood != self.presetFood[key] ) {
                    self.currentFood = self.presetFood[key]!
                    self.mainButtton.titleLabel?.text = "\(self.currentFood!)  + ADD TO LIST"
                }
            })
        }
        guard let pixelBuffer: CVPixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return }
        
        // executes request
        try? VNImageRequestHandler(cvPixelBuffer: pixelBuffer, options: [:]).perform([request])
    }
    
    func setupButton() {
        mainButtton.titleLabel?.numberOfLines = 0
        mainButtton.titleLabel?.adjustsFontSizeToFitWidth = true
        mainButtton.titleLabel?.lineBreakMode = NSLineBreakMode.byWordWrapping
    }
    
//    func setupLabel() {
//        label.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
//        label.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50).isActive = true
//    }
    
    
    @IBAction func mainButtonTapped(_ sender: UIButton) {
        placeImage.isHidden = true
        pushImage.isHidden = true
        appleLayer.isHidden = true
        if sender.titleLabel?.text == "START RECOGNATION" {
            foodRecognation = true
            sender.titleLabel?.text = ""
        } else {
            guard let food = currentFood else {return}
            foodRecognation = false
            goToListButton.isHidden = false
            if !foodList.contains(food) {
            foodList.append(food)
            }
        }
}
    
    @IBAction func addMoreButtonTapped(_ sender: UIButton) {
     
    }
    
    @IBAction func goToListButtonTapped(_ sender: UIButton) {
        self.performSegue(withIdentifier: "toList", sender: self)
    }
    
}
