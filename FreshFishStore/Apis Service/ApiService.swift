//
//  ApiService.swift
//  FreshFishStore
//
//  Created by Sherif  Wagih on 11/6/18.
//  Copyright © 2018 Sherif  Wagih. All rights reserved.
//

import Foundation
import Alamofire
class ApiService
{

    static let baseURL = "https://jamalah.com/montag/"
    class func confirmOrder(parameters:[String:Any],completitioinHandler:@escaping (DefaultDataResponse) -> ())
    {
        let url = baseURL + "add_order.php"
        Alamofire.request(url, method: .post, parameters: parameters, headers: nil).response { (response) in
            completitioinHandler(response)
        }
    }
    class func getAllLocalFish(fishURL:String,completitionHandler:@escaping ([Fish]?) -> ())
    {
        let url = baseURL + fishURL
        print(url)
        Alamofire.request(url, method: .get, parameters: nil, headers: nil).responseJSON { (response) in
            if response.result.isSuccess
            {
                do
                {
                    guard let data = response.data else {return}
                    let allLocalFishes = try JSONDecoder().decode([Fish].self, from: data)
                    completitionHandler(allLocalFishes)
                    print(allLocalFishes)
                }
                catch
                {
                    completitionHandler(nil)
                }
            }
            else
            {
                completitionHandler(nil)
            }
        }
    }
}
