//
//  ViewController.swift
//  photoApp
//
//  Created by Kihyun Choi on 2020/06/25.
//  Copyright © 2020 kakaopay. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    
    //MARK:  - Properties
    
    var images = [ImageDetail]() {
        didSet {
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        if let layout = collectionView.collectionViewLayout as? PinterestLayout {
            layout.delegate = self
        }
        collectionView.contentInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        downloadImage()
    }
    
    func downloadImage() {
        let imageRequest = DataRequest(searchStr: "")
        imageRequest.getImageData { [weak self] result in
            switch result {
            case .failure(let error):
                print(error)
            case .success(let images):
                self?.images.append(contentsOf: images)
            }
        }
    }
    
}

extension ViewController: PinterestLayoutDelegate {
    func collectionView(_ collectionView: UICollectionView, heightForPhotoAtIndexPath indexPath: IndexPath) -> CGFloat {
        let imageAt = images[indexPath.item]
        guard let image = try? Data(contentsOf: imageAt.urls!.thumb) else {
            return 0
        }
        let height:CGFloat = CGFloat((UIImage(data: image)?.size.height)!)
        
        return height
    }
}

//MARK: Data source

extension ViewController:UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "imageCell", for: indexPath) as! ImageCell
        let imageAt = images[indexPath.item]
        guard let image = try? Data(contentsOf: imageAt.urls!.thumb) else {
            return cell
        }
        cell.imageView.image = UIImage(data: image)
        return cell
    }
}
