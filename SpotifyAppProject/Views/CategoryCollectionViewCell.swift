//
//  GenreCollectionViewCell.swift
//  SpotifyAppProject
//
//  Created by Nikita Borisov on 24.04.2023.
//

import UIKit
import SDWebImage


class CategoryCollectionViewCell: UICollectionViewCell {
    
    static let identifire = "GenreCollectionViewCell"
    
    private let imageView: UIImageView = {
        let image = UIImageView()
        image.layer.cornerRadius = 10
        image.contentMode = .scaleAspectFill
        image.tintColor = .white
        image.image = UIImage(systemName: "music.quarternote.3", withConfiguration: UIImage.SymbolConfiguration(
            pointSize: 50, weight: .regular))
        return image
    }()
    
    private let label: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        return label
    }()
    
    private let colors: [UIColor] = [
        .systemMint,
        .systemPink,
        .systemBlue,
        .systemTeal,
        .systemBrown,
        .systemIndigo,
        .systemOrange,
        .systemPurple,
        .systemYellow
    ]
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.layer.cornerRadius = 10
        contentView.layer.masksToBounds = true
        
        imageView.layer.shadowOpacity = 1
        imageView.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5).cgColor
        imageView.layer.shadowOffset = CGSize(width: 10, height: 10)
        imageView.layer.shadowRadius = 5
        imageView.layer.cornerRadius = 10
        imageView.layer.masksToBounds = false
        contentView.addSubview(imageView)
        contentView.addSubview(label)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        label.text = nil
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        label.frame = CGRect(x: 10, y: contentView.height/1.8, width: contentView.width-20, height: contentView.height/2)
        imageView.frame = CGRect(x: contentView.width/2.4, y: 0, width: contentView.width/1.7, height: contentView.height/1.7)
        
    }
    
    func configure(with title: CategorySearchViewCellModel) {
        label.text = "\(title.name)"
        contentView.backgroundColor = colors.randomElement()
        imageView.sd_setImage(with: title.icons )
        
    }
}
