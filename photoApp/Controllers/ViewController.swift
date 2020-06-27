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
    @IBOutlet weak var searchBar: UISearchBar!
    
    //MARK:  - Properties
    let UPDATE_COUNT = 5
    var searchText:String?
    var currentPage:Int = 1
    var selectedIdx:Int = 0
    
    var viewModel = ViewModel.init()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        if let layout = collectionView.collectionViewLayout as? PinterestLayout {
            layout.delegate = self
        }
        collectionView.contentInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        //fetchImageData()
        
        viewModel.reloadData = {
            self.collectionView.reloadData()
        }
        
        viewModel.showLoading = {

            if(self.viewModel.isLodingData) {
                self.loadingIndicator.startAnimating()
                self.collectionView.alpha = 0.0
            } else {
                self.loadingIndicator.stopAnimating()
                self.collectionView.alpha = 1.0
            }
        }
        
        viewModel.fetchAllPhotos(page: 1, per_page: 10)
    }
    
    func fetchNextPage() {
        let nextPage = currentPage + 1
        if(searchText == "" || searchText == nil) {
            viewModel.fetchAllPhotos(page: nextPage, per_page: UPDATE_COUNT)
        } else {
            viewModel.fetchQueryPhotos(query: searchText!, page: nextPage)
        }
    }
    
    func setSearchText(text:String?) {
        if(text != self.searchText) {
            scrollToTop()
            viewModel.imageForCell.removeAll()
            self.currentPage = 1
        }
        if let text = text, text.isEmpty == false {
            self.searchText = text
        } else {
            self.searchText = nil
        }
        self.viewModel.isLodingData = true
        fetchNextPage()
    }
    
    private func scrollToTop() {
        let contentOffset = CGPoint(x: 0, y: -collectionView.safeAreaInsets.top)
        collectionView.setContentOffset(contentOffset, animated: false)
    }
    
    //MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "openPhotoDetail"){
            let popupVC = segue.destination as! PhotoDetailViewController
            popupVC.imageDetails = viewModel.photos!
            popupVC.images = viewModel.imageForCell
            popupVC.curIdx = selectedIdx
        }
    }
}

// MARK: PinterestLayout

extension ViewController: PinterestLayoutDelegate {
    func collectionView(_ collectionView: UICollectionView, heightForPhotoAtIndexPath indexPath: IndexPath) -> CGFloat {
        let image = viewModel.imageForCell[indexPath.item].image
        let height = image.size.height
        
        return height
    }
}

//MARK: Data source

extension ViewController:UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.imageForCell.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "imageCell", for: indexPath) as! ImageCell
        if(indexPath.row > viewModel.imageForCell.count) {
            return cell
        } else {
            let image = viewModel.imageForCell[indexPath.item].image
            cell.imageView.image = image
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedIdx = indexPath.row
        performSegue(withIdentifier: "openPhotoDetail", sender: self)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        let height = collectionView.frame.size.height
        let contentYoffset = collectionView.contentOffset.y
        let distanceFromBottom = collectionView.contentSize.height - contentYoffset
        if distanceFromBottom < height {
            //fetchNextPage()
        }
    }
}

//MARK: - SearchBar Delegate

extension ViewController:UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchBar.text else {
            return
        }
        setSearchText(text: text)
    }
}
