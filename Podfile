# Uncomment the next line to define a global platform for your project
 platform :ios, '14.0'

target 'VideoPlayerStoryboard' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!
  pod 'Down'
  target 'VideoPlayerStoryboardTests' do
    inherit! :search_paths
    pod 'Down'
  end

  target 'VideoPlayerStoryboardUITests' do
    pod 'Down'
  end

end
        if let playingVideo = currentVideo, currentVideo != videoModel?.first, let currentIndex = videoModel?.firstIndex(of: playingVideo) {
            currentVideo = videoModel?[currentIndex - 1]
            loadPlayer(forVideo: currentVideo)
            updateVideoButtons()
            updateTextInformation(forVideo: currentVideo)
        }