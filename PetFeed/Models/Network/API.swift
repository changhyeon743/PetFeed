//
//  API.swift
//  PetFeed
//
//  Created by 이창현 on 2018. 9. 13..
//  Copyright © 2018년 이창현. All rights reserved.
//

import Foundation
import SwiftyJSON

class API {
    static var base_url = "https://api.petfeed.app"
    static var Auth = AuthAPI()
    static var Board = BoardAPI()
    static var currentUser:User! = nil
    static var currentToken:String = ""
    
    static func setUser(withJSON json:JSON) {
        if (!API.currentToken.isEmpty) {
            if (json["success"].boolValue) {
                API.currentUser = User.transformUser(withJSON: json)
            }
        }
        
    }
}
