//
//  SWCarouselViewController.swift
//  SWCarouselViewController
//
//  Created by Zi Sean on 05/02/2021.
//

import UIKit

protocol SWCarouselViewControllerDelegate: AnyObject{
    func numberOfItems() -> Int
    func carouselView(collectionView: UICollectionView, indexPath: IndexPath) -> UICollectionViewCell
    func carouselViewDidSwipeTo(row:Int)
    func carouselViewWillSwipeTo(row:Int)
    func carouselViewWillDisplay(cell: UICollectionViewCell, indexPath: IndexPath)
    func carouselViewDidDisplay(cell: UICollectionViewCell, indexPath: IndexPath)
}

extension SWCarouselViewControllerDelegate{
    func carouselViewDidSwipeTo(row:Int){}
    func carouselViewWillSwipeTo(row:Int){}
    func carouselViewWillDisplay(cell: UICollectionViewCell, indexPath: IndexPath){}
    func carouselViewDidDisplay(cell: UICollectionViewCell, indexPath: IndexPath){}
}

class SWCarouselViewController: UIViewController {
    var menuView = PickerView()
    var menuCollectionView: UICollectionView?
    var contentCollectionView: UICollectionView!
    weak var swCarouselViewControllerDelegate: SWCarouselViewControllerDelegate?
    var menuViewHeightConstraint: NSLayoutConstraint!
    lazy var reloadOnLoadOnceOnly:() -> Void = {
        self.contentCollectionView.reloadData()
        return {}
    }()
    var currentPage:Int = 0
    var isMenuViewScrolling: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //MenuView
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "PickerView", bundle: bundle)
        menuView = nib.instantiate(withOwner: self, options: nil).first as! PickerView
        menuView.translatesAutoresizingMaskIntoConstraints = false
        menuView.collectionPicker.delegate = self
        menuView.collectionPicker.dataSource = self
        menuView.collectionPicker.register(NumberCell.self, forCellWithReuseIdentifier: "NumberCell")
        menuCollectionView = menuView.collectionPicker
        self.view.addSubview(menuView)
        
        self.edgesForExtendedLayout = []

        //ContentCollectionView
        contentCollectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: 0, height: 0), collectionViewLayout: UICollectionViewFlowLayout())
        contentCollectionView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(contentCollectionView)
        
        menuViewHeightConstraint = menuView.heightAnchor.constraint(equalToConstant: 100)

        NSLayoutConstraint.activate([
            menuView.topAnchor.constraint(equalTo: self.view.topAnchor),
            menuViewHeightConstraint,
            menuView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            menuView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            contentCollectionView.topAnchor.constraint(equalTo: menuView.bottomAnchor),
            contentCollectionView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            contentCollectionView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            contentCollectionView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ])
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.minimumLineSpacing = 0
        contentCollectionView.setCollectionViewLayout(layout, animated: true)
        contentCollectionView.isPagingEnabled = true
        contentCollectionView.decelerationRate = UIScrollView.DecelerationRate.fast
        contentCollectionView.backgroundColor = .white
        contentCollectionView.showsHorizontalScrollIndicator = false
        contentCollectionView.delegate = self
        contentCollectionView.dataSource = self
        contentCollectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "ContentCollectionViewCell")
    }
    
    func onFirstLoadSelect(item: Int){
        var itemNum = item
        if item >= swCarouselViewControllerDelegate?.numberOfItems() ?? 0{
            itemNum = (swCarouselViewControllerDelegate?.numberOfItems() ?? 1) - 1
        }
        if itemNum >= 0 {
            self.menuCollectionView?.performBatchUpdates({
                self.menuCollectionView?.selectItem(at: IndexPath(item: itemNum, section: 0), animated: false, scrollPosition: .centeredHorizontally)
            }, completion: nil)
            
            self.contentCollectionView.performBatchUpdates({
                self.contentCollectionView.scrollToItem(at: IndexPath(item: itemNum, section: 0), at: .centeredHorizontally, animated: false)
            }, completion: nil)
            self.currentPage = itemNum
        }
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.reloadOnLoadOnceOnly()
    }
    
    func scrollToPage(index: Int) {
        var indexNum = index
        if indexNum >= swCarouselViewControllerDelegate?.numberOfItems() ?? 0 {
            indexNum = (swCarouselViewControllerDelegate?.numberOfItems() ?? 1) - 1
        }
        if indexNum >= 0 {
            self.menuCollectionView?.selectItem(at: IndexPath(item: indexNum, section: 0), animated: false, scrollPosition: .centeredHorizontally)
            self.contentCollectionView.scrollToItem(at: IndexPath(item: indexNum, section: 0), at: .centeredHorizontally, animated: false)
            self.currentPage = indexNum
        }
    }
}

extension SWCarouselViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let delegate = swCarouselViewControllerDelegate else{return 10}
        return delegate.numberOfItems()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == menuCollectionView{
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NumberCell", for: indexPath) as? NumberCell{
                cell.configure(textLabelText: "\(indexPath.item)")
                return cell
            }
        }else{
            guard let delegate = swCarouselViewControllerDelegate else {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ContentCollectionViewCell", for: indexPath)
                return cell
            }
            return delegate.carouselView(collectionView: collectionView, indexPath: indexPath)
            
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.menuView.collectionPicker.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        self.contentCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        self.currentPage = indexPath.item
        swCarouselViewControllerDelegate?.carouselViewWillSwipeTo(row: indexPath.item)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == contentCollectionView {
            return contentCollectionView.frame.size
        }else if collectionView == menuCollectionView{
            return CGSize(width: 100, height: 100)
        }
        
        return CGSize()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        swCarouselViewControllerDelegate?.carouselViewWillDisplay(cell: cell, indexPath: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        swCarouselViewControllerDelegate?.carouselViewDidDisplay(cell: cell, indexPath: indexPath)
    }
    
}

extension SWCarouselViewController: UIScrollViewDelegate{
    func scrollToNearestVisibleCollectionViewCell() {
        let visibleCenterPositionOfScrollView = Float((menuCollectionView?.contentOffset.x)! + ((self.menuCollectionView?.bounds.size.width)! / 2))
        var closestCellIndex = -1
        var closestDistance: Float = .greatestFiniteMagnitude
        
        if let menuCVCell = menuCollectionView?.visibleCells{
            for i in 0..<menuCVCell.count {
                let cell = menuCollectionView?.visibleCells[i]
                let cellWidth = cell?.bounds.size.width
                let cellCenter = Float((cell?.frame.origin.x)! + cellWidth! / 2)
                
                // Now calculate closest cell
                let distance: Float = fabsf(visibleCenterPositionOfScrollView - cellCenter)
                if distance < closestDistance {
                    closestDistance = distance
                    closestCellIndex = (menuCollectionView?.indexPath(for: cell!)!.row)!
                }
            }
        }
        
        if closestCellIndex != -1 {
            self.contentCollectionView?.scrollToItem(at: IndexPath(row: closestCellIndex, section: 0), at: .centeredHorizontally, animated: true)
            self.menuCollectionView?.selectItem(at: IndexPath(row: closestCellIndex, section: 0), animated: true, scrollPosition: .centeredHorizontally)
            swCarouselViewControllerDelegate?.carouselViewDidSwipeTo(row: closestCellIndex)
            self.currentPage = closestCellIndex
        }
        isMenuViewScrolling = false
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if scrollView ==  self.menuCollectionView{
            scrollToNearestVisibleCollectionViewCell()
        }
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            if scrollView ==  self.menuCollectionView{
                scrollToNearestVisibleCollectionViewCell()
            }
        }
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        if scrollView == menuCollectionView {
            isMenuViewScrolling = scrollView.isTracking
        }
        
        if !isMenuViewScrolling {
            if scrollView == self.contentCollectionView{
                let row = Int(targetContentOffset.pointee.x / view.frame.width)
                self.menuCollectionView?.selectItem(at: IndexPath(row: row, section: 0), animated: true, scrollPosition: .centeredHorizontally)
                swCarouselViewControllerDelegate?.carouselViewWillSwipeTo(row: row)
                self.currentPage = row
            }
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        CATransaction.begin()
        CATransaction.setValue(kCFBooleanTrue, forKey: kCATransactionDisableActions)
        self.menuCollectionView?.layer.mask?.frame = (self.menuCollectionView?.bounds)!
        CATransaction.commit()
    }
}
