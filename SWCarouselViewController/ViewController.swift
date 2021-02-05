//
//  ViewController.swift
//  SWCarouselViewController
//
//  Created by Zi Sean on 05/02/2021.
//

import UIKit

class ViewController: SWCarouselViewController, SWCarouselViewControllerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.contentCollectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        self.swCarouselViewControllerDelegate = self
        self.onFirstLoadSelect(item: 0)
    }

    func numberOfItems() -> Int {
        return 5
    }

    func carouselView(collectionView: UICollectionView, indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        cell.backgroundColor = .random
        return cell
    }
    
}

extension UIColor {
    static var random: UIColor {
        return UIColor(red: .random(in: 0...1),
                       green: .random(in: 0...1),
                       blue: .random(in: 0...1),
                       alpha: 1.0)
    }
}
