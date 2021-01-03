//
//  ShowingDataViewController.swift
//  Smashtag
//
//  Created by Chien on 2017/8/2.
//  Copyright © 2017年 Chien. All rights reserved.
//

import UIKit
import Twitter

enum DataType {
    case tweet
    case image
}

class ShowingDataViewController: BasicViewController, UISearchBarDelegate {

    static let identifier: String = "ShowingDataViewController"

    let imageShowingNum: Int = 3
    var imageShowing: [(index: Int, url: URL)] = []
    var tweetShowing: [Tweet] = []

    var searchRequest: Request?

    var nowDataType: DataType {
        return self.typeSegmentedControl.selectedSegmentIndex == 0 ? .tweet : .image
    }

    @IBOutlet weak var dataCollectionView: UICollectionView!
    @IBOutlet weak var tagSearchBar: UISearchBar!
    @IBOutlet weak var typeSegmentedControl: UISegmentedControl!
    @IBOutlet weak var labelNoData: UILabel!

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)

        switch self.nowDataType {
        case .tweet :
            for item in 0 ..< self.dataCollectionView.visibleCells.count {
                let indexPath = IndexPath(item: item, section: 0)

                // 更新每個 Cell 的 Label constranit，更新他的 WidthConstraint
                guard let indexCell = self.dataCollectionView.cellForItem(at: indexPath) as? TweetDataCollectionViewCell else { return }
                indexCell.updateWidthConstraint(with: size.width)
            }

        case .image :
            guard let collectionViewLayout = self.dataCollectionView.collectionViewLayout as? UICollectionViewFlowLayout else { return }
            let imageWidthAndLength = size.width / CGFloat(self.imageShowingNum)
            collectionViewLayout.itemSize = CGSize(width: imageWidthAndLength, height: imageWidthAndLength)
        }

        self.dataCollectionView.collectionViewLayout.invalidateLayout() // 讓 CollectionView 重構 Layout，重跑 CellForItem
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.dataCollectionView.delegate = self
        self.dataCollectionView.dataSource = self
        self.dataCollectionView.keyboardDismissMode = .onDrag

        self.dataCollectionView.collectionViewLayout = self.getFlowLayout()
        self.dataCollectionView.register(UINib(nibName: TweetDataCollectionViewCell.identifier, bundle: nil), forCellWithReuseIdentifier: TweetDataCollectionViewCell.identifier)
        self.dataCollectionView.register(UINib(nibName: ImageDataCollectionViewCell.identifier, bundle: nil), forCellWithReuseIdentifier: ImageDataCollectionViewCell.identifier)

        self.tagSearchBar.delegate = self
        self.typeSegmentedControl.addTarget(self, action: #selector(self.controlShowing(sender:)), for: .valueChanged)

        self.navigationItem.title = Constant.Title.searchPage
    }

    // MARK: When Search Bar Clicked
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let tag = searchBar.text else { return }
        CoreData().saveCoreData(with: tag)

        self.searchRequest = self.startNewSearch(with: tag, num: Constant.Search.howManyItems)
        self.handleSearch()
    }

    // MARK: Reset Request When Search New Tag
    func startNewSearch(with tag: String, num: Int) -> Request? {

        self.tweetShowing = []
        self.imageShowing = []
        self.dataCollectionView.reloadData()
        self.dataCollectionView.collectionViewLayout.invalidateLayout()

        return self.getSearchRequest(with: tag, num: num)
    }

    // MARK: Handle Search And Set Data To Models
    func handleSearch() {

        self.getRequestData(use: self.searchRequest, nowTweetCount: self.tweetShowing.count) { (fetchTweets, fetchImages) in

            self.searchRequest = self.searchRequest?.older // 只有第一次是 Normal，之後都是 Older

            // 下滑後，會不斷累加 dataSource
            self.tweetShowing += fetchTweets
            self.imageShowing += fetchImages

            let beforeIndex = self.nowDataType == .tweet ? self.tweetShowing.count - fetchTweets.count :
                                                            self.imageShowing.count - fetchImages.count
            let afterIndex = self.nowDataType == .tweet ? self.tweetShowing.count : self.imageShowing.count

            var requestData: [IndexPath] = []
            for index in beforeIndex ..< afterIndex {
                requestData.append(IndexPath(row: index, section: 0))
            }

            self.dataCollectionView.insertItems(at: requestData)
            self.checkIfNoData()
        }
    }

    // MARK: Control Showing Data Type
    func controlShowing(sender: UISegmentedControl) {
        self.prepareForNewDataType() // 轉換 Layout 以及要顯示的 Data
    }

    // MARK: Change UI Style When User Is Multiple Searching
    func changeUIStyleInMultipleSearching() {
        self.tagSearchBar.isHidden = true // 繼續點擊查詢就不提供搜尋功能
    }

    // MARK: Do New Layout For New Data
    fileprivate func prepareForNewDataType() {
        self.dataCollectionView.reloadData()
        self.dataCollectionView.collectionViewLayout = UICollectionViewLayout() // 取消前一個 type 的 layout 行為
        self.dataCollectionView.collectionViewLayout = self.getFlowLayout()
        self.dataCollectionView.collectionViewLayout.invalidateLayout()

        self.checkIfNoData()
    }

    // MARK: Get Flow Layout Based On nowDataType
    fileprivate func getFlowLayout() -> UICollectionViewFlowLayout {
        let collectionViewLayout: UICollectionViewFlowLayout = UICollectionViewFlowLayout() // error
        collectionViewLayout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        collectionViewLayout.minimumLineSpacing = 0
        collectionViewLayout.minimumInteritemSpacing = 0

        switch self.nowDataType {
        case .tweet :
            collectionViewLayout.estimatedItemSize = CGSize(width: self.view.frame.width, height: 50)
            // 若 estimatedItemSize 設 (1, 1) -> 會產生 Dynamic height，但是他會先把 Cell 全部都拉出來算一次，會變很慢

        case .image :
            let imageWidthAndLength = self.view.frame.width / CGFloat(self.imageShowingNum)
            collectionViewLayout.itemSize = CGSize(width: imageWidthAndLength, height: imageWidthAndLength)
        }
        
        return collectionViewLayout
    }

    // MARK: Check If There Is No Data
    fileprivate func checkIfNoData() {
        switch self.nowDataType {
        case .tweet :
            self.labelNoData.isHidden = self.tweetShowing.count == 0 ? false : true

        case .image :
            self.labelNoData.isHidden = self.imageShowing.count == 0 ? false : true
        }
    }
}

// MARK: - CollectionView Delegate & DataSource
extension ShowingDataViewController: UICollectionViewDelegate, UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        switch self.nowDataType {
        case .tweet :
            return self.tweetShowing.count

        case .image :
            return self.imageShowing.count
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        switch self.nowDataType {
        case .tweet :
            guard let tweetCell = self.dataCollectionView.dequeueReusableCell(withReuseIdentifier: TweetDataCollectionViewCell.identifier, for: indexPath) as? TweetDataCollectionViewCell else { return UICollectionViewCell() }

            tweetCell.setUpWithRequestData(self.tweetShowing[indexPath.row])
            tweetCell.updateWidthConstraint(with: self.view.frame.width)
            // 設定 Constraint 的部分拿到 CellForItem，是因為如果放在 awakeFromNib 他設定一次後，之後因為 dequeueReuseCell 所以他 Size 都不會再改變
            // 當 Transition 時呼叫 invalidateLayout() 並重跑 CellForItem，此時的 Frame 就是新旋轉的值

            return tweetCell

        case .image :
            guard let imageCell = self.dataCollectionView.dequeueReusableCell(withReuseIdentifier: ImageDataCollectionViewCell.identifier, for: indexPath) as? ImageDataCollectionViewCell else { return UICollectionViewCell() }

            imageCell.setUpWithRequestData(self.imageShowing[indexPath.row])
            return imageCell
        }
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let detailDataTableViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: DetailDataTableViewController.identifier) as? DetailDataTableViewController else { return }

        switch self.nowDataType {
        case .tweet :
            detailDataTableViewController.singleTweetShowing = self.tweetShowing[indexPath.row]

        case .image :
            detailDataTableViewController.singleTweetShowing = self.tweetShowing[self.imageShowing[indexPath.row].index]
        }

        self.show(detailDataTableViewController, sender: nil)
    }

    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {

        let draggOffset: CGFloat = 10.0
        let currentOffset = scrollView.contentOffset.y
        let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height

        if maximumOffset - currentOffset <= draggOffset {
            self.handleSearch()
        }
    }
}
