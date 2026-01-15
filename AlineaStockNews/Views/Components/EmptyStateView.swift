//
//  EmptyStateView.swift
//  AlineaStockNews
//
//  Created by Vinicius Reis on 1/13/26.
//

import SwiftUI

struct EmptyStateView: View {
    let title: String
    let message: String
    let iconName: String
    let action: (() -> Void)?
    
    init(
        title: String = "No articles found",
        message: String = "Try adjusting your search or check back later",
        iconName: String = "newspaper",
        action: (() -> Void)? = nil
    ) {
        self.title = title
        self.message = message
        self.iconName = iconName
        self.action = action
    }
    
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: iconName)
                .font(.system(size: 60))
                .foregroundStyle(.secondary)
                .padding(.bottom, 8)
            
            Text(title)
                .font(.title2)
                .fontWeight(.semibold)
                .foregroundStyle(.primary)
            
            Text(message)
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 32)
            
            if let action = action {
                Button(action: action) {
                    Text("Try Again")
                        .fontWeight(.medium)
                        .padding(.horizontal, 24)
                        .padding(.vertical, 12)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                .padding(.top, 16)
            }
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

#Preview {
    EmptyStateView(action: {})
}
