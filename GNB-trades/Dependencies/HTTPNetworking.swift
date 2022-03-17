//
//  Networking.swift
//  GNB-trades
//
//  Created by Christian Polo on 12/3/22.
//

import Foundation
import Alamofire //No usado pero se podría implementar aquí

protocol Networking{
    typealias Callback = (Decodable?, Swift.Error?) -> Void

    func request(from: Endpoint, callback: @escaping Callback)
}

struct HTTPNetworking: Networking {
    func request(from: Endpoint, callback: @escaping Callback) {
        guard let url = URL(string: from.path) else { return }
        let request = createRequest(from: url)
        let dataTask = createDataTask(from: request, callback: callback)
        dataTask.resume()
    }

    func createRequest(from url: URL) -> URLRequest{

        var request = URLRequest(url: (url))

        request.timeoutInterval = 10
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = ["Accept": "application/json; charset=utf-8"]
        return request

    }
    private func createDataTask(from request: URLRequest,
                                callback: @escaping Callback) -> URLSessionDataTask {
        return URLSession.shared.dataTask(with: request) { data, httpResponse, error in
            callback(data, error)

        }
    }
}
