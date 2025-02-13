//  PiPHandler.swift
//  IosNativeDisplayTemplate
//
//  Created by Gaurav Bhoyar on 20/09/24.
//

//Start-Top: (20, 20)
//Start-Bottom: (20, 704)
//End-Top: (190, 20)
//End-Bottom: (190, 704)

import UIKit
import AVKit

class PiPHandler : NSObject, AVPictureInPictureControllerDelegate {
    
    static let shared = PiPHandler()  // Singleton instance
    
    var pipView: UIView!
    var closeButton: UIButton!
    var player: AVPlayer?
    var playerLayer: AVPlayerLayer?
    var isPiPExpanded = false  // Track if PiP is expanded
    var pipController: AVPictureInPictureController?
    var isPlaying = false
    
    

    
    // 1. Set up the PiP view with dragging and a close button
    func setupPiPView(customUnit: NSDictionary, in viewController: UIViewController) {
        
        // Declare variables for each key
        var ndId: String = ""
        var ndLoop: Bool = false
        var ndMovable: Bool = true
        var ndPosition: String = ""
        var ndType: String = ""
        var ndVideoURL: String = ""
        
        
        
        
        var xPosition: CGFloat = 0.0
        var yPosition: CGFloat = 0.0
        
        if let unit = customUnit as? [String: Any] {
            ndId = unit["nd_id"] as? String ?? ""
            ndLoop = unit["nd_loop"] as? Bool ?? false
            ndMovable = unit["nd_movable"] as? Bool ?? true
            ndPosition = unit["nd_position"] as? String ?? ""
            ndType = unit["nd_type"] as? String ?? ""
            ndVideoURL = unit["nd_video_url"] as? String ?? ""
        }
        
        //Setup the position of PIP
        
        //Start-Top: (20, 20)
        //Start-Bottom: (20, 704)
        //End-Top: (190, 20)
        //End-Bottom
        
        switch ndPosition {
        case "start-top":
               xPosition = 20
               yPosition = 40
            print("The position is start_top")
        case "start-bottom":
                xPosition = 20
                yPosition = 704
            print("The position is start_bottom")
        case "end-top":
                xPosition = 190 // Adjust to place at the right edge
                yPosition = 20
            print("The position is end_bottom")
        case "end-bottom":
               xPosition = 190// Adjust to place at the right edge
               yPosition = 704
            print("The position is end_top")
        default:
            print("Position is something else")
        }
        
        pipView = UIView(frame: CGRect(x: xPosition, y: yPosition, width: 200, height: 150))
        pipView.backgroundColor = .black
        pipView.layer.cornerRadius = 10
        pipView.layer.borderWidth = 1
        pipView.layer.borderColor = UIColor.white.cgColor
        pipView.clipsToBounds = true
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(draggedView(_:)))
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(togglePiPSize)) // Tap to expand/collapse
        pipView.isUserInteractionEnabled = true
        
        if ndMovable {
            pipView.addGestureRecognizer(panGesture)
        }
        pipView.addGestureRecognizer(tapGesture)
        
        closeButton = UIButton(frame: CGRect(x: pipView.frame.width - 35, y: 5, width: 30, height: 30))
        closeButton.setTitle("X", for: .normal)
        closeButton.setTitleColor(.white, for: .normal)
        closeButton.backgroundColor = .red
        closeButton.layer.opacity = 0.5
        closeButton.layer.cornerRadius = 15
        closeButton.addTarget(self, action: #selector(closePiPView), for: .touchUpInside)

        pipView.addSubview(closeButton)
        viewController.view.addSubview(pipView)
        
        playVideoInPiP(videoURLString: ndVideoURL)
    }
    
    // 2. Play video inside the PiP view
    func playVideoInPiP(videoURLString: String) {
        
        guard let videoURL = URL(string: videoURLString) else { return }

        player = AVPlayer(url: videoURL)
        playerLayer = AVPlayerLayer(player: player)
        playerLayer?.frame = pipView.bounds
        playerLayer?.videoGravity = .resizeAspectFill
        pipView.layer.insertSublayer(playerLayer!, below: closeButton.layer)
        player?.play()
        startPiP()
        
        // Set up PiP controller for media controls
              if AVPictureInPictureController.isPictureInPictureSupported() {
                  pipController = AVPictureInPictureController(playerLayer: playerLayer!)
                  pipController?.delegate = self  // Set delegate for handling PiP events
              }
        
//        pipController.startPictureInPicture()
          NotificationCenter.default.addObserver(self, selector: #selector(closePiPView), name: .AVPlayerItemDidPlayToEndTime, object: player?.currentItem)
    }
    // Add a method to start PiP mode
       func startPiP() {
           if let pipController = pipController, !pipController.isPictureInPictureActive {
               pipController.startPictureInPicture()
           }
       }
    
    
    // 3. Enable dragging and swiping functionality for the PiP view
    @objc func draggedView(_ sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: pipView.superview)
        guard let draggedView = sender.view else { return }
        
        draggedView.center = CGPoint(x: draggedView.center.x + translation.x, y: draggedView.center.y + translation.y)
        sender.setTranslation(CGPoint.zero, in: pipView.superview)
        
        if sender.state == .ended {
            let velocity = sender.velocity(in: pipView.superview)
            let thresholdVelocity: CGFloat = 500.0
            if abs(velocity.y) > thresholdVelocity || draggedView.frame.origin.y > pipView.superview!.frame.height - 100 {
                closePiPView()
            }
        }
    }
    
    // 4. Toggle between PiP mode and expanded view when tapped
    @objc func togglePiPSize() {
        if isPiPExpanded {
            UIView.animate(withDuration: 0.3) {
                self.pipView.frame = CGRect(x: 100, y: 100, width: 200, height: 150)
                self.playerLayer?.frame = self.pipView.bounds
            }
            isPiPExpanded = false
        } else {
            UIView.animate(withDuration: 0.3) {
                self.pipView.frame = CGRect(x: 0, y: 0, width: self.pipView.superview!.frame.width, height: self.pipView.superview!.frame.height * 0.7)
                self.playerLayer?.frame = self.pipView.bounds
            }
            isPiPExpanded = true
        }
    }
    
    // 5. Close the PiP view when the close button is pressed
    @objc func closePiPView() {
        
        if AVPictureInPictureController.isPictureInPictureSupported() {
            print("PiP is supported")
        } else {
            print("PiP is not supported")
        }
        player?.pause()
        pipView.removeFromSuperview()
    }
    
  
    
    
}

extension ViewController: AVPictureInPictureControllerDelegate {
    // Handle PiP events here, if needed
    func pictureInPictureControllerDidStartPictureInPicture(_ pictureInPictureController: AVPictureInPictureController) {
        print("PiP Started")
    }
    
    func pictureInPictureControllerDidStopPictureInPicture(_ pictureInPictureController: AVPictureInPictureController) {
        print("PiP Stopped")
    }
    
    func pictureInPictureController(_ pictureInPictureController: AVPictureInPictureController, failedToStartPictureInPictureWithError error: Error) {
        print("Failed to start PiP: \(error)")
    }
}
