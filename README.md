# AppHttpClient-Swift
## 基于Swift3.0

### 发起一个GET请求
```
AppHttpClient().get(url: "https://denghb.com/",completionHandler:{(data,response,error)->Void in
    print(response)

    let body = String(data: data!, encoding: String.Encoding.utf8)
    print(body)
})

```
