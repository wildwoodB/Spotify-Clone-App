//
//  AlbumTrackCollectionViewCell.swift
//  SpotifyAppProject
//
//  Created by Админ on 20.04.2023.
//

import UIKit
import SDWebImage

class AlbumTrackCollectionViewCell: UICollectionViewCell {
    
    static let identifire = "AlbumTrackCollectionViewCell"
    
    private let trackNameLbl: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        return label
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
        
        let albumLabelHeight = min(55, albumLAbelSize.height)
        
        trackNameLbl.frame = CGRect(
            x: 10 ,
            y: 5,
            width: albumLAbelSize.width ,
            height: albumLabelHeight)
        
        artistNameLbl.frame = CGRect(
            x: 10 ,
            y: trackNameLbl.bottom,
            width: contentView.width-10 ,
            height: 30)
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        trackNameLbl.text = nil
        artistNameLbl.text = nil
       
    }
    
    func configure(with viewModel: AlbumCollectionViewCellViewModel) {
        artistNameLbl.text = viewModel.artistName
        trackNameLbl.text = viewModel.name
    }
}
