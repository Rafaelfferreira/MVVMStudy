//
//  MoviesListView.swift
//  MVVMStudy
//
//  Created by Rafael Ferreira on 06/07/20.
//  Copyright © 2020 Rafael Ferreira. All rights reserved.
//

import SwiftUI

struct MoviesListView: View {
    @ObservedObject private var nowPlaying = MovieListViewModel()
    @ObservedObject private var popular = MovieListViewModel()
    
    var body: some View {
        NavigationView {
            List {
                if nowPlaying.movies != nil {
                    Text("\(nowPlaying.movies?.first?.title ?? "NAO BAIXOU")")
                }
            }
            .navigationBarTitle("Movies")
            .onAppear {
                self.nowPlaying.loadMovies(with: .nowPlaying)
                //self.popular.loadMovies(with: .popular)
            }
        }
    }
}


struct MoviesListView_Previews: PreviewProvider {
    static var previews: some View {
        MoviesListView()
    }
}
