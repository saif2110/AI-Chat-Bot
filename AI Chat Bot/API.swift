//
//  API.swift
//  AI Chat Bot
//
//  Created by Admin on 19/08/23.
//

import Foundation
import UIKit


let baseURL = "https://apps15.com/ChatBot/chatbot.php"

func hitAPI(question:String,messages:[String], completion: @escaping (Bool, String) -> ()){
    
    let params = ["query":question,"allmessages":messages] as Dictionary<String, Any>

    var request = URLRequest(url: URL(string: baseURL)!)
    request.httpMethod = "POST"
    request.httpBody = try? JSONSerialization.data(withJSONObject: params, options: [])
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")

    let session = URLSession.shared
    let task = session.dataTask(with: request, completionHandler: { data, response, error -> Void in
        //print(response!)
        do {
            let json = try JSONSerialization.jsonObject(with: data!) as! Dictionary<String, AnyObject>
            completion(true, json["result"] as! String)
        } catch {
            completion(true, "NA")
        }
    })

    task.resume()
}

