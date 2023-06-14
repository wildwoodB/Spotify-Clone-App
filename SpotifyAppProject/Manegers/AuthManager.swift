//
//  AuthManager.swift
//  SpotifyAppProject
//
//  Created by Админ on 20.03.2023.
//

import Foundation
// менеджер аутентификации с генериками
final class AuthManager {
    static let shared = AuthManager()
    
    public var refreshingToken = false
    
    struct Constants {
        static let clientID = "dc66ab00636a48f189a248e1e42376a1"
        static let clientSecret = "c5e7d4aa87434ab69b3bb247e1464cc3"
        static let tokenAPIURL = "https://accounts.spotify.com/api/token"
        static let redirectURI = "https://www.iosacademy.io/"
        static let scope = "user-read-private%20user-read-email%20playlist-modify-public%20playlist-modify-private%20playlist-read-private%20user-follow-read%20user-library-modify%20user-library-read"
        
        static let base = "https://accounts.spotify.com/authorize"
    }
    
    private init() {}
    
    public var signInUrl: URL? {
        let string = "\(Constants.base)?response_type=code&client_id=\(Constants.clientID)&scope=\(Constants.scope)&redirect_uri=\(Constants.redirectURI)&show_dialog=TRUE"
        return URL(string: string)
    }
    
    var isSignedIn: Bool {
        return acessToken != nil
    }
    
    private var acessToken: String? {
        return UserDefaults.standard.string(forKey: "access_token")
    }
    
    private var refreshToken: String? {
        return UserDefaults.standard.string(forKey: "refresh_token")
    }
    private var tokenExpirationDate: Date? {
        return UserDefaults.standard.object(forKey: "expirationDate") as? Date
    }
    //мы обновляем токен только если он есть, обновляем за 300 секунд(5минут) до его истечения
    private var shouldRefreshToken: Bool {
        guard let expirationDate = tokenExpirationDate else {
            return false
        }
        let currrentDate = Date()
        let fiveMinute: TimeInterval = 300
        return currrentDate.addingTimeInterval(fiveMinute) >= expirationDate
    }
    
    public func exchengeCodeForToken(code:String, completion: @escaping((Bool)-> Void)) {
        
        //здесь мы получаем токен
        guard let url = URL(string: Constants.tokenAPIURL) else {
            return
        }
        var components = URLComponents()
        components.queryItems = [
            
            URLQueryItem(name: "grant_type", value: "authorization_code"),
            URLQueryItem(name: "code", value: code),
            URLQueryItem(name: "redirect_uri", value: Constants.redirectURI),
            
        ]
        // тело запроса настроенное на основе документации спотифай.
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpBody = components.query?.data(using: .utf8)
        
        //настройка запроса токена на основе документайции и нужных форматов
        let basicToken = Constants.clientID+":"+Constants.clientSecret
        let data = basicToken.data(using: .utf8)
        guard let base64String = data?.base64EncodedString() else {
            print("FAIL")
            completion(false)
            return
        }
        
        request.setValue("Basic \(base64String)", forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.dataTask(with: request) { [weak self] data, _, error in
            
            guard let data = data, error == nil else {
                completion(false)
                return
            }
            
            do {
                let result = try JSONDecoder().decode(AuthResponse.self, from: data)
                self?.cacheToken(result: result)
                print("SUCCESS \(result)")
            } catch {
                print(error.localizedDescription)
                completion(false)
            }
            
            
        }
        
        task.resume()
        
        
    }
    
    //добавим массив с комплишенами обновления блока, что бы не обновлять токен лишний раз
    private var onRefreshBlocs = [((String) -> Void)]()
    
    public func withValidToken(completion: @escaping(String) -> Void) {
        guard !refreshingToken else {
            //здесь в случае успешного обновления мы доабвляем в массив наш комплишен на основе которого функция дальше будет принимать решение обновлять токен или нет.
            onRefreshBlocs.append(completion)
            return
        }
        
        if shouldRefreshToken {
            
            refreshIfNeeded { [weak self] success in
                if let token = self?.acessToken, success {
                    completion(token)
                }
            }
            
        } else if let token = acessToken {
            completion(token)
        }
        
        
    }
    
    public func refreshIfNeeded(completion: ((Bool) -> Void)?) {
        
        guard !refreshingToken else {
            return
        }
        
        guard shouldRefreshToken else {
            completion?(true)
            return
        }
        
        guard let refreshToken = self.refreshToken else {
            return
        }
        
        //обновление токена
        guard let url = URL(string: Constants.tokenAPIURL) else {
            return
        }
        
        refreshingToken = true
        
        var components = URLComponents()
        components.queryItems = [
            
            URLQueryItem(name: "grant_type", value: "refresh_token"),
            URLQueryItem(name: "refresh_token", value: refreshToken),
            
        ]
        // тело запроса настроенное на основе документации спотифай.
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpBody = components.query?.data(using: .utf8)
        
        //настройка запроса токена на основе документайции и нужных форматов
        let basicToken = Constants.clientID+":"+Constants.clientSecret
        let data = basicToken.data(using: .utf8)
        guard let base64String = data?.base64EncodedString() else {
            print("FAIL")
            completion?(false)
            return
        }
        
        request.setValue("Basic \(base64String)", forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.dataTask(with: request) { [weak self] data, _, error in
            self?.refreshingToken = false
            guard let data = data, error == nil else {
                completion?(false)
                return
            }
            
            do {
                let result = try JSONDecoder().decode(AuthResponse.self, from: data)
                //не понимаю нахуй это надо ваще????
                self?.onRefreshBlocs.forEach { $0(result.access_token) }
                self?.onRefreshBlocs.removeAll()
                self?.cacheToken(result: result)
                print("Refreshed")
            } catch {
                print(error.localizedDescription)
                completion?(false)
            }
            
            
        }
        
        task.resume()
    }
    
    //функция кэширования токена
    public func cacheToken(result: AuthResponse) {
        UserDefaults.standard.setValue(result.access_token, forKey: "access_token")
        
        //тут мы проверяем токен, он должен обновится только в случае если он не равен 0.
        if let refresh_token = result.refresh_token {
            UserDefaults.standard.setValue(refresh_token, forKey: "refresh_token")
        }
        
        UserDefaults.standard.setValue(Date().addingTimeInterval(TimeInterval(result.expires_in)), forKey: "expirationDate")
    }
    
}
