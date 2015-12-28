//
//  NetBase.swift
//  MatchMaker
//
//  Created by sue on 15/12/10.
//  Copyright © 2015年 sue. All rights reserved.
//

import UIKit
import PromiseKit
import SwiftyJSON

class NetBase: NSObject {
   
   static func login(para: [String: AnyObject]?) -> Promise<JSON> {
        return Promise<JSON> {(fullfile, reject) -> Void in
            request(.POST, NetUrl.login, parameters: para, encoding: ParameterEncoding.JSON, headers: nil).responseJSON(completionHandler: { (response) -> Void in
                if response.result.error != nil {
                    reject(response.result.error!)
                }else{
                    let json = JSON(data: response.data!)
                    fullfile(json)
                }
            })
            
        }
    }
    static func postByUser(para: [String: AnyObject], url: String) -> Promise<JSON> {
        return Promise<JSON> {(fullfile, reject) -> Void in
            //带上token
            let token: String = String(UserModel.getUserInfo("userid"))
            var temp : [String:AnyObject] = [:]
            temp = para
            temp["token"] = token
            request(.POST, url, parameters: temp, encoding: ParameterEncoding.JSON, headers: nil).responseJSON(completionHandler: { (response) -> Void in
                if response.result.error != nil {
                    reject(response.result.error!)
                }else{
                    let json = JSON(data: response.data!)
                    fullfile(json)
                }
            })
            
        }
    }

    
}




//
//
//        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//        NSDictionary *parameters = @{@"foo": @"bar"};
//        [manager POST:@"http://example.com/resources.json" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
//            NSLog(@"JSON: %@", responseObject);
//        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//            NSLog(@"Error: %@", error);
//        }];
//









//检查网络
//        let reachability = Reachability().reachabilityForInternetConnection()
//        if reachability.currentReachabilityStatus == Reachability.NetworkStatus.NotReachable {
//            self.showStatusBarErrorStr("网络已经断开")
//            var err: NSError?
//            err = NSError(domain: "", code: -1, userInfo: ["msg":"请求失败！"])
//            failure(err!)
//            return
//        }
//        reachability.startNotifier()
// 发送请求
//        Alamofire.manager
//        Alamofire.manager.request(.POST, url, parameters: parameters)
//            .responseJSON { _, response, data in
////                if (error != nil) {
////                    failure(error!)
////                }else {
//                    let result : NSDictionary = data as NSDictionary
//                    if result["status"] as! Int == 1 {
//                        success(result["data"]!)
//                    }else{
//                        var err: NSError?
//                        err = NSError(domain: "", code: -1, userInfo: ["msg":result["msg"] as! String])
//                        failure(err!)
//                    }
////                }
//            }
//    }

//    func postByUser (url:String, parameters: [String: AnyObject], success: ((AnyObject) -> ()), failure: ((NSError) -> ())) {

//        //检查网络
//        let reachability = Reachability.reachabilityForInternetConnection()
//        if reachability.currentReachabilityStatus == Reachability.NetworkStatus.NotReachable {
//            self.showStatusBarErrorStr("网络已经断开")
//            let err: NSError = NSError()
//            failure(err)
//            return
//        }
//        reachability.startNotifier()
//带上token
//        let token: String = UserModel.curLoginUser()
//        var temp : [String:AnyObject] = [:]
//        temp = parameters
//        temp["token"] = token
//        // 发送请求
//        Alamofire.manager.request(.POST, url, parameters: temp)
//            .responseJSON { _, response, data in
////                if (error != nil) {
////                    failure(error!)
////                }else {
//                    let result : NSDictionary = data
//                    if result["status"] as! Int == 1 {
//                        success(result["data"]!)
//                    }else{
//                        var err: NSError?
//                        err = NSError(domain: "", code: -1, userInfo: ["msg":result["msg"] as! String])
//                        failure(err!)
//                    }
////                }
//        }
//    }

//上传图片

//    func uploadPhoto (url:String, parameters: [String: AnyObject], success: ((AnyObject) -> ()), failure: ((NSError) -> ())) {

//        //检查网络
//        let reachability = Reachability.reachabilityForInternetConnection()
//        if reachability.currentReachabilityStatus == Reachability.NetworkStatus.NotReachable {
//            self.showStatusBarErrorStr("网络已经断开")
//            let err: NSError = NSError()
//            failure(err)
//            return
//        }
//        reachability.startNotifier()
//带上token
//        let token: String = UserModel.curLoginUser()
//        var temp : [String:AnyObject] = [:]
//        temp = parameters
//        temp["token"] = token
//        // 发送请求
//        let tempName: String = temp["imageType"] as! String
//        let fileName: String =  "test." + tempName
//
//        let request: () = Alamofire.manager.upload(Method.POST, url, multipartFormData:{ multipartFormData in
//
//            multipartFormData.appendBodyPart(data: temp["photo"] as! NSData, name: "photo", fileName: fileName, mimeType:"image/jpeg;image/png;image/jpg;image/gif")
//            multipartFormData.appendBodyPart(data: "1".dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)!, name: "write")
//            multipartFormData.appendBodyPart(data: (temp["token"]as! String).dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)!, name: "token")
//            }, encodingCompletion: { encodingResult in
//                switch encodingResult {
//                case .Success(let upload, _, _):
//                    upload.responseJSON { request, response, JSON in
////                        if JSON != nil {
//                            let result = JSON as! NSDictionary
//                            if result["status"] as! Int == 1 {
//                                success(result["data"]!)
//                            }else{
//                                var err: NSError?
//                                err = NSError(domain: "", code: -1, userInfo: ["msg":result["msg"] as! String])
//                                failure(err!)
//                            }
//
////                        }
//                    }
//                case .Failure(let encodingError):
//                    print(encodingError)
////                    failure(NSError( encodingError) )
//                }
//            })
//
//
//    }

//                formData.appendPartWithFormData("1".dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)!, name: "write")
//                formData.appendPartWithFormData((temp["token"]as! String).dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)!, name: "token")


