//
//  Socket.swift
//  MatchMaker
//
//  Created by sue on 15/12/25.
//  Copyright © 2015年 sue. All rights reserved.
//

import UIKit
import Socket_IO_Client_Swift
import SwiftyJSON

class Socket: NSObject {
    class var sharedInstance : Socket {
        struct Static {
            static var onceToken : dispatch_once_t = 0
            static var instance : Socket? = nil
        }
        dispatch_once(&Static.onceToken) {
            Static.instance = Socket()
            Static.instance!.initSocket()
            Static.instance!.getidFromHttp()
        }
        return Static.instance!
    }
    var socketId: String = ""
    var socket: SocketIOClient!
    func initSocket() {
        socket = SocketIOClient(socketURL: "http://localhost:3008", options: [.Log(true), .ForceWebsockets(true)])
        socket.connect()
    }
    func getidFromHttp() {
        socket.on("connect") {data, ack in
            self.socket.emit("newUser", "1")
            self.socket.on("socketId"){(data, ack) -> Void in
                self.socketId = String(data)
                //将socketid存进本地
                UserModel.saveSocketId(self.socketId)
            }
        }
       
    }
   
}
