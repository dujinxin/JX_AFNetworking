//
//  ViewController.swift
//  JXNetwoking
//
//  Created by 杜进新 on 2018/7/23.
//  Copyright © 2018年 dujinxin. All rights reserved.
//

import UIKit

let NotificationLoginStatus = "NotificationLoginStatus"
let NotificationShouldLogin = "NotificationShouldLogin"

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var vm = TestVM()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "登录", style: UIBarButtonItemStyle.plain, target: self, action: #selector(goToLogin))
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        if !UserManager.manager.isLogin {
            let vc = JXLoginViewController()
            let nvc = UINavigationController.init(rootViewController: vc)
            self.present(nvc, animated: true, completion: nil)
        } else {
            self.vm.commentList { (isSuc) in
                self.tableView.reloadData()
            }
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @objc func goToLogin() {
        let vc = JXLoginViewController()
        let nvc = UINavigationController.init(rootViewController: vc)
        self.present(nvc, animated: true, completion: nil)
    }
}

extension ViewController: UITableViewDelegate,UITableViewDataSource {
    //DataSource
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.vm.dataArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = self.vm.dataArray[indexPath.row]
        return cell
    }
    //delegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}
