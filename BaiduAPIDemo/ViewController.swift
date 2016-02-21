//
//  ViewController.swift
//  BaiduAPIDemo
//
//  Created by apple2 on 16/2/21.
//  Copyright © 2016年 shiyuwudi. All rights reserved.
//

import UIKit
import Eureka

class CurrencyViewController: FormViewController {
    
    lazy var dataArray = []

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        NetUtil.requestForCurrency { (arr) -> Void in
            self.dataArray = arr
            self.form
                +++ Section("货币选择")
                <<< PushRow<String>() {
                    $0.title = "来源货币"
                    $0.options = arr
                    $0.value = arr[0]
                    $0.selectorTitle = "请选择来源货币"
            }
                <<< PushRow<String>() {
                    $0.title = "目标货币"
                    $0.options = arr
                    $0.value = arr[0]
                    $0.selectorTitle = "请选择目标货币"
            }
//                +++ Section("")
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

class ListViewController: UITableViewController {
    let titleArray = ["货币转换"]
    
    func toVC(title:String) -> UIViewController {
        if title == "货币转换" {
            return CurrencyViewController()
        }
        return UIViewController()
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let title = titleArray[indexPath.row]
        let vc = toVC(title)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titleArray.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = titleArray[indexPath.row]
        return cell
    }
}

