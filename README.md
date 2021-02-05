# SWCarouselViewController

## About The Project
Simple and Eeasy to modify Carousel View!

## Screenshot
<img src="https://github.com/seanwohc/SWCarouselViewController/blob/master/Screen%20Recording%202021-02-05%20at%204.26.38%20PM.gif" width="250">

## Getting Started

Copy the files from SWCarouselViewController/Sources into your project

## Usage
```Swift

// Subclass on SWCarouselViewController and add delegate
class ViewController: SWCarouselViewController, SWCarouselViewControllerDelegate{

    override func viewDidLoad() {
        super.viewDidLoad()
        self.contentCollectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        self.swCarouselViewControllerDelegate = self
        self.onFirstLoadSelect(item: 0)
    }
    
    //set the number of items
    func numberOfItems() -> Int {
        return 5
    }

    //Add custom cell, the size will fit automatically
    func carouselView(collectionView: UICollectionView, indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        cell.backgroundColor = .random
        return cell
    }
}                                               
```

## License
Distributed under the MIT License. See `LICENSE` for more information.
