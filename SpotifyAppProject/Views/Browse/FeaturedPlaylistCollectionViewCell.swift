//
//  FeaturedPlaylistCollectionViewCell.swift
//  SpotifyAppProject
//
//  Created by Админ on 04.04.2023.
//
import UIKit
import SDWebImage

class FeaturedPlaylistCollectionViewCell: UICollectionViewCell {
    
    static let identifire = "FeaturedPlaylistCollectionViewCell"
    
    private let playlistNameLbl: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        return label
    }()
    
    private let playlistCoverImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "photo")
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 3
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private let creatorNameLbl: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 16, weight: .thin)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .clear
        //contentView.layer.cornerRadius = 10
        contentView.addSubview(playlistCoverImage)
        contentView.addSubview(playlistNameLbl)
        contentView.addSubview(creatorNameLbl)
        contentView.clipsToBounds = true
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        playlistCoverImage.frame = CGRect(
            x: 20,
            y: 5,
            width: contentView.height-45,
            height: contentView.bottom-55)
        
        creatorNameLbl.sizeToFit()
        playlistNameLbl.sizeToFit()
        
        creatorNameLbl.frame = CGRect(
            x: 20,
            y: playlistCoverImage.bottom+25,
            width: playlistCoverImage.width,
            height: 20)
        
        playlistNameLbl.frame = CGRect(
            x: 20,
            y: playlistCoverImage.bottom+5,
            width: playlistCoverImage.width,
            height: 25)
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        creatorNameLbl.text = nil
        playlistNameLbl.text = nil
        playlistCoverImage.image = nil
       
    }
    
    func configure(with viewModel: FeaturedPlaylistCellViewModel) {
        creatorNameLbl.text = viewModel.creatorName
        playlistNameLbl.text = viewModel.name
        playlistCoverImage.sd_setImage(with: viewModel.artworkURL)
        
    }
}



