//
//  ThermalViewModel.swift
//  ThermalMonitorSample
//
//  Created by Mitsuharu Emoto on 2023/10/08.
//

import Foundation

/**
 @see
 https://developer.apple.com/documentation/foundation/processinfo/thermalstate
 
 @see
 https://developer.apple.com/library/archive/documentation/Performance/Conceptual/power_efficiency_guidelines_osx/RespondToThermalStateChanges.html#//apple_ref/doc/uid/TP40013929-CH25-SW1
 
 */
final class ThermalViewModel: ObservableObject {
    
    @Published private(set) var thermalState = ProcessInfo.processInfo.thermalState
    @Published private(set) var description: String = ""

    init() {
        update()
        startMonitering()
    }

    deinit {
        removeMonitering()
    }
    
    private func startMonitering(){
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(update),
            name: ProcessInfo.thermalStateDidChangeNotification,
            object: nil
        )
    }
    
    private func removeMonitering(){
        NotificationCenter.default.removeObserver(
            self,
            name: ProcessInfo.thermalStateDidChangeNotification,
            object: nil
        )
    }
    
    @objc private func update(){
        thermalState = ProcessInfo.processInfo.thermalState
        description = getDescription(state: thermalState)
    }
    
    private func getDescription(state: ProcessInfo.ThermalState) -> String{
        return switch state {
        case .nominal:
            "nominal 😀 熱状態は正常範囲内です / The thermal state is within normal limits."
        case .fair:
            "fair 😅 熱状態はやや高めです / The thermal state is slightly elevated."
        case .serious:
            "serious 🥵 熱状態は高めです / The thermal state is high."
        case .critical:
            "critical 🔥 熱状態はシステムの性能に大きな影響を及ぼしており、デバイスを冷却する必要がある / The thermal state is significantly impacting the performance of the system and the device needs to cool down."
        @unknown default:
            fatalError()
        }
    }
}

extension ProcessInfo.ThermalState {
    var descprition: String {
        return switch self {
        case .nominal:
            "nominal"
        case .fair:
            "fair"
        case .serious:
            "serious"
        case .critical:
            "critical"
        @unknown default:
            fatalError()
        }
    }
}
