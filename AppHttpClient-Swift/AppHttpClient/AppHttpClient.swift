//
//  AppHttpClient.swift
//  AppHttpClient-Swift
//
//  Created by ppd on 16/10/12.
//  Copyright © 2016年 denghb. All rights reserved.
//

import UIKit

class AppHttpClient: NSObject {

    // GET
    func get(url:String,completionHandler:@escaping(_ data :Data? ,_ response :URLResponse?,_ error: Error?)->Void){
        let request = self.reuqest(url: url,method: "GET",parameters:Dictionary())
        
        URLSession.shared.dataTask(with: request, completionHandler:  { (data, res, err) -> Void in
            completionHandler(data,res,err)
        }).resume()
    
    }
    
    // POST
    func post(url:String,parameters:Dictionary<String,String>,completionHandler:@escaping(_ data :Data? ,_ response :URLResponse?,_ error: Error?)->Void){
        let request = self.reuqest(url: url,method: "POST",parameters:parameters)
        
        URLSession.shared.dataTask(with: request, completionHandler:  { (data, res, err) -> Void in
            completionHandler(data,res,err)
        }).resume()
    }
    
    private func reuqest(url:String,method:String,parameters:Dictionary<String,String>)->URLRequest{
        let u = URL(string: url)
        var request = URLRequest(url: u!, cachePolicy: URLRequest.CachePolicy.reloadIgnoringCacheData, timeoutInterval: 30)
        
        //  TODO Custom header
        request.setValue("xxx", forHTTPHeaderField: "Authorization")
        request.httpMethod = method;
        
        if(!parameters.isEmpty){
            var postString = ""
            for (key, value) in parameters {
                postString.append("\(key)=\(value)&")
            }

            request.httpBody = postString.data(using: .utf8)

        }
        
        print(request)

        return request;
    }

}
