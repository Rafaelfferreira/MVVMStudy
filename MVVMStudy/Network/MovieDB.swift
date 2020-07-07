//
//  MovieDB.swift
//  MVVMStudy
//
//  Created by Rafael Ferreira on 06/07/20.
//  Copyright © 2020 Rafael Ferreira. All rights reserved.
//

import Foundation

class MovieDB: MovieService {
    
    static let shared = MovieDB()
    private init() {}
    
    private let apiKey = "af166938e8179fae26af7c4b9bf20b94"
    private let baseAPIURL = "https://api.themoviedb.org/3/"
    private let urlSession = URLSession.shared
    
    func fetchMovies(from endpoint: MovieListEndpoint, completion: @escaping (Result<MoviesList, MovieDBError>) -> ()) {
        guard let url = URL(string: "\(baseAPIURL)/movie/\(endpoint.rawValue)") else {
            completion(.failure(.invalidEndpoint))
            return
        }
        self.loadURLAndDecode(url: url, completion: completion)
    }
    
    func fetchMovie(id: Int, completion: @escaping (Result<Movie, MovieDBError>) -> ()) {
        guard let url = URL(string: "\(baseAPIURL)/movie/\(id)") else {
            completion(.failure(.invalidEndpoint))
            return
        }
        self.loadURLAndDecode(url: url, params: [
            "append_to_response": "videos, images" //nao precisa usar parametros nesse app mas achei interessante ter aqui para referencias futuras
        ], completion: completion)
    }
    
    func searchMovie(query: String, completion: @escaping (Result<MoviesList, MovieDBError>) -> ()) {
        guard let url = URL(string: "\(baseAPIURL)/search/movie") else {
            completion(.failure(.invalidEndpoint))
            return
        }
        self.loadURLAndDecode(url: url, params: [
            "language":"en-US",
            "include_adult":"false",
            "query":query
        ],completion: completion)
    }
    
    private func loadURLAndDecode<D: Decodable>(url: URL, params: [String: String]? = nil, completion: @escaping (Result<D, MovieDBError>) -> ()) {
        //MARK: - Setting up the url
        guard var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false) else {
            completion(.failure(.invalidEndpoint))
            return
        }
        
        var queryItems = [URLQueryItem(name: "api_key", value: apiKey)]
        if let params = params {
            queryItems.append(contentsOf: params.map { URLQueryItem(name: $0.key, value: $0.value) })
        }
        
        urlComponents.queryItems = queryItems
        
        guard let finalURL = urlComponents.url else {
            completion(.failure(.invalidEndpoint))
            return
        }
        
        //MARK: - Starting the request
        urlSession.dataTask(with: finalURL) { [weak self] (data, response, error) in
            guard let self = self else { return }
            if error != nil {
                self.executeCompletionHandlerInMainThread(with: .failure(.apiError), completion: completion)
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse, 200..<300 ~= httpResponse.statusCode else { // ~= returns true if the value of the status code is between 200 and 299
                self.executeCompletionHandlerInMainThread(with: .failure(.invalidResponse), completion: completion)
                return
            }
            
            guard let data = data else {
                self.executeCompletionHandlerInMainThread(with: .failure(.noData), completion: completion)
                return
            }
            
            do {
                let decodedResponse = try JSONDecoder().decode(D.self, from: data)
                self.executeCompletionHandlerInMainThread(with: .success(decodedResponse), completion: completion)
            } catch {
                self.executeCompletionHandlerInMainThread(with: .failure(.serializationError), completion: completion)
            }
            
        }
    }
    
    private func executeCompletionHandlerInMainThread<D: Decodable>(with result: Result<D, MovieDBError>, completion: @escaping (Result<D, MovieDBError>) -> ()) {
        DispatchQueue.main.async {
            completion(result)
        }
    }
}

