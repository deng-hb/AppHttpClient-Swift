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
        let request = self.reuqest(url: url,method: "GET",parameters:[:])
        
        URLSession.shared.dataTask(with: request, completionHandler:  { (data, res, err) -> Void in
            completionHandler(data,res,err)
        }).resume()
    
    }
    
    // POST
    func post(url:String,parameters:[String:AnyObject],completionHandler:@escaping(_ data :Data? ,_ response :URLResponse?,_ error: Error?)->Void){
        let request = self.reuqest(url: url,method: "POST",parameters:parameters)
        
        URLSession.shared.dataTask(with: request, completionHandler:  { (data, res, err) -> Void in
            completionHandler(data,res,err)
        }).resume()
    }
    
    private func reuqest(url:String,method:String,parameters:[String:AnyObject])->URLRequest{
        let u = URL(string: url)
        var request = URLRequest(url: u!, cachePolicy: URLRequest.CachePolicy.reloadIgnoringCacheData, timeoutInterval: 30*1000)
        
        //  TODO Custom header
        request.setValue("xxx", forHTTPHeaderField: "Authorization")
        request.httpMethod = method;
        
        if(!parameters.isEmpty){
            
            // 判断是文件参数
            var isMultipart = false;
            for (key, value) in parameters {
                if((value is [String:AnyObject]) || (value is Array<[String:AnyObject]>)){
                    isMultipart = true;
                    break
                }
            }
            
            if(isMultipart){
                var boundary = "AppHttpClinet-denghb-com"

                request.setValue("multipart/form-data; boundary=".appending(boundary),forHTTPHeaderField:"Content-Type")
                boundary = "--\(boundary)"

                var bodyData = Data()
                
                for (key, value) in parameters {
                    if(value is [String:AnyObject]){
                        // 单文件
                        
                        let fileName = value["file_name"] as! String
                        let fileData = value["file_data"] as! Data
                        
                        var field = boundary;
                        field.append("\r\nContent-Disposition: form-data; name=\"\(key)\"; filename=\"\(fileName)\"")
                        field.append("\r\nContent-Type: application/octet-stream\r\nContent-Transfer-Encoding: binary\r\n\r\n")
                        
                        bodyData.append(field.data(using: String.Encoding.utf8)!)
                        bodyData.append(fileData)
                        bodyData.append("\r\n".data(using: String.Encoding.utf8)!)
                        
                    }else if(value is Array<[String:AnyObject]>){
                        // 多个文件
                        let array = value as! Array<[String:AnyObject]>
                        for item in array {
                            // 单文件
                            
                            let fileName = value["file_name"] as! String
                            let fileData = value["file_data"] as! Data
                            
                            var field = boundary;
                            field.append("\r\nContent-Disposition: form-data; name=\"\(key)\"; filename=\"\(fileName)\"")
                            field.append("\r\nContent-Type: application/octet-stream\r\nContent-Transfer-Encoding: binary\r\n\r\n")
                            
                            bodyData.append(field.data(using: String.Encoding.utf8)!)
                            bodyData.append(fileData)
                            bodyData.append("\r\n".data(using: String.Encoding.utf8)!)
                        }
                    }else{
                        // 普通文字信息
                        var field = boundary;
                        field.append("\r\nContent-Disposition: form-data; name=\"\(key)\";")
                        field.append("\r\nContent-Type: text/plain; charset=UTF-8\r\nContent-Transfer-Encoding: 8bit\r\n\r\n")
                        
                        bodyData.append(field.data(using: String.Encoding.utf8)!)
                        bodyData.append((value as! String).data(using: String.Encoding.utf8)!)
                        bodyData.append("\r\n".data(using: String.Encoding.utf8)!)
                        
                    }
                }
                
                bodyData.append("\(boundary)--".data(using: String.Encoding.utf8)!)
                request.httpBody = bodyData
            }else{
                var postString = ""
                for (key, value) in parameters {
                    postString.append("\(key)=\(value)&")
                }

                request.httpBody = postString.data(using: String.Encoding.utf8)
                request.setValue("application/x-www-form-urlencoded",forHTTPHeaderField:"Content-Type")
            }
        }
        
        print(request)

        return request;
    }

    /**
     * 文件流拼接
     */
    private func fileAppend(file:[String:AnyObject],bodyData:Data,boundary:String,name:String)
    {
    
        let fileName = file["file_name"]
        let fileData = file["file_data"] as! NSData// AnyObject -> Data
        
//    // 文件绝对路径
//    if(nil == fileData){
//    NSString *filePath = dict[kFilePath];
//    fileData = [NSData dataWithContentsOfFile:filePath];
//    
//    if(nil == fileName){
//    fileName = [filePath lastPathComponent];
//    }
//    }
//    
//    NSAssert(nil != fileName, @"file name not nil");
//    NSAssert(nil != fileData, @"file data not nil");
    
    
        // 单个文件
        var field = boundary;
        field.append("\r\nContent-Disposition: form-data; name=\"\(name)\"; filename=\"\(fileName)\"")
        field.append("\r\nContent-Type: application/octet-stream\r\nContent-Transfer-Encoding: binary\r\n\r\n")
//        bodyData.append(fileData)
//        bodyData.append("\r\n".data(using: String.Encoding.utf8))
        
//        field = [field stringByAppendingString:[NSString stringWithFormat:@"\r\nContent-Type: application/octet-stream\r\nContent-Transfer-Encoding: binary\r\n\r\n"]];
//    
//    [bodyData appendData:[field dataUsingEncoding:NSUTF8StringEncoding]];
//    [bodyData appendData:fileData];
//    [bodyData appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    }
}
