//
//  CatModel.swift
//  MacPaw
//
//  Created by Victor Pelivan on 5/15/20.
//  Copyright © 2020 Victor Pelivan. All rights reserved.
//

import Foundation

//MARK: - The CatModel is the main datastucture which we get from catapi.com API, I use optionals here to avoid application crashing during data loss in server request. The structure is subscribed under Codable protocol, which as we know is typealias for Encodable & Decodable protocols

struct CatModel: Codable {
    let breeds: [Breed]?
    let id, url: String?
    let width, height: Int?
}

// MARK: - Breed is an optional substructure that includes all the details about a cat. Might be empty in some cases
struct Breed: Codable {
    let weight: Weight?
    let id, name, cfaURL, vetstreetURL, vcahospitalsURL, temperament, origin, countryCodes, countryCode, breedDescription, lifeSpan, altNames, wikipediaURL: String?
    let indoor, lap, adaptability, affectionLevel, childFriendly, dogFriendly, energyLevel, grooming, healthIssues, intelligence, sheddingLevel, socialNeeds, strangerFriendly, vocalisation, experimental, hairless, natural, rare, rex, suppressedTail, shortLegs, hypoallergenic: Int?
    
    // MARK: - We use here an enum subscribed under CodingKey Protocol to convert JSON's snake case into Swift's common used lower camel case
    enum CodingKeys: String, CodingKey {
        case weight, id, name, temperament, origin, indoor, lap, adaptability, vocalisation, experimental, hairless, natural, rare, rex, grooming, hypoallergenic, intelligence
        case cfaURL = "cfa_url"
        case vetstreetURL = "vetstreet_url"
        case vcahospitalsURL = "vcahospitals_url"
        case countryCodes = "country_codes"
        case countryCode = "country_code"
        case breedDescription = "description"
        case lifeSpan = "life_span"
        case altNames = "alt_names"
        case affectionLevel = "affection_level"
        case childFriendly = "child_friendly"
        case dogFriendly = "dog_friendly"
        case energyLevel = "energy_level"
        case healthIssues = "health_issues"
        case sheddingLevel = "shedding_level"
        case socialNeeds = "social_needs"
        case strangerFriendly = "stranger_friendly"
        case suppressedTail = "suppressed_tail"
        case shortLegs = "short_legs"
        case wikipediaURL = "wikipedia_url"
    }
}

// MARK: - Weight substructure inside Breed structure
struct Weight: Codable {
    let imperial, metric: String?
}
