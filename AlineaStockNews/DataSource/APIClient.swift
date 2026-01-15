//
//  APIClient.swift
//  AlineaStockNews
//
//  Created by OpenAPI Generator
//

import Foundation
import OpenAPIRuntime
import OpenAPIURLSession

/// Protocol for API Client (for mocking/testing)
public protocol APIClientProtocol: Actor {
    func fetchArticles(page: Int, limit: Int, search: String?) async throws -> Components.Schemas.PaginatedResponse
}

/// API Client for Stock News API
/// Wraps the generated OpenAPI client
public actor APIClient: APIClientProtocol {
    private let client: Client
    private let baseURL: URL
    
    public init(baseURL: String = "http://localhost:3000") {
        guard let url = URL(string: baseURL) else {
            fatalError("Invalid base URL: \(baseURL)")
        }
        self.baseURL = url
        
        // Create URLSession-based transport
        let transport = URLSessionTransport()
        
        // Custom date transcoder for fractional seconds
        struct FractionalSecondsDateTranscoder: DateTranscoder {
            let formatter: ISO8601DateFormatter = {
                let formatter = ISO8601DateFormatter()
                formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
                return formatter
            }()
            
            func encode(_ date: Date) throws -> String {
                formatter.string(from: date)
            }
            
            func decode(_ dateString: String) throws -> Date {
                guard let date = formatter.date(from: dateString) else {
                    throw DecodingError.dataCorrupted(
                        .init(codingPath: [], debugDescription: "Expected date string to be ISO8601-formatted.")
                    )
                }
                return date
            }
        }
        
        // Initialize the generated client with custom configuration
        self.client = Client(
            serverURL: url,
            configuration: .init(dateTranscoder: FractionalSecondsDateTranscoder()),
            transport: transport
        )
    }
    
    /// Fetch articles with pagination and optional search
    public func fetchArticles(
        page: Int = 1,
        limit: Int = 3,
        search: String? = nil
    ) async throws -> Components.Schemas.PaginatedResponse {
        do {
            let response = try await client.get_sol_articles(
                query: .init(
                    page: String(page),
                    limit: String(limit),
                    search: search
                )
            )
            
            switch response {
            case .ok(let okResponse):
                let apiResponse = try okResponse.body.json
                return apiResponse.data
            case .badRequest:
                throw APIError.badRequest
            case .internalServerError:
                throw APIError.serverError
            case .undocumented(statusCode: let code, _):
                throw APIError.unknownError(statusCode: code)
            }
        } catch let error as ClientError {
            // Log the actual error
            print("❌ ClientError: \(error)")
            throw APIError.invalidResponse
        } catch {
            print("❌ Unexpected error: \(error)")
            throw error
        }
    }
}

// MARK: - API Errors
public enum APIError: LocalizedError {
    case badRequest
    case serverError
    case unknownError(statusCode: Int)
    case invalidResponse
    
    public var errorDescription: String? {
        switch self {
        case .badRequest:
            return "Bad request. Please check your parameters."
        case .serverError:
            return "Server error. Please try again later."
        case .unknownError(let code):
            return "Unknown error occurred (Status: \(code))"
        case .invalidResponse:
            return "Invalid response from server."
        }
    }
}
