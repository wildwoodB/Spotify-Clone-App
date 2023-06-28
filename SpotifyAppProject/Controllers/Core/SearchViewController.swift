//
//  SearchViewController.swift
//  SpotifyAppProject
//
//  Created by Nikita Borisov on 20.03.2023.
//

import UIKit
import SafariServices

class SearchViewController: UIViewController, UISearchResultsUpdating, UISearchBarDelegate {
    
    private var categoriesResults = [CategorySearchViewCellModel]()
    
    let searchController: UISearchController = {
        let vc = UISearchController(searchResultsController: SearchResultsViewController())
        vc.searchBar.placeholder = "Song, Artist, Albums"
        vc.searchBar.searchBarStyle = .minimal
        vc.definesPresentationContext = true
        return vc
    }()
    
    private let collectionView: UICollectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: UICollectionViewCompositionalLayout(
            sectionProvider: { _, _ in
                let item = NSCollectionLayoutItem(
                    layoutSize: NSCollectionLayoutSize(
                        widthDimension: .fractionalWidth(1),
                        heightDimension: .fractionalHeight(1)))
                
                item.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 7, bottom: 2, trailing: 7)
                
                let group = NSCollectionLayoutGroup.horizontal(
                    layoutSize: NSCollectionLayoutSize(
                        widthDimension: .fractionalWidth(1),
                        heightDimension: .absolute(150)),
                    subitem: item,
                    count: 2)
                
                group.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 0, bottom: 5, trailing: 0)
                
                return NSCollectionLayoutSection(group: group)
            }))
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        navigationItem.searchController = searchController
        
        view.addSubview(collectionView)
        collectionView.register(CategoryCollectionViewCell.self, forCellWithReuseIdentifier: CategoryCollectionViewCell.identifire)
        collectionView.delegate = self
        collectionView.dataSource = self
        
        feychData()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.frame = view.bounds
    }
    
    //функция протокола UISearchResultsUpdating
    func updateSearchResults(for searchController: UISearchController) {
        //здесь мы проверяем не пустой ли наш запрос в серчКонтроллере
        
    }
    
    //дабы не потратить дневной лимит запросов апи мы переместили функцию апиКоллера в функцию срабатывающую после нажатия на кнопку поиск на клавиатуре.
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let resultsController = searchController.searchResultsController as? SearchResultsViewController,
              let query = searchBar.text,
              !query.trimmingCharacters(in: .whitespaces).isEmpty else {
            return
        }
        
        resultsController.delegate = self
        
        // здесь мы делаем поисковый запрос с каждым новым символом в поисковой строке.
        APICaller.shared.search(with: query ) { result in
            DispatchQueue.main.async {
                switch result {
                case .failure(let error):
                    print(error)
                case .success(let result):
                    resultsController.update(with: result)
                }
            }
        }
    }
    
    private func feychData() {
        APICaller.shared.getCategories { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let model):
                    self?.categoriesResults = model.compactMap({
                        return CategorySearchViewCellModel(
                            name: $0.name,
                            id: $0.id,
                            icons: URL(string: $0.icons.first?.url ?? "------"))
                    })
                case .failure(let error):
                    print(error)
                }
                self?.collectionView.reloadData()
            }
        }
    }
    
}

extension SearchViewController: SearchResultsViewControllerDelegate {
    func didTapResult(_ result: SearchResult) {
        
        switch result {
        case .artist(let model):
            guard let url = URL(string: model.external_urls["spotify"] ?? "") else {
                return
            }
            let vc = SFSafariViewController(url: url)
            present(vc, animated: true)
        case .track(let model):
            PlaybackPresenter.shared.startPlayback(from: self, track: model)
        case .playlist(let model):
            let vc = PlaylistViewController(playlist: model)
            navigationController?.pushViewController(vc, animated: true)
            navigationItem.largeTitleDisplayMode = .never
        case .album(let model):
            let vc = AlbumViewController(album: model)
            navigationController?.pushViewController(vc, animated: true)
            navigationItem.largeTitleDisplayMode = .never
        }
    }
}

extension SearchViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categoriesResults.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let category = categoriesResults[indexPath.row]
        let vc = CategoryViewController(categoryId: category)
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryCollectionViewCell.identifire, for: indexPath) as? CategoryCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.configure(with: categoriesResults[indexPath.item])
        return cell
    }
}
