//
//  PlaylistCollectionViewCell.swift
//  SpotifyAppProject
//
//  Created by Nikita Borisov on 14.04.2023.
//

import UIKit
import SDWebImage

protocol PlaylistCollectionViewCellDelegate: AnyObject {
    func playlistCollectionViewCellplayButtonDidTapped(_ header: PlaylistCollectionViewCell)
}

class PlaylistCollectionViewCell: UICollectionReusableView {
    
    static let identifire = "PlaylistCollectionViewCell"
    
    weak var delegate: PlaylistCollectionViewCellDelegate?
    
    private let imageCoverView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "photo")
        //imageView.center = .zero
        imageView.contentMode = .scaleAspectFill
        //imageView.layer.masksToBounds = true
        return imageView
        
    }()
    
    private let descLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = .secondaryLabel
        label.font = .systemFont(ofSize: 18, weight: .light)
        return label
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = .secondaryLabel
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        return label
    }()
    
    private let playButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .systemGreen
        button.layer.cornerRadius = 25
        let image = UIImage(systemName: "play.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 35, weight: .regular))
        button.setImage(image, for: .normal)
        button.layer.masksToBounds = true
        button.tintColor = .white
        return button
    }()
    
    public func configure(playlistInfo: Playlist) {
        backgroundColor = .systemBackground
        imageCoverView.sd_setImage(with: URL(string: playlistInfo.images.first?.url.description ?? "---") )
        descLabel.text = playlistInfo.description
        nameLabel.text = playlistInfo.name
        //backgroundColor = playlistInfo.
        
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(imageCoverView)
        addSubview(descLabel)
        addSubview(nameLabel)
        addSubview(playButton)
        
        playButton.addTarget(self, action: #selector(playButtonDidTapped), for: .touchUpInside)
    }
    
    @objc private func playButtonDidTapped() {
        delegate?.playlistCollectionViewCellplayButtonDidTapped(self)
        
        playButton.setImage(UIImage(systemName: "pause.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 35, weight: .regular)), for: .normal)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let imageSize: CGFloat = height/1.8
        imageCoverView.frame = CGRect(x: (width-imageSize)/2, y: 20, width: imageSize, height: imageSize)
        
        nameLabel.frame = CGRect(
            x: 10,
            y: imageCoverView.bottom+5,
            width: width-20,
            height: 44)
        
        descLabel.frame = CGRect(
            x: 10,
            y: nameLabel.bottom,
            width: width-20,
            height: 44)
        
        playButton.frame = CGRect(
            x: width-70,
            y: height-70,
            width: 50,
            height: 50)
    }
        
}
