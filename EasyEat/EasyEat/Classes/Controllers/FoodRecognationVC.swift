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
    
    
    var currentFood: String?
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
    
    func setupCaptureSession() {
        let captureSession = AVCaptureSession()
        
        // search for available capture devices
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
        previewLayer.frame = cameraView.bounds
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
                if (self.presetFood.keys.contains(key) && self.currentFood != self.presetFood[key] ) {
                    self.currentFood = self.presetFood[key]
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
        foodRecognation = !foodRecognation
        if !foodRecognation {
            mainButtton.titleLabel?.text = "START RECOGNATION"
        } else {
            guard let food = currentFood else {return}
            foodList.append(food)
        }
    }
    
}
