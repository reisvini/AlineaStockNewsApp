//
//  ArticlesRepository.swift
//  AlineaStockNews
//
//  Created by OpenAPI Generator
//

import Foundation

public protocol ArticlesRepositoryProtocol {
    func fetchArticles(page: Int, limit: Int, search: String?) async throws -> PaginatedArticles
}

public struct PaginatedArticles {
    public let items: [Article]
    public let total: Int
    public let page: Int
    public let limit: Int
    public let totalPages: Int
}

public struct Article: Identifiable, Hashable {
    public let id: String
    public let title: String
    public let description: String
    public let url: String
    public let source: String
    public let publishedAt: Date
    public let author: String?
    public let imageUrl: String?
}

public actor ArticlesRepository: ArticlesRepositoryProtocol {
    private let apiClient: APIClientProtocol

    public init(apiClient: APIClientProtocol = APIClient()) {
        self.apiClient = apiClient
    }

    public func fetchArticles(
        page: Int = 1,
        limit: Int = 3,
        search: String? = nil
    ) async throws -> PaginatedArticles {
        let response = try await apiClient.fetchArticles(
            page: page,
            limit: limit,
            search: search
        )

        return mapResponse(response)
    }

    private func mapResponse(_ response: Components.Schemas.PaginatedResponse) -> PaginatedArticles {
        let articles = response.items.map { apiArticle -> Article in
            Article(
                id: apiArticle.id,
                title: apiArticle.title,
                description: apiArticle.description,
                url: apiArticle.url,
                source: apiArticle.source,
                publishedAt: apiArticle.publishedAt,
                author: apiArticle.author,
                imageUrl: apiArticle.imageUrl
            )
        }

        return PaginatedArticles(
            items: articles,
            total: response.total,
            page: response.page,
            limit: response.limit,
            totalPages: response.totalPages
        )
    }
}
