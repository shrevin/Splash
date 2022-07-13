import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

   // Once we are authorized, Spotify redirects back to our app using url and passes us a response code
    var window: UIWindow?
    lazy var rootViewController = ViewController()
    

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
//        if ((PFUser.current()) != nil) {
//            let storyboard = UIStoryboard(name: "Main", bundle: nil);
//            //UIStoryboard storyboard = UIStoryboard withName("Main");
//            self.window?.rootViewController = storyboard.instantiateViewController(withIdentifier: "AuthenticatedViewController");
//        }
//        guard let windowScene = (scene as? UIWindowScene) else { return }
//        window = UIWindow(frame: UIScreen.main.bounds)
//        window!.makeKeyAndVisible()
//        window!.windowScene = windowScene
        //window!.rootViewController = rootViewController
        if ((PFUser.current()) != nil) {
            let storyboard = UIStoryboard(name: "Main", bundle: nil);
            //UIStoryboard storyboard = UIStoryboard withName("Main");
            self.window?.rootViewController = storyboard.instantiateViewController(withIdentifier: "AuthenticatedViewController");
        }
    }
    

//    // For spotify authorization and authentication flow
//    // openURLContexts is where Spotify talks back to us and passes that code (we extract it and save it as a variable in our view controller)
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        guard let url = URLContexts.first?.url else { return }
        let parameters = rootViewController.appRemote.authorizationParameters(from: url)
        if let code = parameters?["code"] {
            rootViewController.responseCode = code
        } else if let access_token = parameters?[SPTAppRemoteAccessTokenKey] {
            rootViewController.accessToken = access_token
            
        } else if let error_description = parameters?[SPTAppRemoteErrorDescriptionKey] {
            print("No access token error =", error_description)
        }
        window!.rootViewController = rootViewController
        
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        if let accessToken = rootViewController.appRemote.connectionParameters.accessToken {
            rootViewController.appRemote.connectionParameters.accessToken = accessToken
            rootViewController.appRemote.connect()
        } else if let accessToken = rootViewController.accessToken {
            rootViewController.appRemote.connectionParameters.accessToken = accessToken
            rootViewController.appRemote.connect()
        }
    }

    func sceneWillResignActive(_ scene: UIScene) {
        if rootViewController.appRemote.isConnected {
            rootViewController.appRemote.disconnect()
        }
    }
}
