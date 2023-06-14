//
//  AlbumHeaderCollectionViewCell.swift
//  SpotifyAppProject
//
//  Created by Админ on 14.04.2023.
//

import UIKit
import SDWebImage

protocol AlbumCollectionViewCellDelegate: AnyObject {
    func albumCollectionViewCellplayButtonDidTapped(_ header: AlbumCollectionViewCell)
}

final class AlbumCollectionViewCell: UICollectionReusableView {
    
    static let identifire = "AlbumCollectionViewCell"
    weak var delegate: AlbumCollectionViewCellDelegate?
    
    private let imageCoverView: UIImageView = {
        let imageView = UIImageView()
        imageView.center = .zero
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    private let realeseDateLbl: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = .secondaryLabel
        label.font = .systemFont(ofSize: 15, weight: .light)
        return label
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = .secondaryLabel
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        return label
    }()
    
    private let totalTrackLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = .secondaryLabel
        label.font = .systemFont(ofSize: 15, weight: .semibold)
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
    
    public func configure(albumInfo: Album) {
        backgroundColor = .systemBackground
        imageCoverView.sd_setImage(with: URL(string: albumInfo.images.first?.url ?? "----") )
        nameLabel.text = albumInfo.name
        realeseDateLbl.text = "Release date: \(String.formattedDate(string: albumInfo.release_date))"
        totalTrackLabel.text = "Total tracks: \(albumInfo.total_tracks)"
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(imageCoverView)
        addSubview(realeseDateLbl)
        addSubview(nameLabel)
        addSubview(playButton)
        
        playButton.addTarget(self, action: #selector(playButtonDidTapped), for: .touchUpInside)
    }
    
    @objc private func playButtonDidTapped() {
        delegate?.albumCollectionViewCellplayButtonDidTapped(self)
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
        
        realeseDateLbl.frame = CGRect(
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
