//
//  CardView.swift
//  CollectionViewSampleApp
//
//  Created by 藤治仁 on 2024/08/12.
//

import SwiftUI

struct CardView: View {
    let card: Card
    let width: CGFloat
    let height: CGFloat
    var body: some View {
        ZStack {
            Rectangle()
                .foregroundColor(.blue)
                .cornerRadius(20)
            Text(card.emoji)
                .font(.system(size: 100, weight: .bold))
        }
        .frame(width: width, height: height)
    }
}

#Preview {
    CardView(
        card: Card(emoji: "😀"),
        width: 100,
        height: 100
    )
}
