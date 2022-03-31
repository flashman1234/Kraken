//
//  Asset.swift
//  KrakenCore
//
//  Created by Michal Thompson on 01.03.22.
//

import Foundation

public struct AssetPairs: Codable {
    public let result: [String: AssetPairDetails]
}

public struct AssetPairDetails: Codable {
    public let altname, wsname, base, aclassBase: String?
    public let quote, lot, aclassQuote: String?
    public let pairDecimals, lotDecimals, lotMultiplier: Int?
    public let leverageBuy, leverageSell: [Int]?
    public let fees, feesMaker: [[Double]]?
    public let feeVolumeCurrency: String?
    public let marginCall, marginStop: Int?
    public let ordermin: String?

    enum CodingKeys: String, CodingKey {
        case altname, wsname
        case aclassBase
        case base
        case aclassQuote
        case quote, lot
        case pairDecimals
        case lotDecimals
        case lotMultiplier
        case leverageBuy
        case leverageSell
        case fees
        case feesMaker
        case feeVolumeCurrency
        case marginCall
        case marginStop
        case ordermin
    }
}
