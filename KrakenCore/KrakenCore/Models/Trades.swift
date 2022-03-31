//
//  Trades.swift
//  KrakenCore
//
//  Created by Michal Thompson on 01.03.22.
//

import Foundation

public struct Trades: Codable {
    public let result: Trade
}

public struct Trade: Codable {
    public let tradeDetails: [TradeInformation]
    public var last: String
    
    enum CodingKeys: String, CodingKey {
        case last
    }
    
    private struct DynamicCodingKeys: CodingKey {
        var intValue: Int?
        init?(intValue: Int) {
            return nil
        }

        var stringValue: String
        init?(stringValue: String) {
            self.stringValue = stringValue
        }
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: DynamicCodingKeys.self)
        let othercontainer = try decoder.container(keyedBy: CodingKeys.self)

        var values: [TradeInformation] = []
        
        // tODO: can we refactor this?
        // The JSON returns a list of objects with dynamic keys, which hold an
        // array of values withoyt keys.
        for key in container.allKeys where key.stringValue != "last" {
            do {
                var subContainer = try container.nestedUnkeyedContainer(forKey: key)

                    while subContainer.isAtEnd == false {
                        var subSubContainer = try subContainer.nestedUnkeyedContainer()
                        var arrayAny: [Any] = []
                        while subSubContainer.isAtEnd == false {
                            if let value = try? subSubContainer.decode(Double.self) {
                                arrayAny.append(value)
                            } else if let value = try? subSubContainer.decode(String.self) {
                                arrayAny.append(value)
                            }
                        }
                        
                        // I will admit that this is a guess. I can't find any documentation that
                        // specifies which values are what. It just gts returned as an array of values.
                        if let price = arrayAny[0] as? String,
                           let volume = arrayAny[1] as? String,
                           let time = arrayAny[2] as? Double,
                           let buySell = arrayAny[3] as? String,
                           let marketLimit = arrayAny[4] as? String,
                            let miscellaneous = arrayAny[5] as? String{
                            let newTradeInformation = TradeInformation(
                                price: price,
                                volume: volume,
                                time: time,
                                buySell: buySell,
                                marketLimit: marketLimit,
                                miscellaneous: miscellaneous
                            )
                            
                            values.append(newTradeInformation)
                        }
                    }
            } catch {
                print(error)
            }
            
        }
          
        tradeDetails = values
        
        last = try othercontainer.decode(String.self, forKey: CodingKeys.last)
    }
}


public struct TradeInformation: Equatable {
    public var price: String?
    public var volume: String?
    public var time: Double?
    public var buySell: String?
    public var marketLimit: String?
    public var miscellaneous: String?
}
