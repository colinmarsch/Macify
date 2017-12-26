import Cocoa
import SwiftHTTP
import OAuthSwift

class SpotifyAPI: NSObject {
    var oauthswift: OAuth2Swift!
    var oauthToken: String!
    var statusMenuController: StatusMenuController?
    static var singleton = SpotifyAPI()
    var isPlaying = false
    
    func setup(statusMenuController: StatusMenuController) {
        self.statusMenuController = statusMenuController
        oauthswift = OAuth2Swift(
            consumerKey:    "b33047cb10854f608ff5f275e83a6825",
            consumerSecret: "879a26051f6a45aaa539bd0ef3657a15",
            authorizeUrl:   "https://accounts.spotify.com/authorize",
            responseType:   "token"
        )
        if oauthswift.client.credential.oauthToken == "" ||  oauthswift.client.credential.isTokenExpired() {
            oauthswift.authorize(
                withCallbackURL: URL(string: "macify://oauth-callback/spotify")!,
                scope: "user-read-currently-playing+user-modify-playback-state", state:"SPOTIFY",
                success: { credential, response, parameters in
                    self.oauthToken = credential.oauthToken
                    self.getCurrentTrack(onGetCurrentTrackListener: self.statusMenuController!)
                },
                failure: { error in
                    print(error.localizedDescription)
                }
            )
        }
    }
    
    func getCurrentTrack(onGetCurrentTrackListener: OnGetCurrentTrackListener) {
        if oauthswift == nil {
            onGetCurrentTrackListener.onFailure(reason: "Not authenticated")
        }
        oauthswift.client.get("https://api.spotify.com/v1/me/player/currently-playing",
            headers: ["Authorization": "Bearer " + oauthToken],
            success: { response in
                let currentTrack = CurrentTrack()
                var jsonDict = try? response.jsonObject() as! [String : Any]
                var item = jsonDict!["item"] as! [String : Any]
                let artistsArray = item["artists"] as! [[String : Any]]
                currentTrack.artist = ""
                for artist in artistsArray {
                    let name = artist["name"] as! String
                    currentTrack.artist! += name + ", "
                }
                currentTrack.artist!.removeLast(2)
                currentTrack.title = (item["name"] as! String)
                var album = item["album"] as! [String : Any]
                var imagesArray = album["images"] as! [[String : Any]]
                currentTrack.artworkURL = (imagesArray[0]["url"] as! String)
                let songLength = item["duration_ms"] as! Double
                let currentProgress = jsonDict!["progress_ms"] as! Double
                currentTrack.remainingTime = songLength - currentProgress
                self.isPlaying = jsonDict!["is_playing"] as! Bool
                onGetCurrentTrackListener.onSuccess(currentTrack: currentTrack)
            },
            failure: { error in
                print(error)
            }
        )
    }
    
    func goPreviousSong() {
        if oauthswift == nil {
            return
        }
        oauthswift.client.post("https://api.spotify.com/v1/me/player/previous",
            headers: ["Authorization": "Bearer " + oauthToken],
            success: { success in
                self.getCurrentTrack(onGetCurrentTrackListener: self.statusMenuController!)
            },
            failure: { error in
                print(error)
            }
        )
    }
    
    func goNextSong() {
        if oauthswift == nil {
            return
        }
        oauthswift.client.post("https://api.spotify.com/v1/me/player/next",
            headers: ["Authorization": "Bearer " + oauthToken],
            success: { success in
                self.getCurrentTrack(onGetCurrentTrackListener: self.statusMenuController!)
            },
            failure: { error in
                print(error)
            }
        )
    }
    
    func playPauseSong() {
        if !isPlaying {
            oauthswift.client.put("https://api.spotify.com/v1/me/player/play",
                headers: ["Authorization": "Bearer " + oauthToken],
                success: { success in
                    self.getCurrentTrack(onGetCurrentTrackListener: self.statusMenuController!)
                },
                failure: { error in
                    print(error)
                }
            )
        } else {
            oauthswift.client.put("https://api.spotify.com/v1/me/player/pause",
                headers: ["Authorization": "Bearer " + oauthToken],
                success: { success in
                    self.getCurrentTrack(onGetCurrentTrackListener: self.statusMenuController!)
                },
                failure: { error in
                    print(error)
                }
            )
        }
        
    }
}
