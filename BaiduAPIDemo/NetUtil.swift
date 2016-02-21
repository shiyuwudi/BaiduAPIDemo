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
    
    class func requestForCurrency(ret:([String] -> Void)) {
        request(currencyServiceUrl) { (arr) -> Void in
            ret(arr as! [String])
        }
    }
    
    class func request(httpUrl: String, ret:([AnyObject] -> Void)) {
        let request = Alamofire.request(.GET, httpUrl, headers:["apikey":apikey])
        request.responseJSON { (resp) -> Void in
            if let jsonStr = resp.result.value {
                let json = JSON(jsonStr)
                print(json)
                if let arr = json["retData"].arrayObject{
                    ret(arr)
                }
            }
        }
    }

}