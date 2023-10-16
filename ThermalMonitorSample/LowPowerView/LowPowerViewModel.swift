//
//  LowPowerViewModel.swift
//  ThermalMonitorSample
//
//  Created by Mitsuharu Emoto on 2023/10/08.
//

import Foundation

/**
 @see https://developer.apple.com/documentation/foundation/processinfo/1617047-islowpowermodeenabled
 */
final class LowPowerViewModel: ObservableObject {
    
    @Published private(set) var isLowPowerModeEnabled = ProcessInfo.processInfo.isLowPowerModeEnabled
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
            name: NSNotification.Name.NSProcessInfoPowerStateDidChange,
            object: nil
        )
    }
    
    private func removeMonitering(){
        NotificationCenter.default.removeObserver(
            self,
            name: NSNotification.Name.NSProcessInfoPowerStateDidChange,
            object: nil
        )
    }
    
    @objc private func update(){
        isLowPowerModeEnabled = ProcessInfo.processInfo.isLowPowerModeEnabled
        description = getDescription(state: isLowPowerModeEnabled)
    }
    
    private func getDescription(state: Bool) -> String{
        return if state {
            "低電力モードが有効です。CPUやCPUのパフォーマンス、画面輝度の低下、バックグラウンド処理が停止されます。アプリのアクティビティを減らすために適切な制御を行なってください。"
        } else {
            "低電力モードは無効です。アプリは通常の動作ができます。"
        }
    }
}
