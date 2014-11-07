//
//  ViewControllerAvatar.swift
//  KegCop
//
//  Created by capin on 11/5/14.
//
//

import UIKit
import AVFoundation

class ViewControllerAvatar: UIViewController {
    
    @IBOutlet weak var frameForCapture: UIView!
    @IBOutlet weak var imageView: UIImageView!
    
    
    var session = AVCaptureSession()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        println("begin viewDidLoad in ViewControllerAvatar.swift")
        
        session.sessionPreset = AVCaptureSessionPresetPhoto
        
        var inputDevice : AVCaptureDeviceInput! = nil
        var err : NSError?
        
        var devices : [AVCaptureDevice] = AVCaptureDevice.devices() as [AVCaptureDevice]
        
        for device in devices {
            if device.hasMediaType(AVMediaTypeVideo) && device.supportsAVCaptureSessionPreset(AVCaptureSessionPresetPhoto) {
                
                inputDevice = AVCaptureDeviceInput.deviceInputWithDevice(device as AVCaptureDevice, error: &err) as AVCaptureDeviceInput
                
                if session.canAddInput(inputDevice) {
                    session.addInput(inputDevice)
                    break
                }
            }
        }
        
        var output = AVCaptureVideoDataOutput()

        output.alwaysDiscardsLateVideoFrames = true
        
        if session.canAddOutput(output) {
            session.addOutput(output)
        }
        
        var captureLayer = AVCaptureVideoPreviewLayer(session: session)
        captureLayer.frame = frameForCapture.bounds
        frameForCapture.layer.addSublayer(captureLayer)
    } // viewDidLoad
    
    
    
    @IBAction func takePhoto(sender: AnyObject) {
        
    }
}