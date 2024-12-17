//
//  BluetoothDeviceView.swift
//  BLEApp
//
//  Created by Sabal on 12/17/24.
//

import SwiftUI
import CoreBluetooth

struct BluetoothDeviceView: View {
    @StateObject private var bleManager = BLEManager()
    
    var body: some View {
        VStack(spacing: 10) {
            // Title
            Text("Bluetooth Devices")
                .font(.largeTitle)
                .frame(maxWidth: .infinity, alignment: .center)
            
            // Bluetooth Status
            HStack {
                Text("Status:")
                Text(bleManager.isSwitchedOn ? "Bluetooth On" : "Bluetooth Off")
                    .foregroundColor(bleManager.isSwitchedOn ? .green : .red)
            }
            .padding()
            
            // Devices List
            List(bleManager.peripherals) { peripheral in
                HStack {
                    VStack(alignment: .leading) {
                        Text(peripheral.name)
                            .font(.headline)
                        Text("RSSI: \(peripheral.RSSI) dBm")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    
                    Spacer()
                    
                    Button(action: {
                        bleManager.connect(to: peripheral)
                    }) {
                        Text(bleManager.connectedPeripheralsUUID == peripheral.id ? "Connected" : "Connect")
                            .foregroundColor(bleManager.connectedPeripheralsUUID == peripheral.id ? .green : .blue)
                    }
                }
            }
            .frame(height: 300)
            .listStyle(PlainListStyle())
            
            // Control Buttons
            HStack {
                Button(action: {
                    bleManager.startScanning()
                }) {
                    Text("Start Scan")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.bordered)
                .disabled(bleManager.isSwitchedOn == false)
                
                Button(action: {
                    bleManager.stopScanning()
                }) {
                    Text("Stop Scan")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.bordered)
                .disabled(bleManager.isSwitchedOn == false)
            }
            .padding()
        }
        .onAppear {
            if bleManager.isSwitchedOn {
                bleManager.startScanning()
            }
        }
    }
}
                    

#Preview {
    BluetoothDeviceView()
}
