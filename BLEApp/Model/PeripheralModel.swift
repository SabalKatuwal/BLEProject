//
//  PeripheralModel.swift
//  BLEApp
//
//  Created by Sabal on 12/17/24.
//

import Foundation

struct PeripheralModel: Identifiable {
    let id: UUID
    var name: String
    var RSSI: Int //for signal strength of peripherals
}
