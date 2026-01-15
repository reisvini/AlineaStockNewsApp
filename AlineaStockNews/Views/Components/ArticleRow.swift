import SwiftUI

struct ArticleRow: View {
    let article: Article

    private var headlineText: String {
        article.description.isEmpty ? article.title : article.description
    }

    private var imageURL: URL? {
        guard let imageUrl = article.imageUrl else { return nil }
        return URL(string: imageUrl)
    }

    var body: some View {
        HStack(spacing: 16) {
            VStack(alignment: .leading, spacing: 4) {
                Text(article.source)
                    .font(.caption)
                    .foregroundStyle(.secondary)

                Text(headlineText)
                    .font(.headline)
                    .lineLimit(3)
                    .foregroundStyle(.primary)

                Text(DateUtils.formattedDate(date: article.publishedAt))
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .padding(.top, 8)
            }
            .frame(maxWidth: .infinity, alignment: .leading)

            if let url = imageURL {
                ArticleThumbnail(url: url)
            }
        }
    }
}

private struct ArticleThumbnail: View {
    let url: URL

    var body: some View {
        AsyncImage(url: url) { phase in
            switch phase {
            case .empty:
                placeholder
                    .overlay { ProgressView() }

            case .success(let image):
                image
                    .resizable()
                    .scaledToFill()

            case .failure:
                placeholder
                    .overlay {
                        Image(systemName: "photo")
                            .foregroundStyle(.secondary)
                    }

            @unknown default:
                placeholder
            }
        }
        .frame(width: 64, height: 64)
        .clipShape(RoundedRectangle(cornerRadius: 6, style: .continuous))
    }

    private var placeholder: some View {
        Rectangle()
            .fill(Color.gray.opacity(0.1))
    }
}

#Preview {
    ArticleRow(article: Article(
        id: "1",
        title: "Apple Stock Soars to New Heights",
        description: "Apple Inc. reached a new all-time high today as investors rallied behind the company's latest AI announcements.",
        url: "https://example.com",
        source: "Bloomberg",
        publishedAt: Date(),
        author: "Mark Gurman",
        imageUrl: "https://example.com/image.jpg"
    ))
    .padding(24)
}
