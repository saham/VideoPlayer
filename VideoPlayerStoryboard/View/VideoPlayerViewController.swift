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
            playerView.layer.addSublayer(playerLayer)
            setupPlayButton()
            setupPreviousButton()
            setupNextButton()
            updateTextInformation(forVideo: video)
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
    func updateTextInformation(forVideo video:Video?) {
        guard let video = video, let authorName = video.author?.name, let description = video.description else { return }
        titleLabel.text = video.title
        authorLabel.text = authorName
        let down = Down(markdownString: description)
        detailTextView.attributedText = try? down.toAttributedString()
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
    func setupNextButton() {
        playerView.addSubview(nextButton)
        NSLayoutConstraint.activate([
            nextButton.widthAnchor.constraint(equalToConstant: constant.smallButtonWidth),
            nextButton.heightAnchor.constraint(equalToConstant: constant.smallButtonWidth),
            nextButton.leadingAnchor.constraint(equalTo: playButton.trailingAnchor,constant: 32),
            nextButton.centerYAnchor.constraint(equalTo: playButton.centerYAnchor)
        ])
        nextButton.translatesAutoresizingMaskIntoConstraints = false
        nextButton.backgroundColor = constant.buttonBackgroundColor
        nextButton.layer.cornerRadius = constant.smallButtonWidth / 2
        nextButton.addTarget(self, action: #selector(self.nextTapped), for: .touchUpInside)
        nextButton.clipsToBounds = false
        nextButton.setImage(constant.nextImage, for: [])
    }
    @objc func nextTapped() {
        
    }
    
    func setupPreviousButton() {
        playerView.addSubview(previousButton)
        NSLayoutConstraint.activate([
            previousButton.widthAnchor.constraint(equalToConstant: constant.smallButtonWidth),
            previousButton.heightAnchor.constraint(equalToConstant: constant.smallButtonWidth),
            previousButton.trailingAnchor.constraint(equalTo: playButton.leadingAnchor,constant: -32),
            previousButton.centerYAnchor.constraint(equalTo: playButton.centerYAnchor)
        ])
        previousButton.translatesAutoresizingMaskIntoConstraints = false
        previousButton.backgroundColor = constant.buttonBackgroundColor
        previousButton.layer.cornerRadius = constant.smallButtonWidth / 2
        previousButton.addTarget(self, action: #selector(self.previousTapped), for: .touchUpInside)
        previousButton.clipsToBounds = false
        previousButton.setImage(constant.previousImage, for: [])
    }
    @objc func previousTapped() {
        
    }
}
