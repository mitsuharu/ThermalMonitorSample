//
//  CameraView.swift
//  ThermalMonitorSample
//
//  Created by Mitsuharu Emoto on 2023/10/16.
//

import SwiftUI
import Foundation
import AVFoundation

// Viewの定義
struct CameraView: View {
    
    let viewModel = CameraViewModel()
    
    var body: some View {
        Text("AVCaptureDevice.SystemPressureState")
        CameraViewRepresentable(captureSession: viewModel.captureSession).frame(height: 100)
        Text("\(viewModel.stateDescription)")
        Text("\(viewModel.factorDescription)")
    }
}


// Canvasでプレビュー(カメラが接続できないのでクラッシュする)
struct CameraView_Previews: PreviewProvider {
    static var previews: some View {
        EmptyView()
    }
}
