//
//  Configuration.swift
//  Moviesy
//
//  Created by Rishab on 23/04/20.
//  Copyright © 2020 RB Inc. All rights reserved.
//

import Foundation


// MARK: - Configuration

struct Configuration: Codable
{
    let imagesInfo: ImagesInfo?
    let changeKeys: [String]?

    enum CodingKeys: String, CodingKey
    {
        case imagesInfo = "images"
        case changeKeys = "change_keys"
    }
}

// MARK: - ImagesInfo

struct ImagesInfo: Codable
{
    let baseURL: String?
    let secureBaseURL: String?
    let backdropSizes, logoSizes, posterSizes, profileSizes: [String]?
    let stillSizes: [String]?

    enum CodingKeys: String, CodingKey
    {
        case baseURL = "base_url"
        case secureBaseURL = "secure_base_url"
        case backdropSizes = "backdrop_sizes"
        case logoSizes = "logo_sizes"
        case posterSizes = "poster_sizes"
        case profileSizes = "profile_sizes"
        case stillSizes = "still_sizes"
    }
}
