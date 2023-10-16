//
//  ThermalView.swift
//  ThermalMonitorSample
//
//  Created by Mitsuharu Emoto on 2023/10/08.
//

import SwiftUI

struct ThermalView: View {
    
    @ObservedObject private var viewModel = ThermalViewModel()
    
    var body: some View {
        Text("ThermalState is \(viewModel.thermalState.descprition)")
        Text("\(viewModel.description)")
    }
}

#Preview {
    ThermalView()
}
