//
//  Asset.swift
//  KrakenCore
//
//  Created by Michal Thompson on 02.03.22.
//

import Foundation

public struct AssetDetails: Codable {
    public let asset: [String: Asset]?
    
    enum CodingKeys: String, CodingKey {
        case asset = "result"
    }
}

public struct Asset: Codable {
    public let aclass, altname: String?
    public let decimals, displayDecimals: Int?

//    enum CodingKeys: String, CodingKey {
//        case aclass, altname, decimals
//        case displayDecimals
//    }
}
