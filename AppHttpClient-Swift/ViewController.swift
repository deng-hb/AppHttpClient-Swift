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

        datas = ["GET","POST","Upload"]
        
        let mainTableView = UITableView(frame: self.view.frame)//CGRect(x:0,y:0,width:mScreenWidth,height:mScreenHeight))
       
        mainTableView.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
        mainTableView.dataSource = self;
        mainTableView.delegate = self;
        
        self.view.addSubview(mainTableView);
        
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
        
        let host = "http://192.168.58.45:8090"
        
        switch indexPath.row {
        case 0:
            
                AppHttpClient().get(url: host.appending("/"),completionHandler:{(data,response,error)->Void in
                    print(response)
                    
                    let body = String(data: data!, encoding: String.Encoding.utf8)
                    print(body)
                })
            break
        
        case 1:
            AppHttpClient().post(url: host.appending("/post"), parameters: ["amount":"120" as AnyObject,"name":"张三" as AnyObject], completionHandler: { (data, response, error)->Void in
                
                let body = String(data: data!, encoding: String.Encoding.utf8)
                print(body)
            })
            break
        case 2:
            
            let image = self.screenSnapshot(save: false)
            let imageData = UIImagePNGRepresentation(image!)
            
            AppHttpClient().post(url: host.appending("/upload"), parameters: ["amount":"120" as AnyObject,"images": ["file_name":"tup","file_data":imageData as AnyObject] as AnyObject ], completionHandler: { (data, response, error)->Void in
                
                let body = String(data: data!, encoding: String.Encoding.utf8)
                print(body)
            })
            break
        default: break

        }
    }
    
    // 截图
    func screenSnapshot(save: Bool) -> UIImage? {
        
        guard let window = UIApplication.shared.keyWindow else { return nil }
        
        // 用下面这行而不是UIGraphicsBeginImageContext()，因为前者支持Retina
        UIGraphicsBeginImageContextWithOptions(window.bounds.size, false, 0.0)
        
        window.layer.render(in: UIGraphicsGetCurrentContext()!)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        if save { UIImageWriteToSavedPhotosAlbum(image!, self, nil, nil) }
        
        return image
    }
}

