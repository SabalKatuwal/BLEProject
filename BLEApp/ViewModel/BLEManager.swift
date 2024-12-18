//
//  BLEManager.swift
//  BLEApp
//
//  Created by Sabal on 12/17/24.
//

import Foundation
import CoreBluetooth

class BLEManager: NSObject, ObservableObject, CBCentralManagerDelegate, CBPeripheralDelegate {
    
    var myCentral: CBCentralManager!
    
    @Published var isSwitchedOn: Bool = false   //Bluetoot is On or Off
    @Published var peripherals: [PeripheralModel] = []
    @Published var connectedPeripheralsUUID: UUID?
    
    override init() {
        super.init()
        myCentral = CBCentralManager(delegate: self, queue: nil)
    }
    
    //delegate should be called when state of CentralManager is updated
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        isSwitchedOn = central.state == .poweredOn
        if isSwitchedOn {
            //start scanning
            startScanning()
        } else {
            //stop scanning
            stopScanning()
        }
        
    }
    
    func startScanning() {
        print("Scanning...")
        myCentral.scanForPeripherals(withServices: nil)
    }
    func stopScanning() {
        print("Stopped Scanning...")
        myCentral.stopScan()
    }
    
    //Delegate method called when peripherals is discovered
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber)  {
        let newPeripheral = PeripheralModel(id: peripheral.identifier, name: peripheral.name ?? "Unknown", RSSI: RSSI.intValue)
        if !peripherals.contains(where: { $0.id == newPeripheral.id }) {
            DispatchQueue.main.async {
                self.peripherals.append(newPeripheral)
            }
        }
    }
    
    //Function to connect to peripherals
    func connect(to peripheral: PeripheralModel){
        //retrieve peripherals by id
        guard let cbPeripheral = myCentral.retrievePeripherals(withIdentifiers: [peripheral.id]).first else {
            print("Peripheral not found for connection")
            return
        }
        connectedPeripheralsUUID = cbPeripheral.identifier
        cbPeripheral.delegate = self
        myCentral.connect(cbPeripheral)
    }
    //Delegate method when peripheral is connected
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        print("Connected to \(peripheral.name ?? "Unknown")")
        peripheral.discoverServices(nil)
    }
    
    
    //Delegate method when connection to Delegate fails
    func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: (any Error)?) {
        print("Fail to connect to \(peripheral.name ?? "Unknown"): \(error?.localizedDescription ?? "No error infomation")")
        if peripheral.identifier == connectedPeripheralsUUID {
            connectedPeripheralsUUID = nil
        }
    }
    
    //Delegate method when peripheral is disconnected
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: (any Error)?) {
        print("Disconnected from \(peripheral.name ?? "Unknown")")
        if peripheral.identifier == connectedPeripheralsUUID {
            connectedPeripheralsUUID = nil
        }
    }
    
    //Delegate method call when services are discovered on a peripherals
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: (any Error)?) {
        if let services = peripheral.services {
            for service in services {
                print("Discovered service \(service.uuid)")
                peripheral.discoverCharacteristics(nil, for: service) // discover charc for services
            }
        }
    }
    
    //Delegate method call when characteristics are discovered
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: (any Error)?) {
        if let characteristics = service.characteristics {
            for charc in characteristics {
                print("Discovered characteristic \(charc.uuid)")
                // interact with charac if needed
            }
        }
    }
}
