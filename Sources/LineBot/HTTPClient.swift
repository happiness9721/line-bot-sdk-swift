//
//  HTTPClient.swift
//  LineBotPackageDescription
//
//  Created by happiness9721 on 2017/11/28.
//

import Foundation

internal class HTTPClient {

  internal func sendRequest(request: URLRequest) {
    let session = URLSession(configuration: .default, delegate: nil, delegateQueue: nil)

    let dataTask = session.dataTask(with: request) { data, response, error in
      guard let data = data, error == nil else {
        print("error=\(String(describing: error))")
        return
      }

      if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {
        print("statusCode should be 200, but is \(httpStatus.statusCode)")
        print("response = \(String(describing: response))")
      }

      let responseString = String(data: data, encoding: .utf8)
      print("responseString = \(String(describing: responseString))")
    }
    dataTask.resume()
  }

}
