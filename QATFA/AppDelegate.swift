//
//  AppDelegate.swift
//  QATFA
//
//  Created by trilok on 01/03/22.
//

import UIKit
import SwiftyBluetooth
import CoreBluetooth

@main
class AppDelegate: UIResponder, UIApplicationDelegate {



    var serviceID = "0000FFE0-0000-1000-8000-00805F9B34FB"
    var characteristicID = "FFE1"
    var saveDevice: Peripheral!
    var count = 1
    var devices = [Peripheral]()
    

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        Timer.scheduledTimer(timeInterval: 15, target: self, selector: #selector(searchBLEDevices), userInfo: nil, repeats: true).fire()
        return true
    }
    
    //MARK: - Search BLE Devices
    @objc func searchBLEDevices() {
        let saveDeviceIdentifier = UserDefaults.standard.string(forKey: "saveDevice")
        if saveDevice == nil && saveDeviceIdentifier != nil {
            print(saveDeviceIdentifier)
            SwiftyBluetooth.scanForPeripherals(withServiceUUIDs: nil, options: nil, timeoutAfter: .infinity, completion: {(scanResult) in
                switch scanResult {
                    
                case .scanStarted:
                    print("Scan for devices has been called")
                case .scanResult(peripheral: let peripheral, advertisementData: let advertisementData, RSSI: let RSSI):
                    print("Scanning has a result")
                    if peripheral.identifier == UUID(uuidString: saveDeviceIdentifier!) {
                        peripheral.connect(withTimeout: .infinity, completion: {(result) in
                            print(peripheral.name)
                            switch result {
                            case .success:
                                self.saveDevice = peripheral
                                break
                            case .failure(let error):
                                break
                            }
                        })
                    }
                case .scanStopped(peripherals: let peripherals, error: let error):
                    print("Scanning has been stopped")
                }
            })
        }
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        Timer.scheduledTimer(timeInterval: 10, target: self, selector: #selector(searchBLEDevices), userInfo: nil, repeats: false)
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        if(saveDevice != nil){
            saveDevice.disconnect(completion: { (error) in
                print("disconnected")
            })
        }
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        if(saveDevice != nil){
            saveDevice.disconnect { (error) in
                print("disconnect")
            }
        }
    }


}

