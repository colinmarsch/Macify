import Cocoa

class SongView: NSView {
    @IBOutlet weak var titleLabel: NSTextField!
    @IBOutlet weak var albumImage: NSImageView!
    @IBOutlet weak var playPauseButton: NSButton!
    @IBOutlet weak var backButton: NSButton!
    @IBOutlet weak var forwardButton: NSButton!
    var spotifyAPI = SpotifyAPI.singleton
    
    @IBAction func backPressed(_ sender: Any) {
        spotifyAPI.goPreviousSong()
    }
    
    @IBAction func playPausePressed(_ sender: Any) {
        spotifyAPI.playPauseSong()
    }
    
    @IBAction func forwardPressed(_ sender: Any) {
        spotifyAPI.goNextSong()
    }
}
