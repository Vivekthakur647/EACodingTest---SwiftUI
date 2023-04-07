//
//  AllRecordsModel.swift
//  EA_CodingTest
//
//  Created by VIVEK THAKUR on 24/03/23.
//

import Foundation
struct AllRecordsModel: Codable , Identifiable {
    let id = UUID()
    let recordName : String?

    let allBands : [String]?
    let allFestivals : [String]?

    enum CodingKeys: String, CodingKey {
        case recordName = "recordName"
        case allBands = "allBands"
        case allFestivals = "allFestivals"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        recordName = try values.decodeIfPresent(String.self, forKey: .recordName)
        allBands = try values.decodeIfPresent([String].self, forKey: .allBands)
        allFestivals = try values.decodeIfPresent([String].self, forKey: .allFestivals)
        
    }

}

// MARK: - Band
struct AllBands: Codable , Identifiable {
    let id = UUID()
    let bandName : String?
    enum CodingKeys: String, CodingKey {
        case bandName = "bandName"
    }
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        bandName = try values.decodeIfPresent(String.self, forKey: .bandName)
    }
}

// MARK: - Band
struct AllFestivals: Codable {
    let festName : String?
    enum CodingKeys: String, CodingKey {
        case festName = "festName"
    }
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        festName = try values.decodeIfPresent(String.self, forKey: .festName)
    }
}
