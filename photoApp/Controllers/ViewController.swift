//
//  ViewController.swift
//  photoApp
//
//  Created by Kihyun Choi on 2020/11/22.
//  Copyright © 2020 kakaopay. All rights reserved.
//

import UIKit

class ViewController: UIViewController, isAbleToReceiveData
{
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    //MARK:  - Properties
    var searchText:String?
    var requestPage:Int = 1
    var selectedIdx:Int = 0
    
    var viewModel = ViewModel.init()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        initViewModelFunc()
    }
    
    func initViewModelFunc() {
        viewModel.reloadData = {
            self.tableView.reloadData()
        }
        
        viewModel.setCenterSpinner = {
            if(self.viewModel.isLodingData) {
                self.loadingIndicator.startAnimating()
                self.tableView.alpha = 0.0
            } else {
                self.loadingIndicator.stopAnimating()
                self.tableView.alpha = 1.0
            }
        }
        
        viewModel.fetchAllPhotos(page: 1)
        viewModel.setBottomSpinner = {
            if(self.viewModel.isLodingData) {
                self.createBottomSpinner()
            } else {
                self.tableView.tableFooterView = nil
            }
        }
    }
    
    func createBottomSpinner() {
        let footerView = UIView(frame: CGRect(x:0, y:0, width: self.view.frame.size.width, height: 50))
        let spinner = UIActivityIndicatorView()
        footerView.addSubview(spinner)
        spinner.startAnimating()
        self.tableView.tableFooterView = footerView
    }
    
    func fetchNextPage() {
        requestPage = requestPage + 1
        if(searchText == "" || searchText == nil) {
            viewModel.fetchAllPhotos(page: requestPage)
        } else {
            viewModel.fetchQueryPhotos(query: searchText!, page: requestPage)
        }
    }
    
    func setSearchText(text:String?) {
        claerAllData()
        if(text != self.searchText) {
            scrollToTop()
            viewModel.imageForCell.removeAll()
            requestPage = 1
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
        let contentOffset = CGPoint(x: 0, y: -tableView.safeAreaInsets.top)
        tableView.setContentOffset(contentOffset, animated: false)
    }
    
    private func claerAllData() {
        if viewModel.imageForCell.count != 0 {
            viewModel.imageForCell.removeAll()
            self.tableView.reloadData()
        }
    }
    
    func getDataFromModal(data: String) {
        let index = Int(data)
        let indexPath = IndexPath(row: index!, section: 0)
        tableView.scrollToRow(at: indexPath, at: UITableView.ScrollPosition.top, animated: true)
    }
    
    //MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "openPhotoDetail"){
            let popupVC = segue.destination as! PhotoDetailViewController
            popupVC.delegate = self
            popupVC.imageDetails = viewModel.photos
            popupVC.images = viewModel.imageForCell
            popupVC.curIdx = selectedIdx
        }
    }
}

//MARK: Data source

extension ViewController:UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.imageForCell.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ImageCell
        if(indexPath.row >= viewModel.imageForCell.count) {
            return cell
        } else {
            let image = viewModel.imageForCell[indexPath.item].image
            cell.photoView.image = image
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIdx = indexPath.row
        performSegue(withIdentifier: "openPhotoDetail", sender: self)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let position = scrollView.contentOffset.y
        // start to load more images before the scroll reaches end
        if position > (tableView.contentSize.height - scrollView.frame.size.height - 200) {
            if !viewModel.isLodingData {
                fetchNextPage()
            }
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
