//
//  SportDto.swift
//  Data
//
//  Created by thanos kottaridis on 2/2/23.
//

import Foundation

struct SportDto: Codable {
    let id: String?
    let description: String?
    let events: [EventDto]?
    
    public enum CodingKeys: String, CodingKey {
        case id = "i"
        case description = "d"
        case events = "e"
    }
}
