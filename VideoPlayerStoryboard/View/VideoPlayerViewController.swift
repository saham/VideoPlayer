import UIKit
import Down

class VideoPlayerViewController: UIViewController {

    // MARK: - Outlet
    @IBOutlet weak var playerView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var detailTextView: UITextView!
    
    // MARK: - Variables
    var videoModel:[Video]?
    
    // MARK: - View LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
