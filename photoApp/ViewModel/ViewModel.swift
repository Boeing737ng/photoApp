//
//  ViewModel.swift
//  photoApp
//
//  Created by Kihyun Choi on 2020/11/22.
//  Copyright © 2020 kakaopay. All rights reserved.
//

import UIKit

struct ImageForCell {
    let image: UIImage
}

class ViewModel {
    // MARK: Properties
    
    var setCenterSpinner: (() -> Void)?
    var reloadData: (() -> Void)?
    var showError: ((Error) -> Void)?
    var setBottomSpinner: (() -> Void)?
    
    var isInitialLoad = true
    var mode:String?
    var photos: [ImageDetail] = []
    var imageForCell: [ImageForCell] = []
    
    var isLodingData:Bool = false {
        didSet {
            if isInitialLoad {
                setCenterSpinner?()
            } else {
                setBottomSpinner?()
            }
        }
    }

    init() {
        
    }

    func fetchAllPhotos(page:Int) {
        if self.photos.count != 0 {
            isInitialLoad = false
        }
        self.isLodingData = true
        let imageRequest = DataRequest(page: page)
        imageRequest.getImageData { [weak self] result in
            switch result {
            case .failure(let error):
                self?.showError?(error)
            case .success(let images):
                self?.photos.append(contentsOf: images)
                self?.fetchImagesFromJson(images: images)
                self?.dataRequestDidFinish()
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
                self?.photos.append(contentsOf: images)
                self?.fetchImagesFromJson(images: images)
                self?.dataRequestDidFinish()
            }
        }
    }
    
    func fetchImagesFromJson(images:[ImageDetail]) {
        images.forEach { (image) in
            guard let imageData = try? Data(contentsOf: image.urls.thumb) else {
                self.showError?(UnsplashError.noDataAvailable)
                return
            }
            guard let image = UIImage(data: imageData) else {
                self.showError?(UnsplashError.canNotProcessData)
                return
            }
            self.imageForCell.append(ImageForCell(image: image))
        }
    }
    
    func dataRequestDidFinish() {
        DispatchQueue.main.async {
            self.isLodingData = false
            self.reloadData?()
        }
    }
}
