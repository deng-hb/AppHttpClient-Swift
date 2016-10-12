//
//  AppHttpClient.swift
//  AppHttpClient-Swift
//
//  Created by ppd on 16/10/12.
//  Copyright © 2016年 denghb. All rights reserved.
//

import UIKit

class AppHttpClient: NSObject {

    // ,completionHandler:
    func get(url:String,completionHandler:@escaping(_ data :Data? ,_ response :URLResponse?,_ error: Error?)->Void){
        
        let u = URL(string: url)
        
        URLSession.shared.dataTask(with: u!, completionHandler:  { (data, res, err) -> Void in
            completionHandler(data,res,err)
        }).resume()
        

    }

}
