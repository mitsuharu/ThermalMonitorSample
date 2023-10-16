//
//  LowPowerView.swift
//  ThermalMonitorSample
//
//  Created by Mitsuharu Emoto on 2023/10/08.
//

import SwiftUI

struct LowPowerView: View {
    @ObservedObject private var viewModel = LowPowerViewModel()
    
    var body: some View {
        Text("isLowPowerModeEnabled is \(viewModel.isLowPowerModeEnabled.description)")
        Text("\(viewModel.description)")
    }
}

#Preview {
    LowPowerView()
}
