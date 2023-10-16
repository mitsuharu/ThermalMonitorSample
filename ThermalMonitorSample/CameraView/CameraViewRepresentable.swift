//
//  CameraViewRepresentable.swift
//  ThermalMonitorSample
//
//  Created by Mitsuharu Emoto on 2023/10/16.
//

import UIKit
import SwiftUI
import AVFoundation

class PreviewView: UIView {
    
    override class var layerClass: AnyClass {
        return AVCaptureVideoPreviewLayer.self
    }
    
    var videoPreviewLayer: AVCaptureVideoPreviewLayer {
        return layer as! AVCaptureVideoPreviewLayer
    }
    
}

struct CameraViewRepresentable: UIViewRepresentable {
    
    typealias UIViewControllerType = PreviewView
    let captureSession: AVCaptureSession
    
    func makeUIView(context: Context) ->  UIViewControllerType {
        let previewView = PreviewView()
        previewView.videoPreviewLayer.session = captureSession
        return previewView
    }
    
    func updateUIView(_ uiViewController:  UIViewControllerType, context: Context) {
    }
    
}
