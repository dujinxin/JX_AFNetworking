//
//  UserManager.swift
//  ZPSY
//
//  Created by 杜进新 on 2017/9/22.
//  Copyright © 2017年 zhouhao. All rights reserved.
//

import UIKit

private let userPath = NSHomeDirectory() + "/Documents/userAccound.json"

class UserEntity: NSObject {
    
    @objc var Token : String?
    @objc var RefreshToken : String?
    @objc var PhoneNumber : String = ""
    @objc var UserID : Int = 0
    @objc var UserName : String?
    @objc var UserAge : Int = 0
    @objc var UserImage : String?
    @objc var UserGender : Int = 0
    @objc var HxAccount : String?
    @objc var HxPassword : String?
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        print("undefinedKey = ",key)
    }
}

class UserManager : NSObject{
    
    static let manager = UserManager()
    
    //登录接口获取
    var userEntity = UserEntity()
    //
    var userDict = Dictionary<String, Any>()
    
    var isLogin: Bool {
        get {
            return !self.userEntity.PhoneNumber.isEmpty
        }
    }
    
    override init() {
        super.init()
        
        let pathUrl = URL(fileURLWithPath: userPath)
        
        guard
            let data = try? Data(contentsOf: pathUrl),
            let dict = try? JSONSerialization.jsonObject(with: data, options: [])else {
                print("该地址不存在用户信息：\(userPath)")
                return
        }
        self.userDict = dict as! [String : Any]
        self.userEntity.setValuesForKeys(dict as! [String : Any])
        print(dict)
        print("用户地址：\(userPath)")
        
    }
    
    /// 保存用户信息
    ///
    /// - Parameter dict: 用户信息字典
    /// - Returns: 保存结果
    func saveAccound(dict:Dictionary<String, Any>) -> Bool {
        
        self.userEntity.setValuesForKeys(dict)
        
        guard let data = try? JSONSerialization.data(withJSONObject: dict, options: [])
            else {
                return false
        }
        try? data.write(to: URL.init(fileURLWithPath: userPath))
        print("保存地址：\(userPath)")
        
        return true
    }
    /// 删除用户信息
    func removeAccound() {
        self.userEntity = UserEntity()
        
        let fileManager = FileManager.default
        try? fileManager.removeItem(atPath: userPath)
    }
    
}
extension UserManager {
    /// 刷新token
    ///
    /// - Parameter completion: 回调闭包
    func refreshToken(completion:((_ isSuccess:Bool)->())?) {
        //1.获取token,首次安装用本地生成的字符串来获取token
        //2.本地有保存token,则用长token去刷新token
        if
            let _ = UserManager.manager.userEntity.Token,
            let longToken = UserManager.manager.userEntity.RefreshToken{
            
            MyRequest.request(url: ApiString.refreshToken.rawValue, param: ["RToken":longToken], success: { (data, msg) in
                
                guard let data = data as? Dictionary<String, Any> else{
                    return
                }
                let isSuccess = self.saveAccound(dict: data)
                print("刷新token：\(isSuccess)")
                if let completion = completion {
                    completion(isSuccess)
                }
            }, failure: { (msg, code) in
                print(msg)
                if let completion = completion {
                    completion(false)
                }
            })
            
        }else{
            if let completion = completion {
                completion(false)
            }
            fetchToken()
        }
        
    }
    /// 获取token
    func fetchToken() {
        MyRequest.request(url: ApiString.getTokenByKey.rawValue, param: ["Uc":(UIDevice.current.identifierForVendor?.uuidString)!], success: { (data, msg) in
            
            guard let data = data as? Dictionary<String, Any> else{
                return
            }
            let isSuccess = UserManager.manager.saveAccound(dict: data)
            print("保存token：\(isSuccess)")
            
        }, failure: { (msg, errorCode) in
            print(msg)
        })
    }
}
