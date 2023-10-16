//
//  CameraViewModel.swift
//  ThermalMonitorSample
//
//  Created by Mitsuharu Emoto on 2023/10/16.
//

import Foundation
import AVFoundation

final class CameraViewModel: NSObject, ObservableObject {
    
    @Published private(set) var stateDescription: String = ""
    @Published private(set) var factorDescription: String = ""
    
    let captureSession = AVCaptureSession()
    @objc private dynamic var videoDeviceInput: AVCaptureDeviceInput!
    private let photoOutput = AVCapturePhotoOutput()
    
    private var keyValueObservations = [NSKeyValueObservation]()
    
    override init() {
        super.init()
        
#if targetEnvironment(simulator)
        return
#endif
        config()
    }
    
    deinit {
        finish()
    }
}

extension CameraViewModel {
    
    private func config() {
        do {
            captureSession.beginConfiguration()
            try connectInputsToSession()
            try connectOutputToSession()
            captureSession.commitConfiguration()
            Task{
                self.captureSession.startRunning()
            }
        } catch {
            print(error)
            stateDescription = error.localizedDescription
        }
    }
    
    private func finish() {
        for keyValueObservation in keyValueObservations {
            keyValueObservation.invalidate()
        }
        keyValueObservations.removeAll()
        
        if let videoDeviceInput {
            captureSession.removeInput(videoDeviceInput)
        }
        captureSession.removeOutput(photoOutput)
        captureSession.stopRunning()
    }
    
    private func connectInputsToSession() throws {
        let videoDevice = AVCaptureDevice.default(.builtInWideAngleCamera,
                                                  for: .video,
                                                  position: .unspecified)
        
        do {
            videoDeviceInput = try AVCaptureDeviceInput(device: videoDevice!)
            if !captureSession.canAddInput(videoDeviceInput) {
                throw CameraViewError.exception("We can not add input device.")
            }
            captureSession.addInput(videoDeviceInput)
            
            let observation = observe(\.videoDeviceInput.device.systemPressureState,
                                       options:.new){ [weak self] object, change in
                guard
                    let self,
                    let systemPressureState = change.newValue
                else {
                    return
                }
                self.monitorSystemPressureState(systemPressureState: systemPressureState)
            }
            
            keyValueObservations.append(observation)
            
            self.monitorSystemPressureState(systemPressureState: videoDeviceInput.device.systemPressureState)
  
        } catch {
            throw CameraViewError.exception(error.localizedDescription)
        }
    }
    
    private func connectOutputToSession() throws {
        if !captureSession.canAddOutput(photoOutput) {
            throw CameraViewError.exception("We can not add output device.")
        }
        captureSession.sessionPreset = .photo
        captureSession.addOutput(photoOutput)
    }
}

extension CameraViewModel {
    
    private func monitorSystemPressureState(systemPressureState: AVCaptureDevice.SystemPressureState) {
        
        // A bitmask of values indicating the factors contributing to the current system pressure level.
        let factors = systemPressureState.factors
        
        var factorList: [String] = []
        
        // https://qiita.com/takehito-koshimizu/items/65776bcd257dafbe854d
        if (factors == [.systemTemperature]) {
            print("factor is systemTemperature")
            factorList.append("systemTemperature（システム全体の高熱負荷下）")
        }
        if (factors == [.peakPower]) {
            print("factor is peakPower")
            factorList.append("peakPower（システムのピーク電力要件がバッテリーの電流容量を超過）")
        }
        if (factors == [.depthModuleTemperature]) {
            factorList.append("depthModuleTemperature（深度情報を取得するモジュールが高温で動作）")
        }
        if #available(iOS 17, visionOS 1, *) {
            if (factors == [.cameraTemperature]) {
                factorList.append("cameraTemperature（カメラモジュールが高温で動作）")
            }
        }
        
        factorDescription = "発熱の原因は" + (factorList.isEmpty ? "ありません" : (factorList.joined(separator: "、") + "です"))
        
        stateDescription =  switch systemPressureState.level {
            case .nominal:
                "nominal 😀 熱状態は正常範囲内です / The thermal state is within normal limits."
            case .fair:
                "fair 😅 熱状態はやや高めです / The thermal state is slightly elevated."
            case .serious:
                "serious 🥵 熱状態は高めです / The thermal state is high."
            case .critical:
                "critical 🔥 熱状態はシステムの性能に大きな影響を及ぼしており、デバイスを冷却する必要がある / The thermal state is significantly impacting the performance of the system and the device needs to cool down."
            case .shutdown:
                "shutdown ☠️ もうダメです"
            default:
                fatalError()
            }
        }
}
