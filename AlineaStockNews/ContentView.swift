//
//  ContentView.swift
//  AlineaStockNews
//
//  Created by Vinicius Reis on 1/9/26.
//

import SwiftUI

struct ContentView: View {
    let viewModel: ArticlesViewModel
    
    var body: some View {
        ArticlesListView(viewModel: viewModel)
    }
}

#Preview {
    ContentView(viewModel: ArticlesViewModel(repository: ArticlesRepository()))
}
