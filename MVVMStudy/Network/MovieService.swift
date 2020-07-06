//
//  Service.swift
//  MVVMStudy
//
//  Created by Rafael Ferreira on 06/07/20.
//  Copyright © 2020 Rafael Ferreira. All rights reserved.
//

import Foundation

protocol MovieService {
    func fetchMovies(from endpoint: MovieListEndpoints, completion: @escaping (Result<MoviesList, MovieDBError>) -> ())
    func fetchMovie(id: Int, completion: @escaping (Result<Movie, MovieDBError>) -> ())
    func searchMovie(query: String, completion: @escaping (Result<MoviesList, MovieDBError>) -> ())
}

//MARK: - Endpoints
enum MovieListEndpoints: String, CaseIterable { // CaseIterable is a type that provides a collection of all its balues through .allCases
    case nowPlaying = "now_playing"
    case popular
    
    var description: String {
        switch self {
        case .nowPlaying: return "Now Playing"
        case .popular: return "Popular"
        }
    }
}

//MARK: - Errors
enum MovieDBError: Error, CustomNSError {
    case apiError
    case invalidEndpoint
    case invalidResponse
    case noData
    case serializationError
    
    var localizedDescription: String {
        switch self {
        case .apiError: return "Failed to fetch data"
        case .invalidEndpoint: return "Invelid endpoint"
        case .invalidResponse: return "InvalidResponse"
        case .noData: return "No Data"
        case .serializationError: return "Failed to decode data"
        }
    }
    
    var errorUserInfo: [String : Any] { [NSLocalizedDescriptionKey: localizedDescription] }
}
