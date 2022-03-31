//
//  AssetsAPI.swift
//  KrakenCore
//
//  Created by Michal Thompson on 01.03.22.
//

import Foundation
import Combine

public enum KrakenAPI {
    static let apiClient = APIClient()
    static let baseUrl = URL(string: "https://api.kraken.com/0/")!
}

public enum APIPath: String {
    case assetPairs = "public/AssetPairs"
    case trades = "public/Trades"
    case assets = "public/Assets"
}

extension KrakenAPI {
    
    public static func requestAssetPairs() -> AnyPublisher<AssetPairs, Error> {
        let request = URLRequest(url: baseUrl.appendingPathComponent(APIPath.assetPairs.rawValue))
        return apiClient.run(request)
            .map(\.value)
            .eraseToAnyPublisher()
    }
    
    public static func requestTrades(pair: String) -> AnyPublisher<Trades, Error> {
        guard var components = URLComponents(
            url: baseUrl.appendingPathComponent(APIPath.trades.rawValue),
            resolvingAgainstBaseURL: true
        ) else { fatalError("Couldn't create URLComponents") }
        components.queryItems = [URLQueryItem(name: "pair", value: pair)]
        
        let request = URLRequest(url: components.url!)

        return apiClient.run(request)
            .subscribe(on: DispatchQueue.global(qos: .background))
            .map(\.value)
            .eraseToAnyPublisher()
    }
    
    public static func requestAssetDetails(firstAsset: String, secondAsset: String) -> AnyPublisher<AssetDetails, Error> {
        
        guard var components = URLComponents(
            url: baseUrl.appendingPathComponent(APIPath.assets.rawValue),
            resolvingAgainstBaseURL: true
        ) else { fatalError("Couldn't create URLComponents") }
        components.queryItems = [URLQueryItem(name: "asset", value: firstAsset + "," + secondAsset)]
        
        let request = URLRequest(url: components.url!)
        
        return apiClient.run(request)
            .subscribe(on: DispatchQueue.global(qos: .background))
            .map(\.value)
            .eraseToAnyPublisher()
    }
}
