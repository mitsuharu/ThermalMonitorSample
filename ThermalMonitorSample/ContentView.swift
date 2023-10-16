//
//  ContentView.swift
//  ThermalMonitorSample
//
//  Created by Mitsuharu Emoto on 2023/10/16.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            ThermalView()
            Spacer().frame(height: 30)
            LowPowerView()
            Spacer().frame(height: 30)
            CameraView()
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
