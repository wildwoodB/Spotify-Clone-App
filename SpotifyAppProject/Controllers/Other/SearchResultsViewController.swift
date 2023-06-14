//
//  SearchResultsViewController.swift
//  SpotifyAppProject
//
//  Created by Админ on 20.03.2023.
//

import UIKit


struct SearchSection {
    let title: String
    let result: [SearchResult]
}

protocol SearchResultsViewControllerDelegate: AnyObject {
    func didTapResult(_ result: SearchResult)
}

class SearchResultsViewController: UIViewController {
    
    private var sections: [SearchSection] = []
    
    weak var delegate: SearchResultsViewControllerDelegate?
    
    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.register(SearchResultDefaultTableViewCell.self, forCellReuseIdentifier: SearchResultDefaultTableViewCell.identifire)
        tableView.register(SearchResultSubtitleTableViewCell.self, forCellReuseIdentifier: SearchResultSubtitleTableViewCell.identifire)
        tableView.isHidden = true
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    public func update(with results: [SearchResult]) {
        
        let artists = results.filter {
            switch $0 {
            case .artist: return true
            default: return false
            }
        }
        print(artists)
        
        let albums = results.filter {
            switch $0 {
            case .album: return true
            default: return false
            }
        }
        
        let playlists = results.filter {
            switch $0 {
            case .playlist: return true
            default: return false
            }
        }
        
        let tracks = results.filter {
            switch $0 {
            case .track: return true
            default: return false
            }
        }
        
        self.sections = [
            SearchSection(title: "Tracks", result: tracks),
            SearchSection(title: "Atrists", result: artists),
            SearchSection(title: "Albums", result: albums),
            SearchSection(title: "Playlists", result: playlists)
            
        ]
        tableView.reloadData()
        tableView.isHidden = results.isEmpty
    }
    
}

extension SearchResultsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        sections[section].result.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let result = sections[indexPath.section].result[indexPath.row]
        guard let acell = tableView.dequeueReusableCell(withIdentifier: SearchResultSubtitleTableViewCell.identifire, for: indexPath) as? SearchResultSubtitleTableViewCell else {
            return UITableViewCell()
        }
        
        switch result {
        case .artist(let artist):
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchResultDefaultTableViewCell.identifire, for: indexPath) as? SearchResultDefaultTableViewCell else {
                return UITableViewCell()
            }
            let viewModel = SearchResultDefaultTableViewCellViewModel(
                title: artist.name,
                imageURL: artist.images?.first?.url ?? "")
            
            cell.configure(viewModel)
            
            return cell
            
        case .track(let track):
            
            let viewModel = SearchResultSubtitleTableViewCellViewModel(
                title: track.name,
                subtitle: track.artists.first?.name ?? "",
                imageUrl: track.album?.images.first?.url ?? "")
            
            acell.configure(viewModel)
            
        case .playlist(let playlist):
            
            let viewModel = SearchResultSubtitleTableViewCellViewModel(
                title: playlist.name,
                subtitle: playlist.owner.display_name ,
                imageUrl: playlist.images.first?.url ?? "")
            
            acell.configure(viewModel)
            
        case .album(let album):
            
            let viewModel = SearchResultSubtitleTableViewCellViewModel(
                title: album.name,
                subtitle: album.release_date ,
                imageUrl: album.images.first?.url ?? "")
            
            acell.configure(viewModel)
        }
        
        return acell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section].title
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let result = sections[indexPath.section].result[indexPath.row]
        delegate?.didTapResult(result)
    }
    
}
