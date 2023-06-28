//
//  ViewController.swift
//  SpotifyAppProject
//
//  Created by Nikita Borisov on 20.03.2023.
//

import UIKit

//MARK: - Browse Enum + Titile Strings
enum BrowseSectionType {
    case newRealeses(viewModels: [NewRealeasesCellViewModel])
    case feturedPlaylists(viewModels: [FeaturedPlaylistCellViewModel])
    case recommendedTracks(viewModels: [RecommendedTrackCellViewModel])
    
    var title: String {
        switch self {
        case .newRealeses:
            return "New Realeses Album:"
        case .feturedPlaylists:
            return "Fetured Playlists:"
        case .recommendedTracks:
            return "Recommended Tracks:"
        }
    }
}

class HomeViewController: UIViewController {
    //MARK: - collectionView createSection func
    private var collectionView: UICollectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: UICollectionViewCompositionalLayout { sectionIndex, _ -> NSCollectionLayoutSection? in
            
        return HomeViewController.createSectionLayout(section: sectionIndex)
    })
    
    private let spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView()
        spinner.tintColor = .label
        spinner.hidesWhenStopped = true
        return spinner
    }()
    
    private var sections = [BrowseSectionType]()
    
    private var newAlbum: [Album] = []
    private var playlist: [Playlist] = []
    private var track: [AudioTrack] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "gear"),
            style: .done,
            target: self,
            action: #selector(buttonDidTapped))
        
        configureCollectionView()
        view.addSubview(spinner)
        fetchData()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.frame = view.bounds
    }
    //MARK: - cinfigure CollectionView
    private func configureCollectionView() {
        view.addSubview(collectionView)
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.register(NewRealeseCollectionViewCell.self, forCellWithReuseIdentifier: NewRealeseCollectionViewCell.identifire)
        collectionView.register(FeaturedPlaylistCollectionViewCell.self,forCellWithReuseIdentifier: FeaturedPlaylistCollectionViewCell.identifire)
        collectionView.register(RecommendatedTrackCollectionViewCell.self,forCellWithReuseIdentifier: RecommendatedTrackCollectionViewCell.identifire)
        collectionView.register(TitleHeaderCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: TitleHeaderCollectionReusableView.identifire)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .systemBackground
    }
    //MARK: - create Section Layout
    private static func createSectionLayout(section: Int) -> NSCollectionLayoutSection {
        let supplementaryView = [
            
            NSCollectionLayoutBoundarySupplementaryItem(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1),
                    heightDimension: .absolute(50)),
                elementKind: UICollectionView.elementKindSectionHeader,
                alignment: .top)
            
        ]
        
        switch section {
        case 0:
            //здесь мы создаем группу(секцию) с размерностью
            //Item
            let item = NSCollectionLayoutItem(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .fractionalHeight(1.0)))
            
            item.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)
            //Vertical group in horizontal grop
            let verticalGroup = NSCollectionLayoutGroup.vertical(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .absolute(360)),
                subitem: item,
                count: 3)
            
            let horizontalGroup = NSCollectionLayoutGroup.horizontal(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(0.8),
                    heightDimension: .absolute(360)),
                subitem: verticalGroup,
                count: 1)
            //Section
            let section = NSCollectionLayoutSection(group: horizontalGroup)
            section.orthogonalScrollingBehavior = .groupPaging
            section.boundarySupplementaryItems = supplementaryView
            return section
        case 1:
            let item = NSCollectionLayoutItem(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .absolute(200),
                    heightDimension: .absolute(200)))
            
            item.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 2, bottom: 2, trailing: 2)
            
            let verticalGroup = NSCollectionLayoutGroup.vertical(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .absolute(200),
                    heightDimension: .absolute(400)),
                subitem: item,
                count: 2)
            
            let horizontalGroup = NSCollectionLayoutGroup.horizontal(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .absolute(200),
                    heightDimension: .absolute(400)),
                subitem: verticalGroup ,
                count: 1)
            
            let section = NSCollectionLayoutSection(group: horizontalGroup)
            section.boundarySupplementaryItems = supplementaryView
            section.orthogonalScrollingBehavior = .groupPaging
            return section
        case 2:
            let item = NSCollectionLayoutItem(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .fractionalHeight(1.0)))
            
            item.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)
            
            let group = NSCollectionLayoutGroup.vertical(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .absolute(80)),
                subitem: item,
                count: 1)
            
            let section = NSCollectionLayoutSection(group: group)
            section.boundarySupplementaryItems = supplementaryView
            return section
            
        default:
            let item = NSCollectionLayoutItem(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .fractionalHeight(1.0)))
            
            item.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)
            
            let group = NSCollectionLayoutGroup.vertical(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .absolute(120)),
                subitem: item,
                count: 1)
            
            let section = NSCollectionLayoutSection(group: group)
            section.boundarySupplementaryItems = supplementaryView
            return section
        }
    }
    //MARK: - Data Fetching Methods
    private func fetchData() {
        // создаем асинхронную группу
        let group = DispatchGroup()
        group.enter()
        group.enter()
        group.enter()
        
        var newRealeses: NewReleasesResponse?
        var futuredPlaylist: FuturedPlaylistResponse?
        var recommendations: RecomendationsResponse?
        
        APICaller.shared.getNewReleases { result in
            defer {
                group.leave()
            }
            switch result {
            case .success(let model):
                newRealeses = model
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        
        APICaller.shared.getAllFuturedPlaylist { result in
            defer {
                group.leave()
            }
            switch result {
            case .success(let model):
                futuredPlaylist = model
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        
        APICaller.shared.getRecomendesGenres { result in
            switch result {
            case .failure(let error):
                print(error.localizedDescription)
            case .success(let model):
                let genres = model.genres
                var seeds = Set<String>()
                while seeds.count < 5 {
                    if let random = genres.randomElement() {
                        seeds.insert(random)
                    }
                }
                
                APICaller.shared.getRecomendations(genres: seeds) { recommendedResult in
                    defer {
                        group.leave()
                    }
                    switch recommendedResult {
                    case .failure(let error):
                        print(error.localizedDescription)
                    case .success(let model):
                        recommendations = model
                    }
                }
            }
        }
        // функция груповой асинхронности, с конфигурацией
        group.notify(queue: .main) {
            guard let newAlbums = newRealeses?.albums.items,
                  let playlists = futuredPlaylist?.playlists.items,
                  let tracks = recommendations?.tracks else {
                return
            }
            self.configureModels(newAlbums: newAlbums, tracks: tracks, playlists: playlists)
        }
    }
    
    
    //MARK: - Configure Models Methods
    //функция конфигурации модели
    private func configureModels(
        newAlbums: [Album],
        tracks: [AudioTrack],
        playlists: [Playlist] ) {
            
            self.newAlbum = newAlbums
            self.playlist = playlists
            self.track = tracks
            //configure models
            sections.append(.newRealeses(viewModels: newAlbums.compactMap({
                return NewRealeasesCellViewModel(
                    name: $0.name,
                    artworkURL: URL(string: $0.images.first?.url ?? ""),
                    numberOfTracks: $0.total_tracks,
                    artistName: $0.artists.first?.name ?? "-")
            })))
            
            sections.append(.feturedPlaylists(viewModels: playlists.compactMap({
                return FeaturedPlaylistCellViewModel(
                    name: $0.name,
                    artworkURL: URL(string: $0.images.first?.url ?? "__"),
                    creatorName: $0.owner.display_name)
            })))
            
            
            sections.append(.recommendedTracks(viewModels: tracks.compactMap({
                return RecommendedTrackCellViewModel(
                    name: $0.name,
                    artworkURL: URL(string: $0.album?.images.first?.url ?? "____"),
                    artistName: $0.artists.first?.name ?? "----")
            })))
            
            
            collectionView.reloadData()
        }
    
    @objc func buttonDidTapped() {
        let vc = SettingsViewController()
        vc.title = "Settings"
        
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
}

//MARK: - UICollectionView extension
extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let type = sections[section]
        switch type {
        case .newRealeses(let viewModels):
            return viewModels.count
        case .feturedPlaylists(let viewModels):
            return viewModels.count
        case .recommendedTracks(let viewModels):
            return viewModels.count
        }
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sections.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
        let section = sections[indexPath.section]
        switch section {
        case .newRealeses:
            let album = newAlbum[indexPath.row]
            let vc = AlbumViewController(album: album)
            vc.navigationItem.largeTitleDisplayMode = .never
            navigationController?.pushViewController(vc, animated: true)
        case .feturedPlaylists:
            let playlist = playlist[indexPath.row]
            let vc = PlaylistViewController(playlist: playlist)
            vc.navigationItem.largeTitleDisplayMode = .never
            navigationController?.pushViewController(vc, animated: true)
        case .recommendedTracks:
            //тут делаем транзишн на экран плеера (пока не создан)
            let track = track[indexPath.row]
            PlaybackPresenter.shared.startPlayback(from: self, track: track)
        }
    }
    //с помощью свича с возращаемой строкой(тот что создан сверху в энуме) мы присваиваем каждому хэдеру свой тайтл по индекспату.
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: TitleHeaderCollectionReusableView.identifire, for: indexPath) as? TitleHeaderCollectionReusableView, kind == UICollectionView.elementKindSectionHeader else {
            return UICollectionReusableView()
        }
        let headerTitle = sections[indexPath.section].title
        header.configure(with: headerTitle )
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let type = sections[indexPath.section]
        switch type {
        case .newRealeses(let viewModels):
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: NewRealeseCollectionViewCell.identifire,
                for: indexPath
            ) as? NewRealeseCollectionViewCell else {
                return UICollectionViewCell()
            }
            let viewModel = viewModels[indexPath.row]
            cell.configure(with: viewModel)
            return cell
        case .feturedPlaylists(let viewModels):
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: FeaturedPlaylistCollectionViewCell.identifire,
                for: indexPath
            ) as? FeaturedPlaylistCollectionViewCell else {
                return UICollectionViewCell()
            }
            let viewModel = viewModels[indexPath.row]
            cell.configure(with: viewModel)
            return cell
        case .recommendedTracks(let viewModels):
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: RecommendatedTrackCollectionViewCell.identifire,
                for: indexPath
            ) as? RecommendatedTrackCollectionViewCell else {
                return UICollectionViewCell()
            }
            let viewModel = viewModels[indexPath.row]
            cell.configure(with: viewModel)
            return cell
        }
    }
}

