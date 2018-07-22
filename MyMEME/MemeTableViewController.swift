//
//  MemeTableViewController.swift
//  MyMEME
//
//  Created by Takayuki Sei on 2018/07/22.
//  Copyright © 2018年 Takayuki Sei. All rights reserved.
//

import UIKit
import MEMELib


class MemeTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, MEMELibDelegate {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var textView: UITextView!
    var peripherals: [CBPeripheral] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        MEMELib.sharedInstance()?.addObserver(self, forKeyPath: "centralManagerEnabled", options: NSKeyValueObservingOptions.new, context: nil)
    }

    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "centralManagerEnabled" {
            MEMELib.sharedInstance()?.setAutoConnect(false)
            MEMELib.sharedInstance()?.delegate = self
        }
    }

    @IBAction func didTouchUpScanButton(_ sender: Any) {
        setLog(record: "start scanning")
        MEMELib.sharedInstance()?.startScanningPeripherals()
    }
    
    // MARK: - Table view data source

    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return peripherals.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")
        cell?.textLabel?.text = peripherals[indexPath.row].name
        return cell!
    }

   func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let p = peripherals[indexPath.row]
        MEMELib.sharedInstance()?.connect(p)
    }

    // MARK: - MEMELibDelegate
    func memePeripheralFound(_ peripheral: CBPeripheral!, withDeviceAddress address: String!) {
        setLog(record: "found peripheral: \(peripheral.name!)")
        peripherals.append(peripheral)
        tableView.reloadData()
    }

    func memePeripheralConnected(_ peripheral: CBPeripheral!) {
        setLog(record: "connected peripheral: \(peripheral.name!)")
    }

    func memePeripheralDisconnected(_ peripheral: CBPeripheral!) {
        setLog(record: "disconnected peripheral: \(peripheral.name!)")
    }

    func memeRealTimeModeDataReceived(_ data: MEMERealTimeData!) {
        setLog(record: "data: \(data.description)")
    }

    func setLog(record: String) {
        let s = textView.text ?? ""
        textView.text = "\(Date()) \(record)\n\(s)"
    }
}
