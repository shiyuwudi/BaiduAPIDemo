//
//  NetUtil.swift
//  BaiduAPIDemo
//
//  Created by apple2 on 16/2/21.
//  Copyright © 2016年 shiyuwudi. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class NetUtil {
    static let apikey = "000888ad4ab1d462b654a75fdccbca4d"
    
    static let currencyServiceUrl = "http://apis.baidu.com/apistore/currencyservice/type"
    static let rateUrl = "http://apis.baidu.com/apistore/currencyservice/currency"
    
    class func requestForRate(fromCurrency:String, toCurrency:String, amount:Float, ret:(Float ->Void )){
        let p = ["fromCurrency":fromCurrency, "toCurrency":toCurrency, "amount":String(amount)]
        request(rateUrl, par: p) { (json:JSON) -> Void in
            let convertedAmount = json["retData"]["convertedamount"].floatValue
            ret(convertedAmount)
        }
    }
    
    class func requestForCurrency(ret:([String] -> Void)) {
        request(currencyServiceUrl, par: nil) { (json:JSON) -> Void in
            if let arr = json["retData"].arrayObject{
                ret(arr as! [String])
            }
        }
    }
    
    class func request(httpUrl: String,par:[String:AnyObject]?, ret:(JSON -> Void)) {
        
        let request = Alamofire.request(.GET, httpUrl, parameters: par, headers:["apikey":apikey])
        request.responseJSON { (resp) -> Void in
            if let jsonStr = resp.result.value {
                let json = JSON(jsonStr)
                print(json)
                ret(json)
            }
        }
    }

}