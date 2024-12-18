//
//  ContentView.swift
//  BLEApp
//
//  Created by Sabal on 12/17/24.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            BluetoothDeviceView()
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
