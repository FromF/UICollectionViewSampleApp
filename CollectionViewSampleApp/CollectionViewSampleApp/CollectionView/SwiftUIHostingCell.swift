//
//  SwiftUIHostingCell.swift
//  CollectionViewSampleApp
//
//  Created by 藤治仁 on 2024/08/12.
//

import SwiftUI

class SwiftUIHostingCell: UICollectionViewCell {
    private var hostingController: UIHostingController<AnyView>?
    
    func configure<Content: View>(with swiftUIView: Content) {
        if hostingController == nil {
            let hostingController = UIHostingController(rootView: AnyView(swiftUIView))
            hostingController.view.backgroundColor = .clear
            contentView.addSubview(hostingController.view)
            hostingController.view.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                hostingController.view.topAnchor.constraint(equalTo: contentView.topAnchor),
                hostingController.view.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
                hostingController.view.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
                hostingController.view.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
            ])
            self.hostingController = hostingController
        } else {
            hostingController?.rootView = AnyView(swiftUIView)
        }
    }
}
