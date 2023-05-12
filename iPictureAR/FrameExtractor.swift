//
//  FrameExtractor.swift
//  iPictureAR
//
//  Created by Marco Signoretto on 16/11/2019.
//  Copyright © 2019 Marco Signoretto. All rights reserved.
//

import Foundation
import AVFoundation
import UIKit

protocol FrameExtractorDelegate : class{
    func captured(image: UIImage)
}

class FrameExtractor: NSObject, AVCaptureVideoDataOutputSampleBufferDelegate{
    
    private let captureSession = AVCaptureSession()
    private let sessionQueue = DispatchQueue(label: "session queue")
    
    private let position = AVCaptureDevice.Position.back
    private let quality = AVCaptureSession.Preset.vga640x480 // This has to be fixed for iPictureAR
    
    private var permissionGranted = false
    
    weak var delegate: FrameExtractorDelegate?
    
    private let context = CIContext()
    
    override init() {
        super.init()
        checkPermission()
        
        sessionQueue.async { [unowned self] in
            self.configureSession()
            self.captureSession.startRunning()
            print("Session started")
        }
    
    }
    
    private func checkPermission(){
        switch AVCaptureDevice.authorizationStatus(for: AVMediaType.video) {
            case .authorized:
            // The user has explicitly granted permission for media capture
                permissionGranted = true
                print("Permission already granted")
                break
            
            case .notDetermined:
                requestPermission()
                print("Permission requested")
                break
            
            default:
            // The user has denied permission
                permissionGranted = false
                print("Permission NOT granted")
                break
        }
    }
    
    private func requestPermission(){
        sessionQueue.suspend()
        // The user has not yet granted or denied permission
            AVCaptureDevice.requestAccess(for: AVMediaType.video) { [unowned self] granted in
                self.permissionGranted = granted
                self.sessionQueue.resume()
            }
    }
    
    private func configureSession(){
        guard permissionGranted else { return }
        captureSession.sessionPreset = quality
        guard let captureDevice = selectCaptureDevice() else { return }
        guard let captureDeviceInput = try? AVCaptureDeviceInput(device: captureDevice) else { return }
        guard captureSession.canAddInput(captureDeviceInput) else { return }
        captureSession.addInput(captureDeviceInput)
        let videoOutput = AVCaptureVideoDataOutput()
        videoOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label: "sample buffer"))
        guard captureSession.canAddOutput(videoOutput) else { return }
        captureSession.addOutput(videoOutput)
        print("Setup Done")
    }
    
    private func selectCaptureDevice() -> AVCaptureDevice? {
        return AVCaptureDevice.devices().filter {
            ($0 as AnyObject).hasMediaType(AVMediaType.video) &&
            ($0 as AnyObject).position == position
        }.first
    }
    
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        print("Got a frame!")
        guard let uiImage = self.imageFromSampleBuffer(sampleBuffer: sampleBuffer) else { return }
//        DispatchQueue.main.async { [unowned self] in
            self.delegate?.captured(image: uiImage)
//        }
    }
    
    private func imageFromSampleBuffer(sampleBuffer: CMSampleBuffer) -> UIImage? {
        guard let imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return nil }
        let ciImage = CIImage(cvPixelBuffer: imageBuffer)
        guard let cgImage = context.createCGImage(ciImage, from: ciImage.extent) else { return nil }
        return UIImage(cgImage: cgImage)
    }
}
