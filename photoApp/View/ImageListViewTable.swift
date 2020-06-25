//
//  ImageListViewTable.swift
//  photoApp
//
//  Created by Kihyun Choi on 2020/06/25.
//  Copyright © 2020 kakaopay. All rights reserved.
//

import UIKit

class ImageListViewTable: UITableView, UITableViewDelegate, UITableViewDataSource {
    
    var scrollDidReachEnd = false
    var testArray = [0, 1, 2]
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.delegate = self
        self.dataSource = self
        self.reloadData()
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return testArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tableCell", for: indexPath)
        cell.textLabel?.text = "\(testArray[indexPath.row])"
        return cell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        
        if offsetY >= (contentHeight - self.frame.size.height) {
            if(!scrollDidReachEnd) {
                downloadImage()
            }
            
        }
    }
    
    func downloadImage() {
        
    }
}
