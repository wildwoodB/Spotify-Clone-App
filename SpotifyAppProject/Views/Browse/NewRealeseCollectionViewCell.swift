//
//  NewRealeseCollectionViewCell.swift
//  SpotifyAppProject
//
//  Created by Админ on 04.04.2023.
//

import UIKit
import SDWebImage

class NewRealeseCollectionViewCell: UICollectionViewCell {
    static let identifire = "NewRealeseCollectionViewCell"
    
    private let albumCoverImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "photo")
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 3
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private let albumNameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        return label
    }()
    
    private let numberOfTracksLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .thin)
        return label
    }()
    
    private let artistNameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 18, weight: .light)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .secondarySystemBackground
        contentView.layer.cornerRadius = 10
        contentView.addSubview(albumCoverImageView)
        contentView.addSubview(albumNameLabel)
        contentView.addSubview(numberOfTracksLabel)
        contentView.addSubview(artistNameLabel)
        contentView.clipsToBounds = true
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let imageSize: CGFloat = contentView.height-10
        let albumLAbelSize = albumNameLabel.sizeThatFits(CGSize(
            width: contentView.width-imageSize-10, height: contentView.height-10))
        
        numberOfTracksLabel.sizeToFit()
        artistNameLabel.sizeToFit()
        
        albumCoverImageView.frame = CGRect(x: 5, y: 5, width: imageSize, height: imageSize)
        
        numberOfTracksLabel.frame = CGRect(
            x: albumCoverImageView.right+10,
            y: contentView.bottom-30,
            width: numberOfTracksLabel.width,
            height: 30)
        
        let albumLabelHeight = min(55, albumLAbelSize.height)
        
        albumNameLabel.frame = CGRect(
            x: albumCoverImageView.right+10 ,
            y: 5,
            width: albumLAbelSize.width ,
            height: albumLabelHeight)
        
        artistNameLabel.frame = CGRect(
            x: albumCoverImageView.right+10 ,
            y: albumNameLabel.bottom,
            width: contentView.width - albumCoverImageView.right-10 ,
            height: 30)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        albumNameLabel.text = nil
        numberOfTracksLabel.text = nil
        artistNameLabel.text = nil
        albumCoverImageView.image = nil
    }
    
    func configure(with viewModel: NewRealeasesCellViewModel) {
        albumNameLabel.text = viewModel.name
        numberOfTracksLabel.text = String(viewModel.numberOfTracks)
        artistNameLabel.text = viewModel.artistName
        albumCoverImageView.sd_setImage(with: viewModel.artworkURL)
    }
}


