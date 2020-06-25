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
    
    var imageList = [ImageDetail]() {
        didSet {
            DispatchQueue.main.async {
                self.reloadData()
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.delegate = self
        self.dataSource = self
        downloadImage()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return imageList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tableCell", for: indexPath) as! ImageListViewCell
        let imageData = imageList[indexPath.row]
        let image:UIImage? = UIImage(data: (imageData.urls?.regular?.data(using: .utf8))!)
        cell.photoView.image = image
        cell.likes.text = "Likes: \(String(describing: imageData.likes))"
        return cell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        
        if offsetY >= (contentHeight - self.frame.height) {
            if(!scrollDidReachEnd) {
                scrollDidReachEnd = true
                downloadImage()
            }
            
        }
    }
    
    func downloadImage() {
        print("image Requested")
        let imageRequest = DataRequest(searchStr: "")
        imageRequest.getImageData { [weak self] result in
            switch result {
            case .failure(let error):
                print(error)
            case .success(let images):
                self?.imageList = images
                self?.scrollDidReachEnd = false
                print("image Downloaded")
            }
        }
    }
}
