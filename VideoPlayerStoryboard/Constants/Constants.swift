import Foundation
import UIKit

/*
    enum to save all constant in one place.
*/
enum constant {
    static let backendURL = "http://localhost:4000/videos"
    static let largeButtonWidth = CGFloat(80)
    static let smallButtonWidth = CGFloat(50)
    static let playImage = UIImage(named: "play")
    static let pauseImage = UIImage(named: "pause")
    static let previousImage = UIImage(named: "previous")
    static let nextImage = UIImage(named: "next")
    static let buttonBoarderColor = UIColor.black.cgColor
    static let buttonBorderWidth = CGFloat(0.8)
    static let buttonBackgroundColor:UIColor = .white
    static let dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
}
