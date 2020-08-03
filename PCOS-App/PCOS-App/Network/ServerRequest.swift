//
//  ServerRequest.swift
//  PCOS-App
//
//  Created by Hugh Henry on 22/7/20.
//  Copyright © 2020 Hugh Henry. All rights reserved.
//

import Foundation
import os.log
import SwiftSocket

class ServerRequest {
    
    public static func getRequest() {
        
        // Create URL
        let url = URL(string: "http://\(IPConfig.getIPAddress())")
        
        guard let requestUrl = url else { return }
        
        // Create URL Request
        var request = URLRequest(url: requestUrl)
        
        // Specify HTTP Method to use
        request.httpMethod = "GET"
        
        // Send HTTP Request
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            // Check if Error took place
            if let error = error {
                print("Error took place \(error)")
                return
            }
            
            // Read HTTP Response Status code
            if let response = response as? HTTPURLResponse {
                print("Response HTTP Status code: \(response.statusCode)")
            }
            
            // Convert HTTP Response Data to a simple String
            if let data = data, let dataString = String(data: data, encoding: .utf8) {
                print("Response data string:\n \(dataString)")
            }
            
        }
        task.resume()

    }
    
    public static func stream(sendMessage: String) -> String{
        
        let url = "\(IPConfig.getIPAddress())"
        let port = IPConfig.getPort()
        
        let socket = TCPClient(address: url, port: port)
        
        switch socket.connect(timeout: 1800) {
          case .success:
            // Connection successful
            
            switch socket.send(string: sendMessage) {
                case .success:
                    // usleep(1000000) = sleep(1)
                    usleep(500000)
                    
                    guard let data = socket.read(1024*10000) else { return "N/A"}

                    if let response = String(bytes: data, encoding: .utf8) {
                        do {
                            let responseMessage = String(response.split(separator: "^")[1])
                            
                            print(responseMessage)
                            return responseMessage
                        }
                        catch {
                            print("Invalid Response Message.")
                            
                            return "N/A"
                        }
                    }
            
                case .failure(let error):
                    print(error)
                    return "N/A"
            }
          case .failure(_):
                // Connection failed
                print("Could not connect to \(url):\(port)")
                return "N/A"
        }
        
        socket.close()

        return "N/A"
    }
}
