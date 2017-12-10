import Cocoa

protocol OnGetCurrentTrackListener {
    func onSuccess(currentTrack: CurrentTrack)
    func onFailure(reason: String)
}
