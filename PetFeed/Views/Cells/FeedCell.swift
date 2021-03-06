//
//  FeedCell.swift
//  PetFeed
//
//  Created by 이창현 on 2018. 8. 7..
//  Copyright © 2018년 이창현. All rights reserved.
//

import UIKit
import ImageSlideshow
import SDWebImage

class FeedCell: UICollectionViewCell {
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var contentLabel: UILabel!
    
    @IBOutlet weak var loveLabel: UILabel!
    @IBOutlet weak var commentLabel: UILabel!
    
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var imageShow: ImageSlideshow!
    
    var superViewController:UIViewController?
    
    //TODO: Make these values to board class, and make intialize function
    
    var board:Board?
    @IBAction func moreButtonPressed(_ sender: Any) {
        self.moreButtonHandler()
    }
    
    @IBOutlet weak var likeButton: UIButton!
    
    func initalize(withBoard data:Board) {
        self.board = data
        
        if let board = self.board {
            nameLabel.text = board.writer_nickname
            let url = board.writer_profile.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!

            profileImageView.sd_setImage(with: URL(string: "\(API.base_url)/\(url)"))
            print(board.writer_nickname,": ",board.writer_profile)
            
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy.MM.dd"
            let result = formatter.string(from: board.date)
            dateLabel.text = result
            
            contentLabel.text = board.contents
            
            loveLabel.text = "+\(board.likes.count)"
            
            if board.likes.contains(API.currentUser.id ) {
                likeButton.setImage(UIImage(named: "favorite"), for: .normal)
            } else{
                //print("likes: ",board.likes,"and mine : ",API.currentUser.id)
                likeButton.setImage(UIImage(named: "favorite_empty"), for: .normal)
            }
            
            
            commentLabel.text = "+\(board.comments.count)"
            
            if (board.low_pictures.count > 0) {
                let array:[SDWebImageSource] = board.low_pictures.map{SDWebImageSource(urlString: "\(API.base_url)/\($0)")!}
                self.setImagesWith(source: array)
            }
        }
    }
    
    
    
    @IBOutlet weak var commentButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        imageShow.pageIndicatorPosition = .init(horizontal: .center, vertical: .customUnder(padding: -30))
        imageShow.contentScaleMode = UIViewContentMode.scaleAspectFill
        
        let pageControl = UIPageControl()
        pageControl.currentPageIndicatorTintColor = UIColor.lightGray
        pageControl.pageIndicatorTintColor = UIColor.black
        imageShow.pageIndicator = pageControl
        
        imageShow.activityIndicator = DefaultActivityIndicator()
        imageShow.currentPageChanged = { page in
            //"\(API.base_url)/\()"
        }
        
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(FeedCell.didTap))
        imageShow.addGestureRecognizer(recognizer)
    }
    
    @objc func didTap() {
        if let s = superViewController {
            let vc = UIStoryboard(name: "Backdrop", bundle: nil).instantiateViewController(withIdentifier: "DetailVC") as! DetailVC
            let superCell = superview
            
            vc.board = board
            vc.temp_images = imageShow.images
            
            s.navigationController?.pushViewController(vc, animated: true)
//            let fullScreenController = imageShow.presentFullScreenController(from: s)
//            // set the activity indicator for full screen controller (skipping the line will show no activity indicator)
//            fullScreenController.slideshow.activityIndicator = DefaultActivityIndicator(style: .white, color: nil)
        }
        
    }
    
    func setImagesWith(source: [SDWebImageSource]) {
        imageShow.setImageInputs(source)
        let height = imageShow.slideshowItems.map{$0.frame.height}.sorted{ $0 > $1 }[0]
        heightConstraint.constant = height
    }
    
    
    var commentButtonHandler:(()-> Void)!
    var likeButtonHandler:(()->Void)!
    var moreButtonHandler:(()->Void)!

    @IBAction func commentButtonPressed(_ sender: Any) {
        self.commentButtonHandler()
    }
    
    @IBAction func likeButtonPressed(_ sender: Any) {
        self.likeButtonHandler()
    }
    
    
    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        setNeedsLayout()
        layoutIfNeeded()
        
        let size = contentView.systemLayoutSizeFitting(layoutAttributes.size)
        
        var frame = layoutAttributes.frame
        frame.size.height = ceil(size.height)
        layoutAttributes.frame = frame
        
        return layoutAttributes
        
    }
}

