//
//  ContentView.swift
//  CollectionViewSampleApp
//
//  Created by 藤治仁 on 2024/08/12.
//
import SwiftUI

struct ContentView: View {
    @State private var cards: [Card] = [
        Card(emoji: "➕")
    ]
    
    private let candidatesCards: [Card] = [
        Card(emoji: "😀"),
        Card(emoji: "❤️"),
        Card(emoji: "🎵"),
        Card(emoji: "☕️"),
        Card(emoji: "📚"),
        Card(emoji: "💖"),
        Card(emoji: "⚽️"),
        Card(emoji: "🎉"),
        Card(emoji: "😎"),
        Card(emoji: "🔥"),
        Card(emoji: "🐶"),
        Card(emoji: "📢"),
        Card(emoji: "🔎"),
        Card(emoji: "🔦"),
        Card(emoji: "📥"),
        Card(emoji: "👚"),
        Card(emoji: "🐼"),
        Card(emoji: "🐷"),
        Card(emoji: "🐒"),
        Card(emoji: "🦆"),
    ]
    
    var body: some View {
        GeometryReader { reader in
            VStack {
                ZStack {
                    CollectionViewControllerRepresentable(
                        cards: cards,
                        spacing: 24,
                        cellSize: CGSizeMake(100, 100)
                    ) { card in
                        print(">>Debug \(#fileID) \(#line) selectedItem=\(card)")
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: 150)
                    .offset(x: -3.5)
                    
                    Circle()
                        .strokeBorder(.black, lineWidth: 2)
                        .frame(width: 120, height: 120)
                    
                }
                .padding(.top, 28)
                
                HStack {
                    Button {
                        self.cards.removeFirst()
                    } label: {
                        Text("Remove First")
                            .padding()
                    }
                    
                    Button {
                        let card = candidatesCards.randomElement()!
                        self.cards.append(card)
                    } label: {
                        Text("Add Card")
                            .padding()
                    }
                    
                    Button {
                        self.cards.removeLast()
                    } label: {
                        Text("Remove Last")
                            .padding()
                    }
                }
            }
        }
    }
}


struct Card: Identifiable {
    var id: UUID = UUID()
    let emoji: String
}

#Preview {
    ContentView()
}
