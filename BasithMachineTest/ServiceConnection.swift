//
//  ApiModel.swift
//  BasithMachineTest
//
//  Created by MOHAMMED ABDUL BASITHK on 18/08/22.
//

import Foundation



class ServiceConnection {
    
    final let ServiceURL: String = "https://www.mocky.io/v2/5d565297300000680030a986"
    
    //It is mentioned in question that You are not allowed to use any external framework or library except for calling the webservice and loading image. But still i am not using any external library for api call. I am using URLSession
    func getEmployees(completionHandler: ((employees) -> Void)?) {
        let myOpQueue = OperationQueue()
        myOpQueue.maxConcurrentOperationCount = 3
        let semaphore = DispatchSemaphore(value: 0)
        let myURL : NSURL = NSURL(string: ServiceURL)!
        myOpQueue.addOperation {
            let request = NSMutableURLRequest(url: myURL as URL)
            request.httpMethod = "GET"
            let configuration = URLSessionConfiguration.default
            configuration.httpAdditionalHeaders = ["Content-Type" : "application/json"]
            let session: URLSession = Foundation.URLSession(configuration: configuration)
            let task = session.dataTask(with: request as URLRequest, completionHandler: {
                (data, response, error) -> Void in
                if let httpResponse = response as? HTTPURLResponse {
                    semaphore.signal()
                    if httpResponse.statusCode == 200 {
                        do {
                            let res = try self.newJSONDecoder().decode(employees.self, from: data!)
                            completionHandler?(res)
                        } catch {
                            print("Error: ", error)
                        }
                    }
                }
            })
            task.resume()
            semaphore.wait()
        }
    }
    
    
    private func newJSONDecoder() -> JSONDecoder {
        let decoder = JSONDecoder()
        if #available(iOS 10.0, OSX 10.12, tvOS 10.0, watchOS 3.0, *) {
            decoder.dateDecodingStrategy = .iso8601
        }
        return decoder
    }
 
    
}
