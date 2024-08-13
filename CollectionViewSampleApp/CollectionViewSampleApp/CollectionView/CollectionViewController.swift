//
//  CollectionViewController.swift
//  CollectionViewSampleApp
//
//  Created by 藤治仁 on 2024/08/12.
//

import SwiftUI

class CollectionViewController: UIViewController {
    var spacing: CGFloat = 24
    var cellSize: CGSize = CGSizeMake(100, 100)
    var selectedItem: ((Card) -> Void)?
    private var collectionView: UICollectionView!
    private var cards: [Card] = []
    private var centerIndexPath: IndexPath? {
        var indexPath: IndexPath?
        guard collectionView.numberOfItems(inSection: 0) > 0 else {
            return indexPath
        }
        
        for offset in Int(spacing * -1)...Int(spacing) {
            let centerPoint = CGPoint(x: collectionView.center.x + collectionView.contentOffset.x + Double(offset), y: collectionView.center.y)
            indexPath = collectionView.indexPathForItem(at: centerPoint)
            if indexPath != nil {
                break
            }
        }
        return indexPath
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
    }
    
    private func setupCollectionView() {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        flowLayout.itemSize = CGSize(width: 100, height: 100) // 100x100のサイズを指定
        flowLayout.minimumLineSpacing = spacing // セル間の余白を24に設定
        
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: flowLayout)
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.register(SwiftUIHostingCell.self, forCellWithReuseIdentifier: "Cell")
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        view.addSubview(collectionView)
    }
    
    func setCards(_ cards: [Card]) {
        let isNeedAlignCellToCenter = self.cards.isEmpty
        self.cards = cards
        collectionView.reloadData()
        if isNeedAlignCellToCenter {
            Task { @MainActor in
                _ = try? await Task.sleep(nanoseconds: UInt64(0.2 * 1_000_000_000))
                alignCellToCenter()
            }
        }
    }
}

extension CollectionViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let centerIndexPath = centerIndexPath else {
            return
        }
        
        if indexPath == centerIndexPath {
            // 中央のセルがタップされた場合
            selectedItem?(cards[indexPath.row])
            print(">>Debug \(#fileID) \(#line) indexPath=\(indexPath) Selected")
        } else {
            // 中央以外のセルがタップされた場合
            scrollToCenter(indexPath: indexPath)
        }
    }
    
    // 中央以外のセルがタップされたときに、そのセルを中央に移動させる処理
    private func scrollToCenter(indexPath: IndexPath) {
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
    }
}

extension CollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        // 最初と最後のセルに適用する余白
        let firstLastInset = collectionView.bounds.size.width / 2
        
        return UIEdgeInsets(top: 0, left: firstLastInset, bottom: 0, right: firstLastInset)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return spacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return cellSize
    }
}
extension CollectionViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        print(">>Debug \(#fileID) \(#line) numberOfItems = \(collectionView.numberOfItems(inSection: 0))")
        guard collectionView.numberOfItems(inSection: 0) > 0 else { return }
        
        for cell in collectionView.visibleCells {
            let cellCenter = collectionView.convert(cell.center, to: collectionView.superview)
            let collectionViewCenter = collectionView.bounds.size.width / 2
            let distance = abs(cellCenter.x - collectionViewCenter)
            let scale = max(1.0, 1.25 - (distance / collectionView.bounds.size.width))
            
            cell.transform = CGAffineTransform(scaleX: scale, y: scale)
        }
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        print(">>Debug \(#fileID) \(#line) decelerate = \(decelerate)")
        if !decelerate {
            alignCellToCenter()
        }
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        print(">>Debug \(#fileID) \(#line)  ")
        alignCellToCenter()
    }

    private func alignCellToCenter() {
        print(">>Debug \(#fileID) \(#line) centerIndexPath = \(String(describing: centerIndexPath))")
        if let indexPath = centerIndexPath {
            scrollToCenter(indexPath: indexPath)
        }
    }
}

extension CollectionViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // データ数
        return cards.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! SwiftUIHostingCell
        
        cell.configure(
            with: CardView(
                card: cards[indexPath.row],
                width: cellSize.width,
                height: cellSize.height
            )
        )
        
        return cell
    }
}
