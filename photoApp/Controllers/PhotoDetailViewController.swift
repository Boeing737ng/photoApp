//
//  PhotoDetailViewController.swift
//  photoApp
//
//  Created by Kihyun Choi on 2020/11/22.
//  Copyright © 2020 kakaopay. All rights reserved.
//

import UIKit

class PhotoDetailViewController: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var scrollContainerView: UIView!
    @IBOutlet weak var likesCount: UILabel!
    @IBOutlet weak var lblName: UILabel!
    
    var imageDetails:[ImageDetail] = []
    var images:[ImageForCell] = []
    var curIdx:Int = 0
    var delegate: isAbleToReceiveData!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setScrollImageInfo()
        focusOnSelectedPhoto()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        delegate.getDataFromModal(data: String(curIdx))
    }
    
    //MARK: - Utils
    
    func setScrollImageInfo() {
        for i in 0..<images.count{
            let imageView = UIImageView()
            imageView.image = images[i].image
            imageView.contentMode = .scaleAspectFit
            let xPosition = self.scrollContainerView.frame.width * CGFloat(i)
            imageView.frame = CGRect(x: xPosition, y: 0,
            width: self.scrollContainerView.frame.width,
            height: self.scrollContainerView.frame.height)

            scrollView.contentSize.width = self.scrollContainerView.frame.width * CGFloat(1+i)
            scrollView.addSubview(imageView)
        }
    }
    
    func setAdditionalView() {
        self.likesCount.text = "\(String(describing: imageDetails[curIdx].likes!))"
        self.lblName.text = "by \(String(describing: imageDetails[curIdx].user!.username))"
    }
    
    func focusOnSelectedPhoto() {
        let scrollWidth:CGFloat = scrollView.contentSize.width
        let singleSecitonWidth:CGFloat = scrollWidth / CGFloat(images.count)
        let offset:CGFloat = CGFloat(curIdx) * singleSecitonWidth
        scrollView.contentOffset.x = offset
        setAdditionalView()
    }
    
    //MARK:  - Action
    @IBAction func onClosePopup(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}


//MARK:  - ScrollView Delegate
extension PhotoDetailViewController: UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let index:Int = Int(scrollView.contentOffset.x / scrollContainerView.frame.width)
        curIdx = index
        setAdditionalView()
    }
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
    }
}
