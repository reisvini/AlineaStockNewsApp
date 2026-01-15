//
//  AlineaStockNewsApp.swift
//  AlineaStockNews
//
//  Created by Vinicius Reis on 1/9/26.
//

import SwiftUI
import SwiftData

@main
struct AlineaStockNewsApp: App {
    private let apiClient: APIClient
    private let repository: ArticlesRepository
    private let viewModel: ArticlesViewModel
    
    init() {
        self.apiClient = APIClient()
        self.repository = ArticlesRepository(apiClient: apiClient)
        self.viewModel = ArticlesViewModel(repository: repository)
    }

    var body: some Scene {
        WindowGroup {
            ContentView(viewModel: viewModel)
        }
    }
}
