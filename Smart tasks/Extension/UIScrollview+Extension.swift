//
//  UIScrollview+Extension.swift
//  Smart tasks
//
//  Created by Umair on 22/06/2025.
//
import UIKit

public extension UIScrollView {
    func showEmptyListView(imageName: String, message: String) {
        let rect = CGRect(origin: CGPoint(x: 0,y :0), size: CGSize(width: self.bounds.size.width, height: self.bounds.size.height))
        let messageLabel = UILabel(frame: rect)
        messageLabel.text = message
        messageLabel.textColor = AppColor.white.color
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
        messageLabel.font = AppFont.bold.getFont(.h1)
        messageLabel.sizeToFit()
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let imageView = UIImageView()
            imageView.image = UIImage(named: imageName)
            imageView.contentMode = .scaleAspectFit
            imageView.translatesAutoresizingMaskIntoConstraints = false

            let containerView = UIView()
            containerView.addSubview(imageView)
            containerView.addSubview(messageLabel)

            NSLayoutConstraint.activate([
                imageView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
                imageView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
                imageView.widthAnchor.constraint(equalToConstant: 150),
                imageView.heightAnchor.constraint(equalToConstant: 150),
                messageLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 20),
                messageLabel.centerXAnchor.constraint(equalTo: containerView.centerXAnchor)
            ])

        if let `self` = self as? UITableView {
            self.backgroundView = containerView
            self.separatorStyle = .none
        } else if let `self` = self as? UICollectionView {
            self.backgroundView = containerView
        }
    }
    
    func restore() {
        if let `self` = self as? UITableView {
            self.backgroundView = nil
        }
    }
}
