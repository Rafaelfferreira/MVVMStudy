//
//  MovieListViewModel.swift
//  MVVMStudy
//
//  Created by Rafael Ferreira on 07/07/20.
//  Copyright © 2020 Rafael Ferreira. All rights reserved.
//

import Foundation
import SwiftUI
import Combine

class MovieListViewModel: ObservableObject, Identifiable {
    @Published var movies: [MovieResult]?
    @Published var isLoading = false
    @Published var error: NSError?
    
    private let movieService: MovieService
    
    init(movieService: MovieService = MovieDB.shared) {
        self.movieService = movieService
    }
    
    func loadMovies(with endpoint: MovieListEndpoint) {
        self.movies = nil
        self.isLoading = false
        self.movieService.fetchMovies(from: endpoint, completion: { [weak self] (result) in
            guard let self = self else { return }
            self.isLoading = false
            
            switch result {
            case .success(let response):
                self.movies = response.results
            case .failure(let error):
                self.error = error as NSError
            }
        })
    }
}
