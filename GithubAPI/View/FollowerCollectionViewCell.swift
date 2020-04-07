//
//  FollowerCollectionViewCell.swift
//  GithubAPI
//
//  Created by sania zafar on 06/04/2020.
//  Copyright © 2020 sania zafar. All rights reserved.
//

import UIKit

class FollowerCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
    }
    
    func configureCell(with follower: Follower) {
        guard let url = URL(string: follower.avatarUrl) else {
            
            return
        }
        imageView?.load(url: url)
        nameLabel.text = follower.name
    }
    
}

extension UIImageView {
    func load(url: URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                        self?.applyCornerRadiusOnImageBounds(radius: 6.0)
                    }
                }
            }
        }
    }
    
    func applyCornerRadiusOnImageBounds(radius: CGFloat) {
        guard let image = self.image else {
            
            return
        }
        //calculate drawingRect
        if self.bounds.size.height > 0.0 {
            let boundsScale = self.bounds.size.width / self.bounds.size.height
            let imageScale = image.size.width / image.size.height
            var drawingRect: CGRect = self.bounds
            if boundsScale > imageScale {
                drawingRect.size.width =  drawingRect.size.height * imageScale
                drawingRect.origin.x = (self.bounds.size.width - drawingRect.size.width) / 2
            } else {
                drawingRect.size.height = drawingRect.size.width / imageScale
                drawingRect.origin.y = (self.bounds.size.height - drawingRect.size.height) / 2
            }
            let path = UIBezierPath(roundedRect: drawingRect, cornerRadius: radius)
            let mask = CAShapeLayer()
            mask.path = path.cgPath
            self.layer.mask = mask
        }
    }
    
}
