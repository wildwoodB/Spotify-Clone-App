//
//  PlayerControlsView.swift
//  SpotifyAppProject
//
//  Created by Админ on 09.05.2023.
//

import Foundation
import UIKit

protocol PlayerControlsViewDelegate: AnyObject {
    func playerControlsViewPlayButtonDidTapped(_ playerControlsView: PlayerControlsView)
    func playerControlsViewForwardButtonDidTapped(_ playerControlsView: PlayerControlsView)
    func playerControlsViewBacwardButtonDidTapped(_ playerControlsView: PlayerControlsView)
    func playerControlsView(_ playerControlsView: PlayerControlsView, didSlideSlider value: Float)
}

struct PlayerControlsViewModel {
    let tittle: String?
    let subtitile: String?
}

final class PlayerControlsView: UIView {
    
    var isPlayed = true
    
    weak var delegate: PlayerControlsViewDelegate?
    
    private let volumeSlider: UISlider = {
        let slider = UISlider()
        slider.value = 0.0
        return slider
    }()
    
    private let nameLbl: UILabel = {
        let label = UILabel()
        label.text = "wooooooow"
        label.numberOfLines = 1
        label.font = .systemFont(ofSize: 22, weight: .semibold)
        return label
    }()
    
    private let descriptionLbl: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.text = "wooooooow"
        label.font = .systemFont(ofSize: 18, weight: .regular)
        label.tintColor = .secondaryLabel
        return label
    }()
    
    private let pauseButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "pause.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 35, weight: .regular)), for: .normal)
        return button
    }()
    
    private let forwardButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "forward.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 35, weight: .regular)), for: .normal)
        return button
    }()
    
    private let backwardButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "backward.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 35, weight: .regular)), for: .normal)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
        volumeSlider.addTarget(self, action: #selector(didSlideSlider(_:)), for: .valueChanged)
    }
    
    private  func configureUI() {
        [volumeSlider,nameLbl,descriptionLbl,pauseButton,forwardButton,backwardButton].forEach {
            addSubview($0)
            clipsToBounds = true
            
            pauseButton.addTarget(self, action: #selector(didTapPlayPause), for: .touchUpInside)
            forwardButton.addTarget(self, action: #selector(didTapNext), for: .touchUpInside)
            backwardButton.addTarget(self, action: #selector(didTapBack), for: .touchUpInside)
            volumeSlider.addTarget(self, action: #selector(valueChanged), for: .valueChanged)
        }
    }
    
    @objc func didSlideSlider(_ slider: UISlider) {
        let value = slider.value
        delegate?.playerControlsView(self, didSlideSlider: value)
    }
    
    @objc func didTapPlayPause() {
        self.isPlayed = !isPlayed
        delegate?.playerControlsViewPlayButtonDidTapped(self)
        
        let pause = UIImage(systemName: "pause.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 35, weight: .regular))
        let play = UIImage(systemName: "play.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 35, weight: .regular))
        
        pauseButton.setImage(isPlayed ? pause : play, for: .normal)
    }
    
    @objc func valueChanged() {
        delegate?.playerControlsView(self, didSlideSlider: volumeSlider.value)
    }
    
    @objc func didTapNext() {
        delegate?.playerControlsViewForwardButtonDidTapped(self)
    }
    
    @objc func didTapBack() {
        delegate?.playerControlsViewBacwardButtonDidTapped(self)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        nameLbl.frame = CGRect(x: 0, y: 0, width: width, height: 50)
        descriptionLbl.frame = CGRect(x: 0, y: nameLbl.bottom+10, width: width, height: 50)
        
        volumeSlider.frame = CGRect(x: 10, y: descriptionLbl.bottom+20, width: width-20, height: 44)
        
        let buttonSize: CGFloat = 60
        pauseButton.frame = CGRect(x: (width-buttonSize)/2, y: volumeSlider.bottom+30, width: buttonSize, height: buttonSize)
        forwardButton.frame = CGRect(x: pauseButton.right+40, y: volumeSlider.bottom+30, width: buttonSize, height: buttonSize)
        backwardButton.frame = CGRect(x: pauseButton.left-40-buttonSize, y: volumeSlider.bottom+30, width: buttonSize, height: buttonSize)
    }
    
    func configure(with model: PlayerControlsViewModel) {
        nameLbl.text = model.tittle
        descriptionLbl.text = model.subtitile
    }
    
    
}
