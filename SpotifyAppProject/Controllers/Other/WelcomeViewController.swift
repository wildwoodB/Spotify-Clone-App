//
//  WelcomeViewController.swift
//  SpotifyAppProject
//
//  Created by Nikita Borisov on 20.03.2023.
//

import UIKit

class WelcomeViewController: UIViewController {
    
    private let signItButton : UIButton = {
        let button = UIButton()
        button.backgroundColor = .white
        button.setTitle("Sign it with Spotify", for: .normal)
        button.setTitleColor(.blue, for: .normal)
        button.layer.cornerRadius = 10
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Spotify"
        view.backgroundColor = .systemGreen
        view.addSubview(signItButton)
        signItButton.addTarget(self, action: #selector(didTapSingIn), for: .touchUpInside)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        signItButton.frame = CGRect(x: 20,
                                    y: view.height-50-view.safeAreaInsets.bottom,
                                    width: view.width-40,
                                    height: 50)
    }
    
    @objc func didTapSingIn() {
        
        let vc = AuthViewController()
        vc.completionHendler = { [weak self] success in
            DispatchQueue.main.async {
                self?.handleSignIn(success: success)
            }
        }
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
    }
    
    private func handleSignIn(success: Bool) {
        // фнкция входа в систему в случае еслм мы получаем фолс мы показываем алерт
        guard success else {
            let alert = UIAlertController(title: "Oops..", message: "Something wrong with your login..", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel))
            present(alert, animated: true)
            return
        }
        let mainAppTabBarVc = TabBarViewController()
        mainAppTabBarVc.modalPresentationStyle = .fullScreen
        present(mainAppTabBarVc, animated: true)
    }
    
}
