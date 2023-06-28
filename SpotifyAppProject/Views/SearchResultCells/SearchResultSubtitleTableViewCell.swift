//
//  SearchResultSubtitleTableViewCell.swift
//  SpotifyAppProject
//
//  Created by Nikita Borisov on 03.05.2023.
//

import UIKit
import SDWebImage

class SearchResultSubtitleTableViewCell: UITableViewCell {
    
    static let identifire = "SearchResultSubtitleTableViewCell"
    
    private let label: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        return label
    }()
    
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .secondaryLabel
        label.numberOfLines = 1
        return label
    }()
    
    private let imageCover: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        return image
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(label)
        contentView.addSubview(imageCover)
        contentView.addSubview(subtitleLabel)
        contentView.clipsToBounds = true
        //добавляем стрелочку в ячейку таблицы
        accessoryType = .disclosureIndicator
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let imageSize: CGFloat = contentView.height-10
        imageCover.frame = CGRect(
            x: 10,
            y: 5,
            width: imageSize,
            height: imageSize)
        
        let labelHeight = contentView.height/2
        label.frame = CGRect(
            x: imageCover.right+10,
            y: 0,
            width: contentView.width-imageCover.right-15,
            height: labelHeight)
        subtitleLabel.frame = CGRect(
            x: imageCover.right+10,
            y: label.bottom,
            width: contentView.width-imageCover.right-15,
            height: labelHeight)
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageCover.image = nil
        label.text = nil
        subtitleLabel.text = nil
    }
    
    public func configure(_ with: SearchResultSubtitleTableViewCellViewModel) {
        label.text = with.title
        imageCover.sd_setImage(with: URL(string: with.imageUrl))
        subtitleLabel.text = with.subtitle
        
    }
}
