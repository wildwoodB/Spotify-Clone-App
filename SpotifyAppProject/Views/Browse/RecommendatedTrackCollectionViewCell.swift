//
//  RecommendatedTrackCollectionViewCell.swift
//  SpotifyAppProject
//
//  Created by Админ on 04.04.2023.
//

import UIKit
import SDWebImage

class RecommendatedTrackCollectionViewCell: UICollectionViewCell {
    
    static let identifire = "RecommendatedTrackCollectionViewCell"
    
    private let trackNameLbl: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        return label
    }()
    
    private let trackCoverImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "photo")
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 3
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private let artistNameLbl: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 16, weight: .thin)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .secondarySystemBackground
        contentView.layer.cornerRadius = 10
        contentView.addSubview(trackCoverImage)
        contentView.addSubview(trackNameLbl)
        contentView.addSubview(artistNameLbl)
        contentView.clipsToBounds = true
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let imageSize: CGFloat = contentView.height-10
        let albumLAbelSize = trackNameLbl.sizeThatFits(CGSize(
            width: contentView.width-imageSize-10, height: contentView.height-10))
        
        artistNameLbl.sizeToFit()
        
        trackCoverImage.frame = CGRect(x: 5, y: 5, width: imageSize, height: imageSize)
        
        let albumLabelHeight = min(55, albumLAbelSize.height)
        
        trackNameLbl.frame = CGRect(
            x: trackCoverImage.right+10 ,
            y: 5,
            width: albumLAbelSize.width ,
            height: albumLabelHeight)
        
        artistNameLbl.frame = CGRect(
            x: trackCoverImage.right+10 ,
            y: trackNameLbl.bottom,
            width: contentView.width - trackCoverImage.right-10 ,
            height: 30)
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        trackNameLbl.text = nil
        artistNameLbl.text = nil
        trackCoverImage.image = nil
       
    }
    
    func configure(with viewModel: RecommendedTrackCellViewModel) {
        artistNameLbl.text = viewModel.artistName
        trackNameLbl.text = viewModel.name
        trackCoverImage.sd_setImage(with: viewModel.artworkURL)
        
    }
}
