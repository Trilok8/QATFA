//
//  ViewController.swift
//  QATFA
//
//  Created by trilok on 01/03/22.
//

import UIKit
import CoreBluetooth
import SwiftyBluetooth

class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var lblScreenTitle: UILabel!
    @IBOutlet weak var btnGlassHouse: UIButton!
    @IBOutlet weak var btnTunnelHouse: UIButton!
    @IBOutlet weak var btnFiberHouse: UIButton!
    @IBOutlet weak var btnAluminiumHouse: UIButton!
    @IBOutlet weak var btnShadeHouse: UIButton!
    @IBOutlet weak var tblCommandList: UITableView!
    @IBOutlet weak var viewConfig: UIView!
    @IBOutlet weak var btnTunnelHouse2: UIButton!
    var dataAllON = "*1111111111111111#".data(using: .ascii)!
    var dataAllOFF = "*0000000000000000#".data(using: .ascii)!
    var dataGlassHouse = "*1000000000000000#".data(using: .ascii)!
    var dataTunnelHouse = "*0001000000000000#".data(using: .ascii)!
    var dataTunnelHouse2 = "*0000100000000000#".data(using: .ascii)!
    var dataFiberHouse = "*0010000000000000#".data(using: .ascii)!
    var dataAluminiumHouse = "*0100000000000000#".data(using: .ascii)!
    var dataShadeHouse = "*0000010000000000#".data(using: .ascii)!
    
    @IBOutlet weak var tblDeviceList: UITableView!
    @IBOutlet weak var segmentLights: UISegmentedControl!
    
//    var saveDevice: Peripheral!
    @IBOutlet weak var stackView1Constraint: NSLayoutConstraint!
    @IBOutlet weak var stackView2Constraint: NSLayoutConstraint!
    var serviceID = "0000FFE0-0000-1000-8000-00805F9B34FB"
    var characteristicID = "FFE1"
    var devices = [Peripheral]()
    var count = 1
    let btnNotSelectColor = UIImage(named: "notselectedimage")
    let btnSelectColor = UIImage(named: "selectedimage")
    var arrCommandNames = ["ALL ON","ALL OFF","Glass House","Tunnel House 1","Tunnel House 2","Fiber House","Aluminium House","Shade House"]
    
    let englishTitle = "Arab Qatari Agriculture Production - QATFA"
    let arabicTitle = "الشركة العربية القطرية للإنتاج الزراعي - قطفة"
    
    let englishGlassHouse = "Glass Greenhouse"
    let arabicGlassHouse = "بيوت محمية زجاجية"
    
    let englishTunnelHouse = "Tunnel Shadehouse 1"
    let arabicTunnelHouse = "بيوت نفقيه شبكية ١"
    
    let englishTunnelHouse2 = "Tunnel Shadehouse 2"
    let arabicTunnelHouse2 = "بيوت نفقيه شبكية ٢"
    
    let englishFiberHouse = "Fiber Glass Greenhouse"
    let arabicFiberHouse = "بيوت الفايبر المحمية"
    
    let englishaluminiumHouse = "Aluminium Shade House"
    let arabicAluminiumHouse = "بيوت الألمنيوم الشبكية"
    
    let englishshadeHouse = "Shade House"
    let arabicShadeHouse = "بيوت شبكية"
    
    var idleTimer: Timer?
    var appdeledate = UIApplication.shared.delegate as! AppDelegate
    
    
    func startTimer(){
        idleTimer = Timer.scheduledTimer(timeInterval: 60, target: self, selector: #selector(timerSendAll), userInfo: nil, repeats: false)
    }
    
    func disableTimer(){
        idleTimer?.invalidate()
    }
    
    @objc func timerSendAll(){
        sendAllLightsData(data: dataAllON)
    }
    
    
    var arrBtns = [UIButton]()
    override func viewDidLoad() {
        super.viewDidLoad()
        setDefaultCommands()
        setEnglish()
        getCommands()
        arrBtns = [btnGlassHouse,btnTunnelHouse,btnTunnelHouse2,btnFiberHouse,btnAluminiumHouse,btnShadeHouse]
        self.tblDeviceList.register(UINib(nibName: "BLEDeviceName", bundle: nil), forCellReuseIdentifier: "BLEDeviceName")
        self.tblCommandList.register(UINib(nibName: "CommandCell", bundle: nil), forCellReuseIdentifier: "CommandCell")
        self.tblDeviceList.delegate = self
        self.tblDeviceList.dataSource = self
        tblCommandList.delegate = self
        tblCommandList.dataSource = self
//        Timer.scheduledTimer(timeInterval: 15, target: self, selector: #selector(searchBLEDevices), userInfo: nil, repeats: true).fire()
        
        if segmentLights.selectedSegmentIndex == 0 {
            self.segmentLights.setTitle("", forSegmentAt: 0)
            let titleTextAttributes: [NSAttributedString.Key: Any] = [NSAttributedString.Key.foregroundColor: UIColor.white as Any,NSAttributedString.Key.font: UIFont(name: "TanseekModernProArabic", size: 35)]
            segmentLights.setTitleTextAttributes(titleTextAttributes, for: .normal)
            
        } else {
            self.segmentLights.setTitle("ON", forSegmentAt: 0)
            let titleTextAttributes: [NSAttributedString.Key: Any] = [NSAttributedString.Key.foregroundColor: UIColor(named: "darkgreen") as Any,NSAttributedString.Key.font: UIFont(name: "TanseekModernProArabic", size: 35)]
            segmentLights.setTitleTextAttributes(titleTextAttributes, for: .normal)
        }
        sendAllLightsData(data: dataAllON)
    }
    
    func setEnglish(){
        lblScreenTitle.text = englishTitle
        btnGlassHouse.setTitle(englishGlassHouse, for: .normal)
        btnGlassHouse.setTitle(englishGlassHouse, for: .selected)
        btnTunnelHouse.setTitle(englishTunnelHouse, for: .normal)
        btnTunnelHouse.setTitle(englishTunnelHouse, for: .selected)
        btnFiberHouse.setTitle(englishFiberHouse, for: .normal)
        btnFiberHouse.setTitle(englishFiberHouse, for: .selected)
        btnAluminiumHouse.setTitle(englishaluminiumHouse, for: .normal)
        btnAluminiumHouse.setTitle(englishaluminiumHouse, for: .selected)
        btnShadeHouse.setTitle(englishshadeHouse, for: .normal)
        btnShadeHouse.setTitle(englishshadeHouse, for: .selected)
        
        btnTunnelHouse2.setTitle(englishTunnelHouse2, for: .normal)
        btnTunnelHouse2.setTitle(englishTunnelHouse2, for: .selected)
        
    }
    
    func setArabic(){
        lblScreenTitle.text = arabicTitle
        btnGlassHouse.setTitle(arabicGlassHouse, for: .normal)
        btnGlassHouse.setTitle(arabicGlassHouse, for: .selected)
        btnTunnelHouse.setTitle(arabicTunnelHouse, for: .normal)
        btnTunnelHouse.setTitle(arabicTunnelHouse, for: .selected)
        btnFiberHouse.setTitle(arabicFiberHouse, for: .normal)
        btnFiberHouse.setTitle(arabicFiberHouse, for: .selected)
        btnAluminiumHouse.setTitle(arabicAluminiumHouse, for: .normal)
        btnAluminiumHouse.setTitle(arabicAluminiumHouse, for: .selected)
        btnShadeHouse.setTitle(arabicShadeHouse, for: .normal)
        btnShadeHouse.setTitle(arabicShadeHouse, for: .selected)
        
        btnTunnelHouse2.setTitle(arabicTunnelHouse2, for: .normal)
        btnTunnelHouse2.setTitle(arabicTunnelHouse2, for: .selected)
    }
    
    @IBAction func arabicLannguage(_ sender: Any) {
        setArabic()
        stackView1Constraint.constant = -370
        stackView2Constraint.constant = -370
    }
    
    @IBAction func englishLanguage(_ sender: Any) {
        setEnglish()
        stackView1Constraint.constant = 50
        stackView2Constraint.constant = 50
    }
    
    @IBAction func glassHouse(_ sender: Any) {
        disableTimer()
        sendData(data: dataGlassHouse, button: btnGlassHouse)
//        changeBtnBgs(btn: btnGlassHouse)
    }
    
    @IBAction func tunnerlHouse(_ sender: Any) {
        disableTimer()
        sendData(data: dataTunnelHouse, button: btnTunnelHouse)
//        changeBtnBgs(btn: btnTunnelHouse)
    }
    
    @IBAction func tunnelHouse2(_ sender: Any) {
        disableTimer()
        sendData(data: dataTunnelHouse2, button: btnTunnelHouse2)
//        changeBtnBgs(btn: btnTunnelHouse2)
    }
    @IBAction func fiberHouse(_ sender: Any) {
        disableTimer()
        sendData(data: dataFiberHouse, button: btnFiberHouse)
//        changeBtnBgs(btn: btnFiberHouse)
    }
    
    @IBAction func aluminiumHouse(_ sender: Any) {
        disableTimer()
        sendData(data: dataAluminiumHouse, button: btnAluminiumHouse)
//        changeBtnBgs(btn: btnAluminiumHouse)
    }
    
    @IBAction func shadeHouse(_ sender: Any) {
        disableTimer()
        sendData(data: dataShadeHouse, button: btnShadeHouse)
//        changeBtnBgs(btn: btnShadeHouse)
    }
    
    
    @IBAction func allLights(_ sender: Any) {
        disableTimer()
        print(segmentLights.selectedSegmentIndex)
        if(segmentLights.selectedSegmentIndex == 1){
//            changeAllBtnsBgs(state: false)
//            segmentLights.selectedSegmentIndex = 0
//            let titleTextAttributes: [NSAttributedString.Key: Any] = [NSAttributedString.Key.foregroundColor: UIColor.white as Any,NSAttributedString.Key.font: UIFont(name: "TanseekModernProArabic", size: 35)]
//            self.segmentLights.setTitleTextAttributes(titleTextAttributes, for: .normal)
//            self.segmentLights.setTitle("", forSegmentAt: 0)
            sendAllLightsData(data: dataAllOFF)
            
            
        } else {
//            changeAllBtnsBgs(state: true)
//            segmentLights.selectedSegmentIndex = 1
//            let titleTextAttributes: [NSAttributedString.Key: Any] = [NSAttributedString.Key.foregroundColor: UIColor(named: "darkgreen") as Any,NSAttributedString.Key.font: UIFont(name: "TanseekModernProArabic", size: 35)]
//            self.segmentLights.setTitleTextAttributes(titleTextAttributes, for: .normal)
//            self.segmentLights.setTitle("ON", forSegmentAt: 0)
            sendAllLightsData(data: dataAllON)
            
        }
    }
    
    //MARK: - Send All Lights Data
    func sendAllLightsData(data: Data){
        if (appdeledate.saveDevice != nil) {
            appdeledate.saveDevice.writeValue(ofCharacWithUUID: characteristicID, fromServiceWithUUID: serviceID, value: data, type: .withoutResponse, completion: { (result) in
                switch result {
                case .success():
                    if(data == self.dataAllON){
                        print("changing all lights to select color")
                        self.changeAllBtnsBgs(state: true)
                        self.segmentLights.selectedSegmentIndex = 1
                        let titleTextAttributes: [NSAttributedString.Key: Any] = [NSAttributedString.Key.foregroundColor: UIColor(named: "darkgreen") as Any,NSAttributedString.Key.font: UIFont(name: "TanseekModernProArabic", size: 35)]
                        self.segmentLights.setTitleTextAttributes(titleTextAttributes, for: .normal)
                        self.segmentLights.setTitle("ON", forSegmentAt: 0)
                    } else {
                        print("changing all lights to not select color")
                        self.changeAllBtnsBgs(state: false)
                        self.segmentLights.selectedSegmentIndex = 0
                        let titleTextAttributes: [NSAttributedString.Key: Any] = [NSAttributedString.Key.foregroundColor: UIColor.white as Any,NSAttributedString.Key.font: UIFont(name: "TanseekModernProArabic", size: 35)]
                        self.segmentLights.setTitle("", forSegmentAt: 0)
                        self.segmentLights.setTitleTextAttributes(titleTextAttributes, for: .normal)
                    }
                    print("Data sent")
                case .failure(let error):
                    print(error.localizedDescription)
                    break
                }
            })
        } else {
//            showSimpleAlert(alertTitle: "No Device Found", message: "Please check if the device is turned ON")
            appdeledate.searchBLEDevices()
        }
        startTimer()
    }
    
    //MARK: - send data
    func sendData(data: Data,button: UIButton) {
        if (appdeledate.saveDevice != nil) {
            self.appdeledate.saveDevice.writeValue(ofCharacWithUUID: self.characteristicID, fromServiceWithUUID: self.serviceID, value: data, type: .withoutResponse, completion: { (result) in
                switch result {
                case .success:
                    self.changeBtnBgs(btn: button)
                    break
                case .failure(let error):
                    break
                }
            })
        } else {
//            showSimpleAlert(alertTitle: "No Device Found", message: "Please check if the device is turned ON")
            appdeledate.searchBLEDevices()
        }
        startTimer()
    }
    
    //MARK: - Btn Color Change
    func changeBtnBgs(btn: UIButton) {
        for i in arrBtns {
            if(segmentLights.selectedSegmentIndex == 1){
                if(i == btn){
                    i.isSelected = true
                } else {
                    i.isSelected = false
                }
            } else if(segmentLights.selectedSegmentIndex == 0){
                if(i == btn){
                    if(btn.isSelected == true){
                        print("changing to false state")
                        btn.isSelected = false
                        print(i.currentTitle!,i.isSelected)
                    } else {
                        print("changing to true state")
                        btn.isSelected = true
                        print(i.currentTitle!,i.isSelected)
                    }
                } else {
                    i.isSelected = false
                }
            }
        }
        segmentLights.selectedSegmentIndex = 0
        if segmentLights.selectedSegmentIndex == 0 {
            self.segmentLights.setTitle("", forSegmentAt: 0)
            let titleTextAttributes: [NSAttributedString.Key: Any] = [NSAttributedString.Key.foregroundColor: UIColor.white as Any,NSAttributedString.Key.font: UIFont(name: "TanseekModernProArabic", size: 35)]
            segmentLights.setTitleTextAttributes(titleTextAttributes, for: .normal)
            
        } else {
            self.segmentLights.setTitle("ON", forSegmentAt: 0)
            let titleTextAttributes: [NSAttributedString.Key: Any] = [NSAttributedString.Key.foregroundColor: UIColor(named: "darkgreen") as Any,NSAttributedString.Key.font: UIFont(name: "TanseekModernProArabic", size: 35)]
            segmentLights.setTitleTextAttributes(titleTextAttributes, for: .normal)
        }
        
    }
    
    func changeAllBtnsBgs(state: Bool) {
        
        for i in arrBtns {
            i.isSelected = state
            print("states in all button")
//            getStates()
        }
        
    }
//
//    func getStates(){
//        print("\nglass house state",btnGlassHouse.isSelected)
//        print("tunnnel house state",btnTunnelHouse.isSelected)
//        print("fiber house state",btnFiberHouse.isSelected)
//        print("aluminium house state",btnAluminiumHouse.isSelected)
//        print("shade house state",btnShadeHouse.isSelected)
//    }
    
    
    //MARK: - Search BLE Devices
//    @objc func searchBLEDevices() {
//        let saveDeviceIdentifier = UserDefaults.standard.string(forKey: "saveDevice")
//        if saveDevice == nil && saveDeviceIdentifier != nil {
//            print(saveDeviceIdentifier)
//            SwiftyBluetooth.scanForPeripherals(withServiceUUIDs: nil, options: nil, timeoutAfter: .infinity, completion: {(scanResult) in
//                switch scanResult {
//
//                case .scanStarted:
//                    print("Scan for devices has been called")
//                case .scanResult(peripheral: let peripheral, advertisementData: let advertisementData, RSSI: let RSSI):
//                    print("Scanning has a result")
//                    if peripheral.identifier == UUID(uuidString: saveDeviceIdentifier!) {
//                        peripheral.connect(withTimeout: .infinity, completion: {(result) in
//                            print(peripheral.name)
//                            switch result {
//                            case .success:
//                                self.saveDevice = peripheral
//                                self.sendAllLightsData(data: self.dataAllON)
//                                break
//                            case .failure(let error):
//                                break
//                            }
//                        })
//                    }
//                case .scanStopped(peripherals: let peripherals, error: let error):
//                    print("Scanning has been stopped")
//                }
//            })
//        }
//    }
    
    @IBAction func searchForDevices(_ sender: Any) {
        if count < 5 {
            count += 1
        } else {
            tblCommandList.reloadData()
            SwiftyBluetooth.asyncState { state in
                self.viewConfig.isHidden = false
                self.tblDeviceList.isHidden =  false
                switch state {
                case .poweredOn:
                    self.viewConfig.isHidden = false
                    print("Powered on")
                    SwiftyBluetooth.scanForPeripherals(withServiceUUIDs: [CBUUID(string: self.serviceID)], options: nil, timeoutAfter: .infinity, completion: {(scanResult) in
                        switch scanResult {
                        case .scanStarted:
                            print("Scan for devices has been called")
                        case .scanResult(peripheral: let peripheral, advertisementData: _, RSSI: _):
                            print(peripheral.name)
                            self.devices.append(peripheral)
                            
                            DispatchQueue.main.async {
                                self.tblDeviceList.isHidden = false
                                self.tblDeviceList.reloadData()
                            }
                        case .scanStopped(peripherals: let peripherals, error: let error):
                            print("Scanning has been stopped")
                            guard let error = error else { return }
                            print(error)
                            print(peripherals)
                        }
                    })
                case .poweredOff:
                    self.showSimpleAlert(alertTitle: "Bluetooth Turned Off", message: "Please turn the Bluetooth on")
                    print("Powered Off")
                case .unauthorized:
                    self.showSimpleAlert(alertTitle: "Bluetooth Unauthorized", message: "Please give permissions needed for the app to work")
                    print("Unauthorized state")
                case .unknown:
                    self.showSimpleAlert(alertTitle: "Bluetooth Unknown", message: "Unknown Bluetooth State")
                    print("Unknown state")
                case .unsupported:
                    self.showSimpleAlert(alertTitle: "Bluetooth Not Supported", message: "Please check if Bluetooth is Supported")
                    print("Unsupported State")
                }
            }
            count = 0
        }
    }
    
    @IBAction func hideView(_ sender: Any) {
        viewConfig.isHidden = true
        tblDeviceList.isHidden = true
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override var prefersHomeIndicatorAutoHidden: Bool {
        return true
    }
    
    //MARK: - Tableview Datasource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(tableView == tblDeviceList) {
            if(devices.count <= 0){
                viewConfig.isHidden = true
                tblDeviceList.isHidden = true
                return 0
            } else {
                return devices.count
            }
        } else {
            return arrCommandNames.count
        }
        
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if(tableView == tblDeviceList){
            let cell = tableView.dequeueReusableCell(withIdentifier: "BLEDeviceName", for: indexPath) as! BLEDeviceName
            if(devices[indexPath.row].name != nil){
                cell.lblDeviceName.text = devices[indexPath.row].name
            }
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CommandCell", for: indexPath) as! CommandCell
            cell.lblCommandName.text = arrCommandNames[indexPath.row]
            let command = UserDefaults.standard.string(forKey: arrCommandNames[indexPath.row])
            if(command != nil){
                cell.lblCommand.text = command
            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if(tableView == tblDeviceList){
            UserDefaults.standard.set(self.devices[indexPath.row].identifier.uuidString, forKey: "saveDevice")
//            switch devices[indexPath.row].state {
//            case .connected:
//                print("Connected")
//            case .connecting:
//                print("Connecting")
//            case .disconnected:
//                print("Disconnected")
//                devices[indexPath.row].connect(withTimeout: .infinity, completion: {(result) in
//                    switch result {
//                    case .success:
//                        print("success")
//                        UserDefaults.standard.set(self.devices[indexPath.row].identifier.uuidString, forKey: "saveDevice")
//                        self.saveDevice = self.devices[indexPath.row]
//                        self.sendAllLightsData(data: self.dataAllON)
//                        break
//                    case .failure(let error):
//                        break
//                    }
//                })
//            case .disconnecting:
//                print("Disconnecting")
//            default:
//                break
//            }
            showSimpleAlert(alertTitle: "Device Identifier", message: "Device Identifier has been saved")
        } else {
            let cell = tblCommandList.cellForRow(at: indexPath) as! CommandCell
            presentTextFieldAlert(title: arrCommandNames[indexPath.row], message: "Please enter the command for \(arrCommandNames[indexPath.row])", textFieldPlaceholder: "Please enter the comman") { command in
                if(command != nil){
                    print(command)
                    cell.lblCommand.text = command
                    UserDefaults.standard.set(command, forKey: self.arrCommandNames[indexPath.row])
                    print("save command",UserDefaults.standard.set(command, forKey: self.arrCommandNames[indexPath.row]))
                }
            }
        }
    }
    
    func presentTextFieldAlert(title: String, message: String, textFieldPlaceholder: String, completion: @escaping (String?)->()) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let saveAction = UIAlertAction(title: "SAVE", style: UIAlertAction.Style.default) { _ -> Void in
            let urlTextField = alertController.textFields![0] as UITextField
            completion(urlTextField.text)
        }
        
        let cancelAction = UIAlertAction(title: "DON'T SAVE", style: .default)
        alertController.addTextField { (textField: UITextField!) -> Void in
            textField.placeholder = textFieldPlaceholder
            completion(nil)
        }
        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    //MARK: - Alert
    func showSimpleAlert(alertTitle: String,message: String) {
        let alert = UIAlertController(title: alertTitle, message: message, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { _ in
            alert.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func getCommands() {
        let allon = UserDefaults.standard.string(forKey: arrCommandNames[0])
        
        if(allon != nil){
            print("get commands",allon!)
            dataAllON = (allon!.data(using: .ascii))!
        }
        
        let alloff = UserDefaults.standard.string(forKey: arrCommandNames[1])
        if(alloff != nil){
            dataAllOFF = (alloff!.data(using: .ascii))!
        }
        
        let glassHouse = UserDefaults.standard.string(forKey: arrCommandNames[2])
        if(glassHouse != nil){
            dataGlassHouse = (glassHouse!.data(using: .ascii))!
        }
        
        let tunnerlHouse = UserDefaults.standard.string(forKey: arrCommandNames[3])
        if(tunnerlHouse != nil){
            dataTunnelHouse = (tunnerlHouse!.data(using: .ascii))!
        }
        
        let tunnerlHouse2 = UserDefaults.standard.string(forKey: arrCommandNames[4])
        if(tunnerlHouse2 != nil){
            dataTunnelHouse2 = (tunnerlHouse2!.data(using: .ascii))!
        }
        
        let fiberHouse = UserDefaults.standard.string(forKey: arrCommandNames[5])
        if(fiberHouse != nil){
            dataFiberHouse = (fiberHouse!.data(using: .ascii))!
        }
        
        let aluminiumHouse = UserDefaults.standard.string(forKey: arrCommandNames[6])
        if(aluminiumHouse != nil){
            dataAluminiumHouse = (aluminiumHouse!.data(using: .ascii))!
        }
        
        let shadeHouse = UserDefaults.standard.string(forKey: arrCommandNames[7])
        if(shadeHouse != nil){
            dataShadeHouse = (shadeHouse!.data(using: .ascii))!
        }
    }
    
    func setDefaultCommands(){
        
        let allon = UserDefaults.standard.string(forKey: arrCommandNames[0])
        
        if(allon == nil){
            print("set commands",allon)
            UserDefaults.standard.set(String(data: dataAllON, encoding: .ascii), forKey: arrCommandNames[0])
        }
        
        let alloff = UserDefaults.standard.string(forKey: arrCommandNames[1])
        if(alloff == nil){
            UserDefaults.standard.set(String(data: dataAllOFF, encoding: .ascii), forKey: arrCommandNames[1])
        }
        
        let glassHouse = UserDefaults.standard.string(forKey: arrCommandNames[2])
        if(glassHouse == nil){
            UserDefaults.standard.set(String(data: dataGlassHouse, encoding: .ascii), forKey: arrCommandNames[2])
        }
        
        let tunnerlHouse = UserDefaults.standard.string(forKey: arrCommandNames[3])
        if(tunnerlHouse == nil){
            UserDefaults.standard.set(String(data: dataTunnelHouse, encoding: .ascii), forKey: arrCommandNames[3])
        }
        
        let tunnerlHouse2 = UserDefaults.standard.string(forKey: arrCommandNames[4])
        if(tunnerlHouse2 == nil){
            UserDefaults.standard.set(String(data: dataTunnelHouse2, encoding: .ascii), forKey: arrCommandNames[4])
        }
        
        let fiberHouse = UserDefaults.standard.string(forKey: arrCommandNames[5])
        if(fiberHouse == nil){
            UserDefaults.standard.set(String(data: dataFiberHouse, encoding: .ascii), forKey: arrCommandNames[5])
        }
        
        let aluminiumHouse = UserDefaults.standard.string(forKey: arrCommandNames[6])
        if(aluminiumHouse == nil){
            UserDefaults.standard.set(String(data: dataAluminiumHouse, encoding: .ascii), forKey: arrCommandNames[6])
        }
        
        let shadeHouse = UserDefaults.standard.string(forKey: arrCommandNames[7])
        if(shadeHouse == nil){
            UserDefaults.standard.set(String(data: dataShadeHouse, encoding: .ascii), forKey: arrCommandNames[7])
        }
    }
    
    
}

extension UIButton {
    func customTitle(title: String,titleColor: UIColor,fontName: UIFont) {
        let attributedTitle = NSAttributedString(string: self.currentTitle!, attributes: [NSAttributedString.Key.font: fontName, NSAttributedString.Key.foregroundColor: titleColor])
//        setTitle(title, for: .normal)
    }
}


extension UILabel {
    func customTitle(txt: String,titleColor: UIColor,fontName: UIFont) {
        let attributedTitle = NSAttributedString(string: txt, attributes: [NSAttributedString.Key.font: fontName, NSAttributedString.Key.foregroundColor: titleColor])
        attributedText = attributedTitle
    }
}
