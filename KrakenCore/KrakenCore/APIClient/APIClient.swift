//
//  APIClient.swift
//  KrakenCore
//
//  Created by Michal Thompson on 01.03.22.
//

import Foundation
import Combine

struct APIClient {
    
    private let allowedDiskSize = 1000 * 1024 * 1024
    private lazy var cache: URLCache = {
        return URLCache(memoryCapacity: 0, diskCapacity: allowedDiskSize, diskPath: "responseCache")
    }()

    struct Response<T> {
        let value: T
        let response: URLResponse
    }
    
    func run<T: Decodable>(_ request: URLRequest) -> AnyPublisher<Response<T>, Error> {
        
        let cache = URLCache(memoryCapacity: 0, diskCapacity: 100 * 1024 * 1024, diskPath: "myCache")
        let config = URLSessionConfiguration.default
        config.requestCachePolicy = .returnCacheDataElseLoad
        config.urlCache = cache
        let session = URLSession(configuration: config)
        
        return session
            .dataTaskPublisher(for: request)
            .tryMap { result -> Response<T> in
                let value = try JSONDecoder().decode(T.self, from: result.data)
                return Response(value: value, response: result.response)
            }
            .receive(on: DispatchQueue.main) //TODO: look
            .eraseToAnyPublisher()
    }
}
