//
//  MovieGenreList.swift
//  Moviesy
//
//  Created by Rishab on 25/04/20.
//  Copyright © 2020 RB Inc. All rights reserved.
//

import Foundation

// MARK: - MovieGenreListResponseData
struct MovieGenreListResponseData: Codable
{
    let genres: [Genre]?
}

// MARK: - Genre
struct Genre: Codable
{
    let id: Int?
    let name: String?
}

// MARK: - Language
struct Language: Codable
{
    let iso_639_1, english_name, name: String?
}
