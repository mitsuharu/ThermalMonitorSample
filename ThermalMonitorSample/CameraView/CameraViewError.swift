//
//  CameraViewError.swift
//  ThermalMonitorSample
//
//  Created by Mitsuharu Emoto on 2023/10/16.
//

import Foundation


enum CameraViewError: Error {
    case exception(String)
    case unknown(String)
}
