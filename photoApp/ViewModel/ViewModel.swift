//
//  ViewModel.swift
//  photoApp
//
//  Created by Kihyun Choi on 2020/06/27.
//  Copyright © 2020 kakaopay. All rights reserved.
//

import UIKit

struct ImageForCell {
    let image: UIImage
}

class ViewModel {
    // MARK: Properties
    var mode:String?
    var photos: [ImageDetail]? {
        didSet {
            self.fetchPhoto()
        }
    }
    var imageForCell: [ImageForCell] = []
    
    var isLodingData:Bool = false {
        didSet {
            showLoading?()
        }
    }

    var showLoading: (() -> Void)?
    var reloadData: (() -> Void)?
    var showError: ((Error) -> Void)?

    init() {
        
    }

    func fetchAllPhotos(page:Int) {
        self.isLodingData = true
        let imageRequest = DataRequest(page: page)
        imageRequest.getImageData { [weak self] result in
            switch result {
            case .failure(let error):
                self?.showError?(error)
            case .success(let images):
                self?.photos = images
            }
        }
    }
    
    func fetchQueryPhotos(query:String, page:Int) {
        self.isLodingData = true
        let imageRequest = SearchRequest(searchStr:query, page: page)
        imageRequest.getImageData { [weak self] result in
            switch result {
            case .failure(let error):
                self?.showError?(error)
            case .success(let images):
                self?.photos = images
            }
        }
    }

    private func fetchPhoto() {
        let group = DispatchGroup()
        DispatchQueue.global(qos: .background).async(group: group) {
            group.enter()
            self.photos?.forEach { (photo) in
                guard let imageData = try? Data(contentsOf: photo.urls.thumb) else {
                    self.showError?(UnsplashError.noDataAvailable)
                    return
                }

                guard let image = UIImage(data: imageData) else {
                    self.showError?(UnsplashError.canNotProcessData)
                    return
                }

                self.imageForCell.append(ImageForCell(image: image))
            }
            group.leave()
        }
        group.notify(queue: .main) {
            self.isLodingData = false
            self.reloadData?()
        }
    }
}
