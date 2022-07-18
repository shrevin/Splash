//
//  NetworkCalls.swift
//  Splash
//
//  Created by Shreya Vinjamuri on 7/13/22.
//

import Foundation
@objc class NetworkCalls: NSObject {

    @objc func hi() -> Void {
        print("hi");
    }
    
    private var lastPlayerState: SPTAppRemotePlayerState?
    
    @objc func fetchAccessToken(responseCode: String, completion: @escaping ([String: Any]?, Error?) -> Void) {
        let url = URL(string: "https://accounts.spotify.com/api/token")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        let spotifyAuthKey = "Basic \((spotifyClientId + ":" + spotifyClientSecretKey).data(using: .utf8)!.base64EncodedString())"
        request.allHTTPHeaderFields = ["Authorization": spotifyAuthKey,
                                       "Content-Type": "application/x-www-form-urlencoded"]

        var requestBodyComponents = URLComponents()
        let scopeAsString = stringScopes.joined(separator: " ")

        requestBodyComponents.queryItems = [
            URLQueryItem(name: "client_id", value: spotifyClientId),
            URLQueryItem(name: "grant_type", value: "authorization_code"),
            URLQueryItem(name: "code", value: responseCode),
            URLQueryItem(name: "redirect_uri", value: redirectUri.absoluteString),
            URLQueryItem(name: "code_verifier", value: ""), // not currently used
            URLQueryItem(name: "scope", value: scopeAsString),
        ]

        request.httpBody = requestBodyComponents.query?.data(using: .utf8)

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data,                              // is there data
                  let response = response as? HTTPURLResponse,  // is there HTTP response
                  (200 ..< 300) ~= response.statusCode,         // is statusCode 2XX
                  error == nil else {                           // was there no error, otherwise ...
                      print("Error fetching token \(error?.localizedDescription ?? "")")
                      return completion(nil, error)
                  }
            let responseObject = try? JSONSerialization.jsonObject(with: data) as? [String: Any]
            print("Access Token Dictionary=", responseObject ?? "")
            completion(responseObject, nil) // returns access token in completion handler
        }
        task.resume()
    }
    
    @objc func fetchArtwork(for track: SPTAppRemoteTrack, appRemote: SPTAppRemote, im_view: UIImageView){
        appRemote.imageAPI?.fetchImage(forItem: track, with: CGSize.zero, callback: { [weak self] (image, error) in
            if let error = error {
                print("Error fetching track image: " + error.localizedDescription)
            } else if let image = image as? UIImage {
                im_view.image = image;
            }
        })
    }
    //
//    // fetching the player state using appRemote
    @objc func fetchPlayerState(appRemote: SPTAppRemote) {
        appRemote.playerAPI?.getPlayerState({ [weak self] (playerState, error) in
            if let error = error {
                print("Error getting player state:" + error.localizedDescription)
            } else if let playerState = playerState as? SPTAppRemotePlayerState {
                appRemote.imageAPI?.fetchImage(forItem: playerState.track, with: CGSize.zero, callback: { [weak self] (image, error) in
                    if let error = error {
                        print("Error fetching track image: " + error.localizedDescription)
                    } else if let image = image as? UIImage {
                        
                    }
                })
            }
        })
    }
    
//    @objc func update(playerState: SPTAppRemotePlayerState, appRemote: SPTAppRemote) {
//        fetchArtwork(for: playerState.track, appRemote: appRemote)
////        if lastPlayerState?.track.uri != playerState.track.uri {
////            fetchArtwork(for: playerState.track, appRemote: appRemote)
////        }
//    }
}

    
//    lastPlayerState = playerState
//    trackLabel.text = playerState.track.name
//    trackLabel.isHidden = false;
//
//    let configuration = UIImage.SymbolConfiguration(pointSize: 50, weight: .bold, scale: .large)
//    if playerState.isPaused {
//        playPauseButton.setImage(UIImage(systemName: "play.circle.fill", withConfiguration: configuration), for: .normal)
//    } else {
//        playPauseButton.setImage(UIImage(systemName: "pause.circle.fill", withConfiguration: configuration), for: .normal)
//    }





