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
    let playButton = UIButton(frame: .zero)
    let previousButton = UIButton(frame: .zero)
    let nextButton = UIButton(frame: .zero)
    
    // MARK: - View LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        Task{
            do {
                if let model = try await apiManager.getAllVideos() {
                    self.videoModel = model
                    setupPlayer(forVideo: self.videoModel?[1])
                    setupPlayButton()
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
        if status {
            avPlayer.play()
            playButton.setImage(constant.pauseImage, for: [])
        } else {
            avPlayer.pause()
            playButton.setImage(constant.playImage, for: [])
        }
    }
    func setupPlayButton() {
        playerView.addSubview(playButton)
        NSLayoutConstraint.activate([
            playButton.widthAnchor.constraint(equalToConstant: constant.largeButtonWidth ),
            playButton.heightAnchor.constraint(equalToConstant: constant.largeButtonWidth ),
            playButton.centerXAnchor.constraint(equalTo: playerView.centerXAnchor),
            playButton.centerYAnchor.constraint(equalTo: playerView.centerYAnchor)
        ])
        playButton.layer.borderColor = constant.buttonBoarderColor
        playButton.layer.borderWidth = constant.buttonBorderWidth
        playButton.translatesAutoresizingMaskIntoConstraints = false
        playButton.backgroundColor = constant.buttonBackgroundColor
        playButton.layer.cornerRadius = constant.largeButtonWidth / 2
        playButton.addTarget(self, action: #selector(self.playTapped), for: .touchUpInside)
        playButton.clipsToBounds = false
        playButton.setImage(constant.playImage, for: [])
    }
    @objc func playTapped() {
        shouldPlay.toggle()
        changePlayerStatus(player: self.player, play: shouldPlay)
    }
}
