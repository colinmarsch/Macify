import Cocoa
import Kingfisher

class StatusMenuController: NSObject, OnGetCurrentTrackListener {
    @IBOutlet weak var statusMenu: NSMenu!
    @IBOutlet weak var songView: SongView!
    var songMenuItem: NSMenuItem!
    var spotifyAPI = SpotifyAPI.singleton
    
    let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
    
    override func awakeFromNib() {
        statusItem.title = "Macify"
        songMenuItem = statusMenu.item(withTitle: "Song")
        songMenuItem.view = songView
        statusItem.menu = statusMenu
    }
    
    @IBAction func quitPressed(_ sender: Any) {
        NSApplication.shared.terminate(self)
    }
    
    @IBAction func authorizePressed(_ sender: Any) {
        spotifyAPI.setup(statusMenuController: self)
    }
    
    func onSuccess(currentTrack: CurrentTrack) {
        songView.titleLabel.stringValue = currentTrack.title! + " - " + currentTrack.artist!
        let url = URL(string: currentTrack.artworkURL!)
        songView.albumImage.kf.setImage(with: url)
    }
    
    func onFailure(reason: String) {
        //handle the error here
    }
}
