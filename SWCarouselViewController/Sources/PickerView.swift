//
//  PickerView.swift
//  SWCarouselViewController
//
//  Created by Zi Sean on 05/02/2021.
//

import UIKit

class PickerView: UIView {
    @IBOutlet var collectionPicker: UICollectionView!
    
    let collectionPickerViewLayout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
    
    private let maskLayer = CAGradientLayer()
    override func awakeFromNib() {
        super.awakeFromNib()
        collectionPickerViewLayout.scrollDirection = .horizontal
        collectionPickerViewLayout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        collectionPickerViewLayout.itemSize = CGSize(width: 100, height: 100)
        collectionPickerViewLayout.minimumLineSpacing = 0
        self.collectionPicker.setCollectionViewLayout(collectionPickerViewLayout, animated: true)

        self.collectionPicker.alwaysBounceHorizontal = true
        self.collectionPicker.decelerationRate = UIScrollView.DecelerationRate.fast
        self.collectionPicker.backgroundColor = .white
        self.collectionPicker.showsHorizontalScrollIndicator = false
    }
}

class NumberCell: UICollectionViewCell {
    
    var textLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
    var highlightedColor: UIColor = .random
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setupView()
    }
    
    func setupView() {
        textLabel.textAlignment = .center
        self.contentView.addSubview(textLabel)
        textLabel.font = UIFont.systemFont(ofSize: 48.0, weight: isSelected ? .heavy : .semibold)
    }
    
    func configure(textLabelText: String){
        textLabel.text = textLabelText
        textLabel.frame.size.width = textLabel.intrinsicContentSize.width + 10
    }
    
    func configure(textLabelText: String, textGap: CGFloat){
        textLabel.text = textLabelText
        textLabel.frame.size.width = textLabel.intrinsicContentSize.width + 10 + textGap
    }
    
    static func getCellSize(cellTitle: String, textGap: CGFloat) -> CGSize{
        let textLabel: UILabel = UILabel()
        textLabel.text = cellTitle
        return CGSize(width: (textLabel.intrinsicContentSize.width + 10 + textGap), height: 35)
    }
    
    override var isSelected: Bool{
        didSet{
            textLabel.font = UIFont.systemFont(ofSize: 48.0, weight: isSelected ? .heavy : .semibold)
            textLabel.textColor = isSelected ? highlightedColor : .black
        }
    }
    
    override var isHighlighted: Bool{
        didSet{
            textLabel.font = UIFont.systemFont(ofSize: 48.0, weight: isSelected ? .heavy : .semibold)
            textLabel.textColor = isSelected ? highlightedColor : .black
        }
    }
    
}
