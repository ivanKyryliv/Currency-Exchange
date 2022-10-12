//
//  BalanceCollectionViewCell.swift
//  Currency Exchange
//
//  Created by Ivan on 12.10.2022.
//

import UIKit

class BalanceCollectionViewCell: UICollectionViewCell {
    
    //MARK: - Properties
    @IBOutlet private weak var maxWidthConstraint: NSLayoutConstraint!
    @IBOutlet private weak var titleLabel: UILabel!
    
    private var maxWidth: CGFloat? = nil {
        didSet {
            guard let maxWidth = maxWidth else {
                return
            }
            maxWidthConstraint.isActive = true
            maxWidthConstraint.constant = maxWidth
        }
    }
    
    //MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        
        contentView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            contentView.leftAnchor.constraint(equalTo: leftAnchor),
            contentView.rightAnchor.constraint(equalTo: rightAnchor),
            contentView.topAnchor.constraint(equalTo: topAnchor),
            contentView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    func configure(title: String, maxWidth: CGFloat) {
        titleLabel.text = title
        self.maxWidth = maxWidth
    }
}
