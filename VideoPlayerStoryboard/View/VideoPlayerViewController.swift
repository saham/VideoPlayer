import UIKit
import AVFoundation
import AVKit
import Down

class VideoPlayerViewController: UIViewController {

    // MARK: - Outlet
    @IBOutlet weak var playerView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var detailTextView: UITextView!
    
    // MARK: - Variables
    var videoModel:[Video]?
    var apiManager = apiCall.shared
    var player = AVPlayer()
    var shouldPlay = false
    // MARK: - View LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        Task{
            do {
                if let model = try await apiManager.getAllVideos() {
                    self.videoModel = model
                }
            } catch let error {
                print(error.localizedDescription)
            }
        }
    }
    func setupPlayer(forVideo video:Video?) {
        guard let video = video else { return }
        if let urlString = video.fullURL, let videoURL = URL(string: urlString) {
            player = AVPlayer(url: videoURL)
            let playerLayer = AVPlayerLayer(player: player)
            playerLayer.frame = playerView.bounds
            self.playerView.layer.addSublayer(playerLayer)
            changePlayerStatus(player: self.player, play: shouldPlay)
        }
    }
    func changePlayerStatus(player avPlayer:AVPlayer, play status:Bool) {
        if status, avPlayer.status == .readyToPlay {
            avPlayer.play()
        } else {
            avPlayer.pause()
        }
    }
}
