//
//  DetailDataTableViewController.swift
//  Smashtag
//
//  Created by Chien on 2017/8/8.
//  Copyright © 2017年 Chien. All rights reserved.
//

import UIKit
import Twitter

enum SectionHeader: String {
    case image = "Images"
    case hashTag = "Hashtags"
    case user = "Users"
    case url = "URLs"
}

class DetailDataTableViewController: UITableViewController {

    static let identifier: String = "DetailDataTableViewController"

    let cellIdentifier: String = "DetailDataTableViewCell"

    var singleTweetShowing: Tweet!
    var sectionData: [(name: SectionHeader, num: Int)] {

        var dataContent: [(name: SectionHeader, num: Int)] = []
        dataContent.append((name: .image,   num: self.singleTweetShowing.media.count))
        dataContent.append((name: .hashTag, num: self.singleTweetShowing.hashtags.count))
        dataContent.append((name: .url,     num: self.singleTweetShowing.urls.count))
        dataContent.append((name: .user,    num: self.singleTweetShowing.userMentions.count + 1)) // 包含自己也算 User

        dataContent = dataContent.filter { $0.num > 0 } // 拿掉沒資料的 Section
        return dataContent
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: self.cellIdentifier)

        self.navigationItem.title = "@\(self.singleTweetShowing.user.screenName) (\(self.singleTweetShowing.user.name))"
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return self.sectionData.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.sectionData[section].num
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.sectionData[section].name.rawValue
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let detailDataCell = self.tableView.dequeueReusableCell(withIdentifier: self.cellIdentifier) else { return UITableViewCell() }
        detailDataCell.accessoryType = .disclosureIndicator

        switch self.sectionData[indexPath.section].name {
        case .image :
            detailDataCell.accessoryType = .none // Image 沒有 Next 箭頭

            let postingURL = self.singleTweetShowing.media[indexPath.row].url
            AppDelegate.cacheHelper.findImage(postingURL) { (image) in
                detailDataCell.imageView?.image = image
                detailDataCell.imageView?.contentMode = .scaleAspectFit

                guard let indexPathCell = self.tableView.cellForRow(at: indexPath) else { return }

                // 重劃 Constraint，因為 Default Constraint 的值是 20
                detailDataCell.contentView.translatesAutoresizingMaskIntoConstraints = false
                detailDataCell.imageView?.leadingAnchor.constraint(equalTo: indexPathCell.leadingAnchor).isActive = true
                detailDataCell.imageView?.trailingAnchor.constraint(equalTo: indexPathCell.trailingAnchor).isActive = true
                detailDataCell.imageView?.topAnchor.constraint(equalTo: indexPathCell.topAnchor).isActive = true
                detailDataCell.imageView?.bottomAnchor.constraint(equalTo: indexPathCell.bottomAnchor).isActive = true
            }

        case .hashTag :
            detailDataCell.textLabel?.text = self.singleTweetShowing.hashtags[indexPath.row].keyword

        case .user :
            detailDataCell.textLabel?.text = indexPath.row == 0 ? "@\(self.singleTweetShowing.user.screenName)" :
                self.singleTweetShowing.userMentions[indexPath.row - 1].keyword // 第一個人名一定是自己 (因為是自己發文)

        case .url :
            detailDataCell.textLabel?.text = self.singleTweetShowing.urls[indexPath.row].keyword
        }

        return detailDataCell
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        switch self.sectionData[indexPath.section].name {
        case .image :
            return self.tableView.frame.width / CGFloat(self.singleTweetShowing.media[indexPath.row].aspectRatio)

        default :
            return UITableViewAutomaticDimension
        }
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        switch self.sectionData[indexPath.section].name {
        case .image :
            guard let indexPathCell = self.tableView.cellForRow(at: indexPath) else { return }
            guard let image = indexPathCell.imageView?.image else { return }

            let completeImageViewController = CompleteImageViewController()
            completeImageViewController.image = image

            self.show(completeImageViewController, sender: nil)

        case .url :
            guard let openURL = URL(string: self.singleTweetShowing.urls[indexPath.row].keyword) else { return }

            if UIApplication.shared.canOpenURL(openURL) {
                UIApplication.shared.open(openURL)
            } else {
                let alertController = UIAlertController(title: "錯誤 !!!", message: "您的網址有誤或不安全，請稍後再試 !", preferredStyle: .alert)

                let okayToCancel = UIAlertAction(title: "確定", style: .default, handler: nil)
                alertController.addAction(okayToCancel)
                self.present(alertController, animated: true, completion: nil)
            }

        default :
            guard let textInRow = self.tableView.cellForRow(at: indexPath)?.textLabel?.text else { return }
            guard let showingDataViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: ShowingDataViewController.identifier) as? ShowingDataViewController else { return }

            showingDataViewController.searchRequest = showingDataViewController.getSearchRequest(with: textInRow, num: Constant.Search.howManyItems)
            showingDataViewController.handleSearch()
            showingDataViewController.changeUIStyleInMultipleSearching()

            self.show(showingDataViewController, sender: nil)
        }
    }
}
