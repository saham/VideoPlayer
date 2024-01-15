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
    var currentVideo: Video?
    let playButton = UIButton(frame: .zero)
    let previousButton = UIButton(frame: .zero)
    let nextButton = UIButton(frame: .zero)
    var playerLayer = AVPlayerLayer()
    
    // MARK: - View LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        Task{
            do {
                if let model = try await apiManager.getAllVideos() {
                    self.videoModel = model
                    // JSON does not have date to sort. Title is used to implement the sort
                    videoModel = videoModel?.sorted(by: {$0.title ?? "" < $1.title ?? ""})
                    currentVideo = videoModel?.first
                    setupPlayer(forVideo: currentVideo)
                }
            } catch let error {
                print(error.localizedDescription)
            }
        }
    }

    func setupPlayer(forVideo video:Video?) {
            loadPlayer(forVideo: video)
            playerLayer.frame = playerView.bounds
            playerView.layer.addSublayer(playerLayer)
            setupPlayButton()
            setupPreviousButton()
            setupNextButton()
            updateTextInformation(forVideo: video)
            changePlayerStatus(player: self.player, play: shouldPlay)
    }

    func loadPlayer(forVideo video:Video?) {
        if let urlString = video?.fullURL, let videoURL = URL(string: urlString) {
            let request = URLRequest(url: videoURL)
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    print("\(error.localizedDescription)")
                } else if let httpResponse = response as? HTTPURLResponse {
                    if httpResponse.statusCode != 200 {
                        if let hlsURLString = video?.hlsURL, let hlsUrl = URL(string: hlsURLString) {
                            self.player = AVPlayer(url: hlsUrl)
                        }
                    } else {
                        self.player = AVPlayer(url: videoURL)
                    }
                    self.playerLayer.player = self.player
                    DispatchQueue.main.async {
                        self.changePlayerStatus(player: self.player, play: self.shouldPlay)
                    }
                }
            }
            task.resume()
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
        guard  let description = video?.description else { return }
        titleLabel.text = video?.title
        authorLabel.text = video?.author?.name
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
        nextButton.isEnabled = currentVideo != videoModel?.last
    }

    @objc func nextTapped() {
        if let playingVideo = currentVideo, currentVideo != videoModel?.last, let currentIndex = videoModel?.firstIndex(of: playingVideo) {
            currentVideo = videoModel?[currentIndex + 1]
            loadPlayer(forVideo: currentVideo)
            updateVideoButtons()
            updateTextInformation(forVideo: currentVideo)
        }
    }

    func updateVideoButtons() {
        nextButton.isEnabled = currentVideo != videoModel?.last
        previousButton.isEnabled = currentVideo != videoModel?.first
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
        previousButton.isEnabled = currentVideo != videoModel?.first
    }

    @objc func previousTapped() {
        if let playingVideo = currentVideo, currentVideo != videoModel?.first, let currentIndex = videoModel?.firstIndex(of: playingVideo) {
            currentVideo = videoModel?[currentIndex - 1]
            loadPlayer(forVideo: currentVideo)
            updateVideoButtons()
            updateTextInformation(forVideo: currentVideo)
        }
    }
}
