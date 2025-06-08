//
//  BannerView.swift
//  CartoonMe
//
//  Created by Yuri Petrosyan on 11/04/2025.
//

import SwiftUI

struct AppBannerItem: Identifiable {
    var id: UUID = UUID()
    var title: String
    var image: String
    var isNew: Bool
    let action: () -> Void
    var logo: String?
}

struct AppBannerView: View {
    let item: AppBannerItem
    var body: some View {
        Button(action: item.action) {
            ZStack(alignment: .leading) {
                // Background Image
                Image(item.image)
                    .resizable()
                    .scaledToFill()
                    .frame(height: 230)
                    .clipShape(RoundedRectangle(cornerRadius: 15))
                    .overlay(
                        RoundedRectangle(cornerRadius: 15)
                            .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                    )
                VStack{
                    Spacer()
                    // Overlay Content
                    HStack {
                        Image(item.logo ?? "")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 90)
                        Spacer()
                        Text("Try Now")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding(.vertical, 10)
                            .padding(.horizontal, 20)
                            .background(
                                LinearGradient(
                                    gradient: Gradient(colors: [Color.purple, Color.blue]),
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                                .clipShape(RoundedRectangle(cornerRadius: 20))
                            )
                    }
                    .padding(.horizontal)
                    .offset(y: 10)
                    .background(
                        VStack {
                            Spacer()
                            Rectangle()
                                .fill(.ultraThinMaterial)
                                .frame(height: 130)
                                .mask {
                                    LinearGradient(colors: [Color.black, Color.black, Color.black, Color.black.opacity(0)], startPoint: .bottom, endPoint: .top)
                                }
                        }
                    )
                }.frame(height: 232)
                    .clipShape(RoundedRectangle(cornerRadius: 15))
                // NEW Badge
                if item.isNew {
                    Text("NEW")
                        .font(.caption)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding(.vertical, 5)
                        .padding(.horizontal, 10)
                        .background(Color.purple)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .position(x: 40, y: 20) // Top-left corner
                }
            }
            .padding(.horizontal)
        }
    }
}

#Preview {
    AppBannerView(item: AppBannerItem(title: "Disney", image: "DisneyImage", isNew: true, action: {}, logo: "DisneyLogo"))
    AppBannerView(item: AppBannerItem(title: "Studio Ghibli", image: "GhibliImage", isNew: false, action: {}, logo: nil))
}
