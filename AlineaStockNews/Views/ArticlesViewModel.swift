import Foundation
import Combine

@MainActor
final class ArticlesViewModel: ObservableObject {

    @Published private(set) var articles: [Article] = []

    @Published private(set) var isInitialLoading: Bool = false
    @Published private(set) var isLoadingMore: Bool = false

    @Published var searchText: String = ""

    @Published var initialLoadErrorMessage: String?
    @Published var loadMoreErrorMessage: String?

    private let repository: ArticlesRepositoryProtocol

    private var currentPage: Int = 1
    private var totalPages: Int = 1
    private var isFetching: Bool = false
    private var hasLoadedOnce: Bool = false

    private var articleIDs = Set<String>()

    init(repository: ArticlesRepositoryProtocol) {
        self.repository = repository
    }

    private var sanitizedSearch: String? {
        let trimmed = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        return trimmed.isEmpty ? nil : trimmed
    }

    var isEmptyState: Bool {
        !isInitialLoading && articles.isEmpty && initialLoadErrorMessage == nil
    }

    func loadInitial() async {
        guard !hasLoadedOnce else { return }
        hasLoadedOnce = true
        await loadArticles(refresh: true)
    }

    func refresh() async {
        await loadArticles(refresh: true)
    }

    func search() async {
        await loadArticles(refresh: true)
    }

    func retryInitial() async {
        await loadArticles(refresh: true)
    }

    func retryLoadMore() async {
        await loadArticles(refresh: false)
    }

    func loadNextPageIfNeeded(currentItem: Article) async {
        guard let index = articles.firstIndex(where: { $0.id == currentItem.id }) else { return }

        let thresholdIndex = max(articles.count - 3, 0)
        guard index >= thresholdIndex else { return }

        await loadArticles(refresh: false)
    }

    private func loadArticles(refresh: Bool) async {
        guard !isFetching else { return }

        if refresh {
            currentPage = 1
            totalPages = 1

            initialLoadErrorMessage = nil
            loadMoreErrorMessage = nil

            if articles.isEmpty {
                isInitialLoading = true
            }
        } else {
            guard currentPage <= totalPages else { return }
            loadMoreErrorMessage = nil
            isLoadingMore = true
        }

        isFetching = true

        defer {
            isFetching = false
            isInitialLoading = false
            isLoadingMore = false
        }

        do {
            let result = try await repository.fetchArticles(
                page: currentPage,
                limit: 3,
                search: sanitizedSearch
            )

            if refresh {
                articles = result.items
                articleIDs = Set(result.items.map(\.id))
            } else {
                let newItems = result.items.filter { articleIDs.insert($0.id).inserted }
                articles.append(contentsOf: newItems)
            }

            totalPages = result.totalPages
            currentPage += 1

        } catch {
            guard !Task.isCancelled else { return }

            let message = error.localizedDescription
            if refresh {
                initialLoadErrorMessage = message
            } else {
                loadMoreErrorMessage = message
            }
        }
    }
}
