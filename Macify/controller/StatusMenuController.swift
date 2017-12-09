import Cocoa

class StatusMenuController: NSObject {
    @IBOutlet weak var statusMenu: NSMenu!
    @IBOutlet weak var songView: SongView!
    var songMenuItem: NSMenuItem!
    
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
}
