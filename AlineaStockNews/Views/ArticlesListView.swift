import SwiftUI

struct ArticlesListView: View {
    @StateObject private var viewModel: ArticlesViewModel
    @State private var selectedArticleURL: URL?

    init(viewModel: ArticlesViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        NavigationStack {
            Group {
                if viewModel.isInitialLoading && viewModel.articles.isEmpty {
                    ProgressView("Loading articles...")
                        .frame(maxWidth: .infinity, maxHeight: .infinity)

                } else if let error = viewModel.initialLoadErrorMessage, viewModel.articles.isEmpty {
                    initialErrorView(message: error)

                } else if viewModel.isEmptyState {
                    EmptyStateView()

                } else {
                    articlesList
                }
            }
            .navigationTitle("Stock News")
            .searchable(text: $viewModel.searchText, prompt: "Search stock news...")
            .onSubmit(of: .search) {
                Task { await viewModel.search() }
            }
            .task {
                await viewModel.loadInitial()
            }
            .sheet(item: $selectedArticleURL) { url in
                SafariView(url: url)
                    .ignoresSafeArea()
            }
        }
    }

    private var articlesList: some View {
        List {
            ForEach(viewModel.articles) { article in
                ArticleRow(article: article)
                    .contentShape(Rectangle())
                    .onTapGesture {
                        selectedArticleURL = URL(string: article.url)
                    }
                    .onAppear {
                        Task {
                            await viewModel.loadNextPageIfNeeded(currentItem: article)
                        }
                    }
                    .listRowSeparator(.hidden)
                    .listRowInsets(.init(top: 20, leading: 16, bottom: 20, trailing: 16))
            }

            bottomStatusRow
        }
        .listStyle(.plain)
    }

    @ViewBuilder
    private var bottomStatusRow: some View {
        if viewModel.isLoadingMore {
            HStack {
                Spacer()
                ProgressView()
                Spacer()
            }
            .padding(.vertical, 16)
            .listRowSeparator(.hidden)

        } else if let loadMoreError = viewModel.loadMoreErrorMessage {
            VStack(spacing: 12) {
                Text(loadMoreError)
                    .font(.footnote)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)

                Button("Retry") {
                    Task { await viewModel.retryLoadMore() }
                }
                .buttonStyle(.borderedProminent)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .listRowSeparator(.hidden)
        }
    }

    private func initialErrorView(message: String) -> some View {
        VStack(spacing: 12) {
            Text("Something went wrong")
                .font(.headline)

            Text(message)
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)

            Button("Retry") {
                Task { await viewModel.retryInitial() }
            }
            .buttonStyle(.borderedProminent)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding()
    }
}

extension URL: @retroactive Identifiable {
    public var id: String { absoluteString }
}

#Preview {
    ArticlesListView(viewModel: ArticlesViewModel(repository: ArticlesRepository()))
}
