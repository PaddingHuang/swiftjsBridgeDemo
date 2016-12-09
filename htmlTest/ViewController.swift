//
//  ViewController.swift
//  htmlTest
//
//  Created by HUA on 2016/12/7.
//  Copyright © 2016年 HUA. All rights reserved.
//

import UIKit
import JavaScriptCore


// 定义协议SwiftJavaScriptDelegate 该协议必须遵守JSExport协议
@objc protocol SwiftJavaScriptDelegate: JSExport {
    
    // js调用加载首页
    func load(string: String)
 
       func callHandler(handleFuncName: String)
}


// 定义一个模型 该模型实现SwiftJavaScriptDelegate协议
@objc class SwiftJavaScriptModel: NSObject, SwiftJavaScriptDelegate {
    
    weak var controller: UIViewController?
    weak var jsContext: JSContext?
    func load(string: String) {
        let jsHandlerFunc = self.jsContext?.objectForKeyedSubscript(string)
        let ssr = ["value":"gg"]
        print("cc")
      _ =  jsHandlerFunc?.call(withArguments: [ssr])
        
    }
    
    func callHandler(handleFuncName: String) {
        
        let jsHandlerFunc = self.jsContext?.objectForKeyedSubscript("\(handleFuncName)")
        let dict = ["name": "sean", "age": 18] as [String : Any]
        _ = jsHandlerFunc?.call(withArguments: [dict])
    }


    
  }




class ViewController: UIViewController,UIWebViewDelegate {
   var jsContext:JSContext?
    override func viewDidLoad() {
        super.viewDidLoad()

    let webView = UIWebView()
        webView.frame = self.view.frame
        self.view.addSubview(webView)
    
        let url  = NSURL.fileURL(withPath:    Bundle.main.path(forResource: "demo", ofType: "html")!)
        let request  = NSURLRequest.init(url: url)
        webView.loadRequest(request as URLRequest)
        webView.delegate = self
    }
   
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
         let context = webView.value(forKeyPath: "documentView.webView.mainFrame.javaScriptContext")as?JSContext
        self.jsContext = context
        let model = SwiftJavaScriptModel()
       
        model.jsContext = self.jsContext
         self.jsContext?.setObject(model, forKeyedSubscript: "WebViewJavascriptBridge" as (NSCopying & NSObjectProtocol)!)
        

        let jsHandlerFunc = self.jsContext?.objectForKeyedSubscript("info")
        let dict = ["name": "sean", "age": 18] as [String : Any]
        _ = jsHandlerFunc?.call(withArguments: [dict])

        
        
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

