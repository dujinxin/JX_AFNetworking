//
//  TestVM.swift
//  JXNetworking_Example
//
//  Created by 杜进新 on 2018/7/23.
//  Copyright © 2018年 CocoaPods. All rights reserved.
//

import Foundation

class TestEntity: NSObject {
    
    @objc var Content : String?
    //...
}
class TestVM : NSObject {
    
    var entity = TestEntity()
    
    var dataArray = Array<String>()
    
    

    let commentUrl = ApiString.commentList.rawValue + "?Version=2.0.6&Package=GjieGo&Channel=appStore&Longitude=\(0)&Latitude=\(0)&Mac=&IP=&City=北京市&Token=\(UserManager.manager.userEntity.Token ?? "")"
    
    func commentList(completion:@escaping ((_ isSuccess:Bool)->())) {
        MyRequest.request(url: commentUrl, param: ["page":1], success: { (data, msg) in
            guard let dataArray = data as? Array<Dictionary<String,Any>> else {
                completion(false)
                return
            }
            dataArray.forEach({ (dict) in
                if let s = dict["Content"] as? String {
                    self.dataArray.append(s)
                }
            })
            completion(true)
        }) { (msg, code) in
            completion(false)
        }
    }
}
