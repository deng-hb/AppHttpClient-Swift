//
//  ViewController.swift
//  AppHttpClient-Swift
//
//  Created by ppd on 16/10/12.
//  Copyright © 2016年 denghb. All rights reserved.
//


let mScreenHeight = (UIScreen.main.bounds.size.height)
let mScreenWidth = (UIScreen.main.bounds.size.width)
let cellId = "cellId"

import UIKit

class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    var datas: [String]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.view.backgroundColor = UIColor.white
        
        datas = {
            // 创建一个存放String的数组
            var strs = [String]()
            // 添加数据
            for i in 0...10 {
                strs.append("\(i)")
            }
            // 返回
            return strs
        }()

//        datas = ["x","y","z"]
        
        let mainTableView = UITableView(frame: self.view.frame)//CGRect(x:0,y:0,width:mScreenWidth,height:mScreenHeight))
       
        mainTableView.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
        mainTableView.dataSource = self;
        mainTableView.delegate = self;
        
        self.view.addSubview(mainTableView);
        
        AppHttpClient().get(url: "https://denghb.com/",completionHandler:{(_ data :Data? ,_ response :URLResponse?,_ error: Error?)->Void in
            print(response)
            
            let body = String(data: data!, encoding: String.Encoding.utf8)
            print(body)
        });
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // mark
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datas.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // 获得cell
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        
        // 配置cell
        cell.textLabel!.text = datas[indexPath.row]
        
        // 返回cell
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
}

