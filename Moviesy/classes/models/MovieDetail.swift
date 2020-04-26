//
//  Movie.swift
//  Moviesy
//
//  Created by Rishab on 23/04/20.
//  Copyright © 2020 RB Inc. All rights reserved.
//

import Foundation

struct Movie: Codable
{
    let id: Int?
    let title: String?
    let posterPath: String?
    let backdropPath: String?
    let originalLanguage: String?
    let overview, releaseDate: String?
    let genreIDS: [Int]?
    let reviewInfo: ReviewInfo?
    let credits:Credits?
    let similar:SimilarInfo?

    enum CodingKeys: String, CodingKey
    {
        case posterPath = "poster_path"
        case id
        case backdropPath = "backdrop_path"
        case originalLanguage = "original_language"
        case genreIDS = "genre_ids"
        case title
        case overview
        case releaseDate = "release_date"
        case reviewInfo = "reviews"
        case credits
        case similar
    }
}

struct ReviewInfo: Codable
{
    let page: Int?
    let reviews: [Review]?
    let totalPages, totalResults: Int?

    enum CodingKeys: String, CodingKey
    {
        case page
        case reviews = "results"
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}

struct Review: Codable
{
    let author, content, id: String?
    let url: String?
}

struct Credits: Codable {
    let cast: [Cast]?
    let crew: [Crew]?
}

struct Cast: Codable {
    let name: String?
    let profilePath: String?

    enum CodingKeys: String, CodingKey {
        case name
        case profilePath = "profile_path"
    }
}

struct Crew: Codable {
    let name: String?
    let profilePath: String?

    enum CodingKeys: String, CodingKey {
        case name
        case profilePath = "profile_path"
    }
}

struct SimilarInfo: Codable
{
    let movies: [Movie]?
    let page, totalResults: Int?
    let totalPages: Int?

    enum CodingKeys: String, CodingKey
    {
        case movies = "results"
        case page
        case totalResults = "total_results"
        case totalPages = "total_pages"
    }
}
