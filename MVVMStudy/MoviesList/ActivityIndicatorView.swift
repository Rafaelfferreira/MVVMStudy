//
//  ActivityIndicatorView.swift
//  MVVMStudy
//
//  Created by Rafael Ferreira on 07/07/20.
//  Copyright © 2020 Rafael Ferreira. All rights reserved.
//

import SwiftUI

// Incorporando uma ui view no swiftui
struct ActivityIndicatorView: UIViewRepresentable {
    func updateUIView(_ uiView: UIActivityIndicatorView, context: Context) {}
    
    func makeUIView(context: Context) -> UIActivityIndicatorView {
        let view = UIActivityIndicatorView(style: .large)
        view.startAnimating()
        return view
    }
}
