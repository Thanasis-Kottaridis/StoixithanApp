//
//  EventDto.swift
//  Data
//
//  Created by thanos kottaridis on 3/2/23.
//

import Foundation

struct EventDto: Codable {
    let id: String?
    let sportId: String?
    let description: String?
    let timestamp: Int?
    
    public enum CodingKeys: String, CodingKey {
        case id = "i"
        case sportId = "si"
        case description = "d"
        case timestamp = "tt"
    }
}
