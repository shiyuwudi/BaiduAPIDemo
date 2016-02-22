//
//  ViewController.swift
//  BaiduAPIDemo
//
//  Created by apple2 on 16/2/21.
//  Copyright © 2016年 shiyuwudi. All rights reserved.
//

import UIKit
import Eureka
import DZNEmptyDataSet

protocol Titled {
    var title:String? {get set}
}

class CurrencyViewController: FormViewController, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {
    
    lazy var dataArray = [String]()
    lazy var rate:Float = 1
    lazy var from = ""
    lazy var to = ""
    
    lazy var rateRow = LabelRow("rateRow"){row in
        row.title = "rate is "
//        row.value = rate
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        setupUI()
        request()
    }
    
    func requestForRate(){
        NetUtil.requestForRate(from, toCurrency: to, amount: Float(1) , ret: { (result:Float) -> Void in
            self.rate = result
            if let rateRow = self.form.rowByTag("rateRow") {
                
            }else {
                self.form +++= self.rateRow
            }
//            if let section:Section = self.form.sectionByTag("input"){
//                section.header = HeaderFooterView(title: "rate is \(result)")
//                self.tableView?.reloadData()
//            }
        })
    }
    
    func request(){
        NetUtil.requestForCurrency { (arr) -> Void in
            self.form
                +++ Section("choose currency")
                
                <<< PushRow<String>("from") {
                    $0.title = "来源货币"
                    $0.options = arr
                    $0.value = arr[0]
                    self.from = arr[0]
                    $0.selectorTitle = "请选择来源货币"
                    self.requestForRate()
                    }.onChange{[weak self] row in
                        self?.form.rowByTag("input1")?.title = row.value
                        self?.tableView?.reloadData()
                        self?.from = row.value!
                        self?.requestForRate()
                    }
                
                <<< PushRow<String>("to") {
                    $0.title = "目标货币"
                    $0.options = arr
                    $0.value = arr[0]
                    self.to = arr[0]
                    $0.selectorTitle = "请选择目标货币"
                    self.requestForRate()
                    }.onChange{[weak self] row in
                        self?.form.rowByTag("input2")?.title = row.value
                        self?.tableView?.reloadData()
                        self?.to = row.value!
                        self?.requestForRate()
                    }
                
                +++ Section("input")
                <<< DecimalRow("input1") {
                    $0.title = self.form.rowByTag("from")!.value
                    $0.useFormatterDuringInput = true
                    $0.value = 0
                    let formatter = CurrencyFormatter()
                    formatter.locale = .currentLocale()
                    formatter.numberStyle = .CurrencyStyle
                    $0.formatter = formatter
                    }
                    .onChange{[weak self] row in
                        let result = Float(row.value!) * (self?.rate)!
                        self?.form.rowByTag("input2")?.value = result
                        self?.form.rowByTag("input2")?.updateCell()
                    }
                
                <<< DecimalRow("input2") {
                    $0.title = self.form.rowByTag("to")!.value
                    $0.useFormatterDuringInput = true
                    $0.value = 0
                    let formatter = CurrencyFormatter()
                    formatter.locale = .currentLocale()
                    formatter.numberStyle = .CurrencyStyle
                    $0.formatter = formatter
                    }.onChange{[weak self] row in
                        let result = Float(row.value!) / (self?.rate)!
                        self?.form.rowByTag("input1")?.value = result
                        self?.form.rowByTag("input1")?.updateCell()
            }
        }
    }
    
    func setupUI(){
        self.tableView?.emptyDataSetDelegate = self
        self.tableView?.emptyDataSetSource = self
    }
    
    func titleForEmptyDataSet(scrollView: UIScrollView!) -> NSAttributedString! {
        return NSAttributedString(string: "网络连接出错")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

class CurrencyFormatter : NSNumberFormatter, FormatterProtocol {
    override func getObjectValue(obj: AutoreleasingUnsafeMutablePointer<AnyObject?>, forString string: String, errorDescription error: AutoreleasingUnsafeMutablePointer<NSString?>) -> Bool {
        guard obj != nil else { return false }
        var str : String
        str = string.componentsSeparatedByCharactersInSet(NSCharacterSet.decimalDigitCharacterSet().invertedSet).joinWithSeparator("")
        obj.memory = NSNumber(float: (Float(str) ?? 0.0)/Float(100))
        return true
    }
    
    func getNewPosition(forPosition position: UITextPosition, inTextInput textInput: UITextInput, oldValue: String?, newValue: String?) -> UITextPosition {
        return textInput.positionFromPosition(position, offset:((newValue?.characters.count ?? 0) - (oldValue?.characters.count ?? 0))) ?? position
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
        vc.title = title
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

