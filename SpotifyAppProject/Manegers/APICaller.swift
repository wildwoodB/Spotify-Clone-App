//
//  APICaller.swift
//  SpotifyAppProject
//
//  Created by Админ on 20.03.2023.
//

import Foundation

final class APICaller {
    static let shared = APICaller()
    
    private init(){}
    
    struct Constants {
        static let baseAPIURL = "https://api.spotify.com/v1"
    }
    
    //MARK: - Albums
    
    public func getAlbumDetails(for album: Album, comletion: @escaping(Result<AlbumDetailResponse,Error>) -> Void) {
        createRequest(with: URL(string: Constants.baseAPIURL + "/albums/" + album.id), type: .GET) { request in
            let task = URLSession.shared.dataTask(with: request) { data, _, error in
                guard let data = data, error == nil else {
                    comletion(.failure(APIError.faileedToGEtData))
                    return
                }
                do {
                    let result = try JSONDecoder().decode(AlbumDetailResponse.self, from: data)
                    //print(result)
                    comletion(.success(result))
                } catch {
                    comletion(.failure(error))
                }
            }
            task.resume()
        }
    }
    
    
    //MARK: - Playlists
    
    public func getPlaylistDetails(for playlist: Playlist, comletion: @escaping(Result<PlaylistDetailResponse,Error>) -> Void) {
        createRequest(with: URL(string: Constants.baseAPIURL + "/playlists/" + playlist.id), type: .GET) { request in
            let task = URLSession.shared.dataTask(with: request) { data, _, error in
                guard let data = data, error == nil else {
                    comletion(.failure(APIError.faileedToGEtData))
                    return
                }
                do {
                    let result = try JSONDecoder().decode(PlaylistDetailResponse.self, from: data)
                    comletion(.success(result))
                } catch {
                    comletion(.failure(error))
                }
            }
            task.resume()
        }
    }
    //MARK: - New Releases
    
    //создаем функция запроса для релизнутых трекво с лимитом, дальше создааем таску, в ней разворачиваем дату
    public func getNewReleases(comletion: @escaping ((Result<NewReleasesResponse, Error>)) -> Void) {
        
        createRequest(with: URL(string:Constants.baseAPIURL + "/browse/new-releases?limit=50"), type: .GET) { request in
            let task = URLSession.shared.dataTask(with: request) { data, _, error in
                guard let data = data, error == nil else {
                    comletion(.failure(APIError.faileedToGEtData))
                    return
                }
                do {
                    let result = try JSONDecoder().decode(NewReleasesResponse.self, from: data)
                    comletion(.success(result))
                } catch {
                    comletion(.failure(error))
                }
            }
            task.resume()
        }
    }
    //MARK: -FuturedPlaylist
    //здесь мы вызываем свеже выпущенные плейлисты
    public func getAllFuturedPlaylist(completion: @escaping((Result<FuturedPlaylistResponse, Error>)) -> Void) {
        createRequest(with: URL(string: Constants.baseAPIURL + "/browse/featured-playlists?limit=20"), type: .GET) { request in
            let task = URLSession.shared.dataTask(with: request) { data, _, error in
                guard let data = data, error == nil else {
                    completion(.failure(APIError.faileedToGEtData))
                    return
                }
                do {
                    let result = try JSONDecoder().decode(FuturedPlaylistResponse.self, from: data)
                    //print(result)
                    completion(.success(result))
                } catch {
                    completion(.failure(error))
                }
            }
            task.resume()
        }
    }
    //MARK: - getRecomendations
    // функция получения рекмендаций на основе выбраных сидов (сиды залетают в функцию на основе 5ти рандомных сидов из функции выше, но с вызовоим и логикой из ХоумВьюКонтроллера, с сепорацией)
    public func getRecomendations(genres: Set<String>,completion: @escaping (Result<RecomendationsResponse,Error>)-> Void) {
        let seeds = genres.joined(separator: ",")
        createRequest(with: URL(string: Constants.baseAPIURL + "/recommendations?limit=40&seed_genres=\(seeds)"), type: .GET) { request in
            let task = URLSession.shared.dataTask(with: request) { data, _, error in
                guard let data = data, error == nil else {
                    completion(.failure(APIError.faileedToGEtData))
                    return
                }
                do {
                    let result = try JSONDecoder().decode(RecomendationsResponse.self, from: data)
                    //print(result)
                    completion(.success(result))
                } catch {
                    completion(.failure(error))
                }
            }
            task.resume()
        }
    }
    //MARK: - getRecomendesGenres
    //созаем функция для получения рекомендаций, а точнее выбора жанров для дальнейшего поиска и настроек рекомендаций
    public func getRecomendesGenres(completion: @escaping(Result<RecomendedGenres,Error>)->Void) {
        createRequest(with: URL(string: Constants.baseAPIURL+"/recommendations/available-genre-seeds"), type: .GET) { request in
            let task = URLSession.shared.dataTask(with: request) { data, _, error in
                guard let data = data,error == nil else {
                    completion(.failure(APIError.faileedToGEtData))
                    return
                }
                do{
                    let result = try JSONDecoder().decode(RecomendedGenres.self,from: data)
                    //print(result)
                    completion(.success(result))
                } catch {
                    completion(.failure(error))
                }
            }
            task.resume()
        }
        
        
    }
    //MARK: - getCategories
    public func getCategories(completion: @escaping(Result<[Category],Error>)->Void) {
        createRequest(with: URL(string: Constants.baseAPIURL+"/browse/categories?limit=20"), type: .GET) { request in
            let task = URLSession.shared.dataTask(with: request) { data, _, error in
                guard let data = data,error == nil else {
                    completion(.failure(APIError.faileedToGEtData))
                    return
                }
                do{
                    let result = try JSONDecoder().decode(AllCategoriesResponse.self,from: data)
                    //JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed)
                    completion(.success(result.categories.items))
                } catch {
                    completion(.failure(error))
                }
            }
            task.resume()
        }
    }
    //MARK: - getPlaylistCategories
    public func getPlaylistCategories(id: String ,completion: @escaping(Result<[Playlist],Error>)->Void) {
        createRequest(with: URL(string: Constants.baseAPIURL+"/browse/categories/\(id)/playlists?limit=50"), type: .GET) { request in
            let task = URLSession.shared.dataTask(with: request) { data, _, error in
                guard let data = data,error == nil else {
                    completion(.failure(APIError.faileedToGEtData))
                    return
                }
                do{
                    let result = try JSONDecoder().decode(FuturedPlaylistResponse.self,from: data)
                    //JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed)
                    let playlists = result.playlists.items
                    completion(.success(playlists))
                } catch {
                    completion(.failure(error))
                }
            }
            task.resume()
        }
    }
    
    //MARK: -  Search Request method
    
    public func search(with query: String, complition: @escaping (Result <[SearchResult], Error>)-> Void) {
        createRequest(with: URL(string: Constants.baseAPIURL+"/search?limit=10&type=album,track,artist,playlist&q=\(query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")"), type: .GET) { request in
            //print(request.url?.absoluteString ?? "none")
            let task = URLSession.shared.dataTask(with: request) { data, _, error in
                guard let data = data, error == nil else {
                    complition(.failure(APIError.faileedToGEtData))
                    return
                }
                do {
                    let result = try JSONDecoder().decode(SearchResultResponse.self,from: data)
                    //JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed)
                    
                    //здесь мы помещаем наши результаты в массив данных энум-модели через компакт мап.
                    var searchresults: [SearchResult] = []
                    searchresults.append(contentsOf: result.artists.items.compactMap({ .artist(model: $0) }))
                    searchresults.append(contentsOf: result.albums.items.compactMap({ .album(model: $0) }))
                    searchresults.append(contentsOf: result.playlists.items.compactMap({ .playlist(model: $0) }))
                    searchresults.append(contentsOf: result.tracks.items.compactMap({ .track(model: $0) }))
                    
                    complition(.success(searchresults))
                } catch {
                    print(error)
                    complition(.failure(error))
                }
            }
            task.resume()
        }
    }
    
    
    
    //MARK: - HTTP Methods
    //энум с методами реквеста
    enum HTTPMethod: String {
        case GET
        case POST
    }
    
    enum APIError: Error {
        case faileedToGEtData
    }
    
    //MARK: - Profile Api CALLER
    //фкнкция где мы по запросу получаем данные о профиле пользователя наоснове структуры
    public func getCurrentUserProfile(completion: @escaping(Result<UserProfile, Error>)-> Void) {
        
        createRequest(with: URL(string: Constants.baseAPIURL+"/me"), type: .GET) { baseRequest in
            let task = URLSession.shared.dataTask(with: baseRequest) { data, _, error in
                guard let data = data, error == nil else {
                    completion(.failure(APIError.faileedToGEtData))
                    return
                }
                do {
                    let result = try JSONDecoder().decode(UserProfile.self, from: data)
                    //print(result)
                    completion(.success(result))
                } catch {
                    completion(.failure(error))
                }
            }
            task.resume()
        }
    }
    //MARK: - createRequest method
    // функция создания запроса, уточнение метода, интервал времени запроса,токен берем из функции валид токена из менеджера утентификации.
    private func createRequest(with url: URL?,type: HTTPMethod,completion: @escaping(URLRequest) -> Void) {
        AuthManager.shared.withValidToken { token in
            guard let apiURL = url else {
                return
            }
            var request = URLRequest(url: apiURL)
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            request.httpMethod = type.rawValue
            request.timeoutInterval = 30
            completion(request)
        }
    }
    
    
    
    
}
