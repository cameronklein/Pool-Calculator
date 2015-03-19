//
//  NetworkController.swift
//  Pool Calculator
//
//  Created by Cameron Klein on 3/18/15.
//  Copyright (c) 2015 Cameron Klein. All rights reserved.
//

import UIKit
import Alamofire

class NetworkController: NSObject {
  
  class func postReading(reading: Reading) {
    
    var token = NSUserDefaults.standardUserDefaults().objectForKey("token") as String
    println(token)
    let fullURLString = apiURL + "api/readings"
    let URL = NSURL(string: fullURLString)
    
    let request = NSMutableURLRequest(URL: URL!)
    request.HTTPMethod = "POST"

    request.setValue(token, forHTTPHeaderField: "jwt")
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    var readingDictionary = [String:String]()
    //readingDictionary["poolID"] = "12345"
    readingDictionary["freeChlorine"] = reading.freeChlorine?.description
    readingDictionary["combinedChlorine"] = reading.combinedChlorine?.description
    readingDictionary["pH"] = reading.pH?.description
    println(readingDictionary)
    var error : NSError?
    
    request.HTTPBody = NSJSONSerialization.dataWithJSONObject(readingDictionary, options: nil, error: &error)
    
    let dataTask = NSURLSession.sharedSession().dataTaskWithRequest(request, completionHandler: { (data, response, error) -> Void in
      if error == nil {
        let httpResponse = response as NSHTTPURLResponse
        println(httpResponse)
        println(NSString(data: data!, encoding: NSUTF8StringEncoding))
      }
    })
    dataTask.resume()
    
  }
  
  class func getToken(username: String, password: String) {
    
    let fullURLString = apiURL + "api/users"
    let URL = NSURL(string: fullURLString)
    
    let request = NSMutableURLRequest(URL: URL!)
    request.HTTPMethod = "GET"
    
    let combinedString = username + ":" + password
    let data = combinedString.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)
    let base64 = data?.base64EncodedStringWithOptions(nil)
    let fullString = "Basic " + base64!
    request.setValue(fullString, forHTTPHeaderField: "Authorization")
    
    let dataTask = NSURLSession.sharedSession().dataTaskWithRequest(request, completionHandler: { (data, response, error) -> Void in
      if error == nil {
        let httpResponse = response as NSHTTPURLResponse
        switch httpResponse.statusCode {
        case 200...299:
          var JSONError : NSError?
          if let JSONDictionary = NSJSONSerialization.JSONObjectWithData(data!, options: nil, error: &JSONError) as? [String:String] {
            println(JSONDictionary)
            NSUserDefaults.standardUserDefaults().setObject(JSONDictionary["jwt"], forKey: "token")
            NSUserDefaults.standardUserDefaults().synchronize()
          }
        default:
          println("Oops")
        }
      }
    })
    dataTask.resume()
  }
  
  
  
   
}
