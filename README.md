# AppHttpClient-Swift
## 基于Swift3.0

### 发起一个GET请求
```
AppHttpClient().get(url: "https://denghb.com/",completionHandler:{(_ data :Data? ,_ response :URLResponse?,_ error: Error?)->Void in
    print(response)

    let body = String(data: data!, encoding: String.Encoding.utf8)
    print(body)
})

```
