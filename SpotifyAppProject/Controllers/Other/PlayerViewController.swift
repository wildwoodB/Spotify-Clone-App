//
//  PlayerViewController.swift
//  SpotifyAppProject
//
//  Created by Nikita Borisov on 20.03.2023.
//

import UIKit
import SDWebImage

protocol PlayerViewControllerDelegate: AnyObject {
    func didTapPlayPause()
    func didTapForward()
    func didTApBacward()
    func didChangeSlider(value: Float)
}

class PlayerViewController: UIViewController {
    
    weak var dataSource: PlayerDataSource?
    weak var delegate: PlayerViewControllerDelegate?
    private let imageCoverView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .systemBlue
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    private let controlsView = PlayerControlsView()

    override func viewDidLoad() {
        super.viewDidLoad()
        controlsView.delegate = self
        view.backgroundColor = .systemBackground
        view.addSubview(imageCoverView)
        view.addSubview(controlsView)
        configureBarItems()
        configure()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        imageCoverView.frame = CGRect(x: 10, y: view.safeAreaInsets.top, width: view.width-20, height: view.width)
        controlsView.frame = CGRect(
            x: 10,
            y: imageCoverView.bottom+10,
            width: view.width-20,
            height: view.height-imageCoverView.height-view.safeAreaInsets.top-view.safeAreaInsets.bottom-15)
    }
    
    private func configure() {
        imageCoverView.sd_setImage(with: dataSource?.imageUrl)
        controlsView.configure(with: PlayerControlsViewModel(
            tittle: dataSource?.songName,
            subtitile: dataSource?.subtitle))
    }
    
    private func configureBarItems() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(didClouseTapped))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(didActionTapped))
        navigationItem.rightBarButtonItem?.tintColor = .systemGray
    }
    
    @objc private func didClouseTapped() {
        dismiss(animated: true)
    }
    
    @objc private func didActionTapped() {
        //actions
    }

}

extension PlayerViewController: PlayerControlsViewDelegate {
    func playerControlsView(_ playerControlsView: PlayerControlsView, didSlideSlider value: Float) {
        delegate?.didChangeSlider(value: value)
    }
    
    func playerControlsViewPlayButtonDidTapped(_ playerControlsView: PlayerControlsView) {
        delegate?.didTapPlayPause()
    }
    
    func playerControlsViewForwardButtonDidTapped(_ playerControlsView: PlayerControlsView) {
        delegate?.didTapForward()
    }
    
    func playerControlsViewBacwardButtonDidTapped(_ playerControlsView: PlayerControlsView) {
        delegate?.didTApBacward()
    }
    
    
}

