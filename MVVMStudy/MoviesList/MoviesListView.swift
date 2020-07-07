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
                    //celula de cada filme na lista
                    Text("Popular Movies")
                        .font(.headline)
                        .fontWeight(.bold)
                    ForEach(nowPlaying.movies!, id: \.id) { movie in
                        HStack {
                            VStack(alignment: .leading) {
                                Text(movie.title)
                                    .fontWeight(.bold)
                                Spacer()
                                Text(movie.overview)
                                    .lineLimit(4)
                                    .foregroundColor(Color(UIColor.gray))
                                HStack {
                                    Image(systemName: "star")
                                    Text(String(format: "%.1f", movie.voteAverage))
                                }.foregroundColor(Color(UIColor.gray))
                            }
                        }
                    }
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

extension List {
    @ViewBuilder func noSeparators() -> some View {
        self.onAppear {
            UITableView.appearance().backgroundColor = UIColor.systemBackground
        }
    }
}

struct MoviesListView_Previews: PreviewProvider {
    static var previews: some View {
        MoviesListView()
    }
}
