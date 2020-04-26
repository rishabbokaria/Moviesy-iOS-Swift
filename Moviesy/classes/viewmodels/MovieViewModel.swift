//
//  MovieViewModel.swift
//  Moviesy
//
//  Created by Rishab on 23/04/20.
//  Copyright © 2020 RB Inc. All rights reserved.
//

import Foundation

class MovieViewModel
{
    private let _movie:Movie
    
    var id:String
    {
        return "\(_movie.id ?? 0)"
    }
    
    var title:String
    {
        return _movie.title ?? StringValues.NotAvailable
    }
    
    var releaseDate:String
    {
        if let releaseDateStr = _movie.releaseDate
        {
            if let releaseDate = releaseDateStr.toDate()
            {
                return releaseDate.toString()
            }
        }
        return StringValues.NotAvailable
    }
    
    var overview:String
    {
        return _movie.overview ?? StringValues.NotAvailable
    }
    
    var language:String
    {
        if let originalLanguage = _movie.originalLanguage
        {
            if let languageInfos = ConfigurationManager.shared.languages
            {
                let languages:[Language] = languageInfos.filter { (language) -> Bool in
                    return originalLanguage == language.iso_639_1 ?? "xx"
                }
                return languages.count > 0 ? languages[0].english_name ?? "NA" : StringValues.NotAvailable
            }
        }
        return StringValues.NotAvailable
    }
    
    var genre:String
    {
        if let genreIds = _movie.genreIDS
        {
            if let genreInfos = ConfigurationManager.shared.genres
            {
                let genres:[Genre] = genreInfos.filter { (genre) -> Bool in
                    return genreIds.contains(genre.id ?? 0)
                }
                let genreList:[String] = genres.map {
                    return ($0.name ?? "NA")
                }
                return genreList.count > 0 ? genreList.joined(separator: ", ") : StringValues.NotAvailable
            }
        }
        return StringValues.NotAvailable
    }
    
    var posterURL:String
    {
        if let posterPath = _movie.posterPath
        {
            if let posterSizes = ConfigurationManager.shared.configuration?.imagesInfo?.posterSizes
            {
                if let baseURL = ConfigurationManager.shared.configuration?.imagesInfo?.baseURL
                {
                    return baseURL + posterSizes[1] + posterPath
                }
            }
        }
        return ""
    }
    
    var backdropURL:String
    {
        if let backdropPath = _movie.backdropPath
        {
            if let backdropSizes = ConfigurationManager.shared.configuration?.imagesInfo?.backdropSizes
            {
                if let baseURL = ConfigurationManager.shared.configuration?.imagesInfo?.baseURL
                {
                    return baseURL + backdropSizes[0] + backdropPath
                }
            }
        }
        return ""
    }
    
    var hasCast:Bool
    {
        if let credits = _movie.credits
        {
            if let list = credits.cast
            {
                return list.count > 0
            }
        }
        return false
    }
    
    var cast:CreditsViewModel
    {
        if let credits = _movie.credits
        {
            if let list = credits.cast
            {
                let creditItems = list.map({return CreditItemViewModel(withName: $0.name ?? StringValues.NotAvailable, andProfileURL: $0.profilePath ?? "")})
                return CreditsViewModel(withTitle: StringValues.CastTitle, forCreditItems:creditItems)
            }
        }
        return CreditsViewModel(withTitle: StringValues.CastTitle, forCreditItems:[])
    }
    
    var hasCrew:Bool
    {
        if let credits = _movie.credits
        {
            if let list = credits.crew
            {
                return list.count > 0
            }
        }
        return false
    }
    
    var crew:CreditsViewModel
    {
        if let credits = _movie.credits
        {
            if let list = credits.crew
            {
                let creditItems = list.map({return CreditItemViewModel(withName: $0.name ?? StringValues.NotAvailable, andProfileURL: $0.profilePath ?? "")})
                return CreditsViewModel(withTitle: StringValues.CrewTitle, forCreditItems:creditItems)
            }
        }
        return CreditsViewModel(withTitle: StringValues.CrewTitle, forCreditItems:[])
    }
    
    var hasSimilar:Bool
    {
        if let similarInfo = _movie.similar
        {
            if let movies = similarInfo.movies
            {
                return movies.count > 0
            }
        }
        return false
    }
    
    var similar:SimilarViewModel
    {
        if let similarInfo = _movie.similar
        {
            if let movies = similarInfo.movies
            {
                return SimilarViewModel(withTitle: StringValues.SimilarMoviesTitle, forItems: movies.map({ return MovieViewModel(withMovie: $0)}))
            }
        }
        return SimilarViewModel(withTitle: StringValues.SimilarMoviesTitle, forItems: [])
    }
    
    init(withMovie movie:Movie)
    {
        _movie = movie
    }
    
}


extension MovieViewModel
{
    public func configure(_ cell: MovieTableViewCell)
    {
        cell._titleLabel.text = self.title
        cell._releaseDateLabel.text = self.releaseDate
        cell._overviewLabel.text = self.overview
        
        if (!self.posterURL.isEmpty)
        {
            ImageLazyLoader.shared.load(imageUrl: self.posterURL) { [weak self] (imageUrl, image, error) in
                if (error == nil && self?._movie != nil && imageUrl == self?.posterURL)
                {
                    cell._posterImageView.imageWithFade = image
                }
            }
        }
        else if (!self.backdropURL.isEmpty)
        {
            ImageLazyLoader.shared.load(imageUrl: self.backdropURL) { [weak self] (imageUrl, image, error) in
                if (error == nil && self?._movie != nil && imageUrl == self?.backdropURL)
                {
                    cell._posterImageView.imageWithFade = image
                }
            }
        }
    }
    
    public func configure(_ headerView: MovieDetailsHeaderView)
    {
        headerView._titleLabel.text = self.title
        headerView._releaseDateLabel.text = self.releaseDate
        headerView._overviewLabel.text = self.overview
        headerView._genreLabel.text = self.genre
        headerView._languageLabel.text = self.language
        
        if (!self.backdropURL.isEmpty)
        {
            ImageLazyLoader.shared.load(imageUrl: self.backdropURL) { [weak self] (imageUrl, image, error) in
                if (error == nil && self?._movie != nil && imageUrl == self?.backdropURL)
                {
                    headerView._backdropImageView.imageWithFade = image
                }
            }
        }
        else if (!self.posterURL.isEmpty)
        {
            ImageLazyLoader.shared.load(imageUrl: self.posterURL) { [weak self] (imageUrl, image, error) in
                if (error == nil && self?._movie != nil && imageUrl == self?.posterURL)
                {
                    headerView._backdropImageView.imageWithFade = image
                }
            }
        }
    }
    
    public func configure(_ cell:SimilarMovieCollectionViewCell)
    {
        if (!self.posterURL.isEmpty)
        {
            ImageLazyLoader.shared.load(imageUrl: self.posterURL) { [weak self] (imageUrl, image, error) in
                if (error == nil && self?._movie != nil && imageUrl == self?.posterURL)
                {
                    cell._posterImageView.imageWithFade = image
                }
            }
        }
        else if (!self.backdropURL.isEmpty)
        {
            ImageLazyLoader.shared.load(imageUrl: self.backdropURL) { [weak self] (imageUrl, image, error) in
                if (error == nil && self?._movie != nil && imageUrl == self?.backdropURL)
                {
                    cell._posterImageView.imageWithFade = image
                }
            }
        }
    }
}
