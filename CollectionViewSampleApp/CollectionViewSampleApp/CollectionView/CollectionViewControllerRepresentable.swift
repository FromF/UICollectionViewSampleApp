//
//  CollectionViewControllerRepresentable.swift
//  CollectionViewSampleApp
//
//  Created by 藤治仁 on 2024/08/12.
//

import SwiftUI

struct CollectionViewControllerRepresentable: UIViewControllerRepresentable {
    let cards: [Card]
    let spacing: CGFloat
    let cellSize: CGSize
    let selectedItem: ((Card) -> Void)?

    func makeUIViewController(context: Context) -> CollectionViewController {
        let viewController = CollectionViewController()
        viewController.spacing = spacing
        viewController.selectedItem = { card in
            selectedItem?(card)
        }
        return viewController
    }
    
    func updateUIViewController(_ uiViewController: CollectionViewController, context: Context) {
        uiViewController.setCards(cards)
    }
}
