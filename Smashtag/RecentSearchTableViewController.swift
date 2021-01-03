//
//  RecentSearchTableViewController.swift
//  Smashtag
//
//  Created by Chien on 2017/8/8.
//  Copyright © 2017年 Chien. All rights reserved.
//

import UIKit

class RecentSearchTableViewController: UITableViewController {

    let cellIdentifier: String = "RecentSearchTableViewCell"

    var totalTagInCoreData: [Tag] {
        return CoreData().fetchCoreData()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.tableView.reloadData()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: self.cellIdentifier)

        self.navigationItem.title = Constant.Title.recentPage
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(self.deleteAllCoreData(_:)))
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.totalTagInCoreData.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let recentSearchCell = self.tableView.dequeueReusableCell(withIdentifier: self.cellIdentifier) else { return UITableViewCell() }

        recentSearchCell.textLabel?.text = self.totalTagInCoreData[indexPath.row].name
        recentSearchCell.accessoryType = .disclosureIndicator

        return recentSearchCell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let textInRow = self.tableView.cellForRow(at: indexPath)?.textLabel?.text else { return }
        guard let showingDataViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: ShowingDataViewController.identifier) as? ShowingDataViewController else { return }

        showingDataViewController.searchRequest = showingDataViewController.getSearchRequest(with: textInRow, num: Constant.Search.howManyItems)
        showingDataViewController.handleSearch()
        showingDataViewController.changeUIStyleInMultipleSearching()

        self.show(showingDataViewController, sender: nil)
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            guard let textInRow = self.tableView.cellForRow(at: indexPath)?.textLabel?.text else { return }
            CoreData().deleteCoreData(with: textInRow) // 刪除單個
            self.tableView.deleteRows(at: [indexPath], with: .fade) // 只刪除那一筆 (也可以適用於多筆刪除 -> 丟 Array 參數進去)
        }
    }

    // MARK: Delete All Items From Core Data
    func deleteAllCoreData(_ sender: UIBarButtonItem) {
        let alertController = UIAlertController(title: "警告 !!!", message: "確定要清空所有歷史紀錄嗎 ?", preferredStyle: .alert)

        let noToCancel = UIAlertAction(title: "取消", style: .default, handler: nil)
        let yesToDelete = UIAlertAction(title: "刪除", style: .destructive) { (_) in
            CoreData().deleteCoreDataAll() // 刪除全部
            self.tableView.reloadData() // 若刪除全部，用 ReloadData 會比 Array 一個一個刪除還快
        }

        alertController.addAction(yesToDelete)
        alertController.addAction(noToCancel)
        self.present(alertController, animated: true, completion: nil)
    }

}
