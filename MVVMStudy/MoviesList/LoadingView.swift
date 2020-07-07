//
//  LoadingView.swift
//  MVVMStudy
//
//  Created by Rafael Ferreira on 07/07/20.
//  Copyright © 2020 Rafael Ferreira. All rights reserved.
//

import SwiftUI

struct LoadingView: View {
    
    let isLoading: Bool
    let error: NSError?
    let retryAction: (() -> ())?
    
    var body: some View {
        Group {
            //MARK: - Se estiver carregando chama a tela do indicador de atividade
            if isLoading {
                HStack {
                    Spacer()
                    ActivityIndicatorView()
                    Spacer()
                }
            //MARK: - Se nao estiver carregando mas deu um erro chama essa funcao e, se especificado uma funcao de retry, coloca um botao na tela para chama-la
            } else if error != nil {
                HStack {
                    Spacer()
                    VStack(spacing: 4) {
                        Text(error!.localizedDescription).font(.headline)
                        if self.retryAction != nil {
                            Button(action: self.retryAction!) {
                                Text("Retry")
                            }
                            .foregroundColor(Color(UIColor.systemBlue))
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                    Spacer()
                }
            }
        }
    }
}

struct LoadingView_Previews: PreviewProvider {
    static var previews: some View {
        LoadingView(isLoading: true, error: nil, retryAction: nil)
    }
}
