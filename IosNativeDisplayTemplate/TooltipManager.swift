
import UIKit

// Enum for Tooltip Direction
enum TooltipDirection {
    case top, bottom, left, right
}

class TooltipManager {
    
    static let shared = TooltipManager()
    private init() {}
    
    private var currentIndex = 0
    private var tooltips: [(UIView, String, UIColor, UIColor, TooltipDirection)] = []
    private var tooltipContainer: UIView?
    private var tapGesture: UITapGestureRecognizer?

    // Start displaying tooltips
    func startSequentialToolTips(for views: [(UIView, String, UIColor, UIColor, TooltipDirection)], in viewController: UIViewController) {
        // Reset state
        self.currentIndex = 0
        self.tooltips = views
        
        // Show the first tooltip
        showToolTip(for: tooltips[currentIndex], in: viewController)
        
        // Add tap gesture to the view controller to show subsequent tooltips
        tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        viewController.view.addGestureRecognizer(tapGesture!)
    }
    
    // Show a single tooltip
    private func showToolTip(for target: (UIView, String, UIColor, UIColor, TooltipDirection), in viewController: UIViewController) {
        // Remove existing tooltip
        tooltipContainer?.removeFromSuperview()
        
        let (targetView, text, textColor, backgroundColor, direction) = target
        let targetFrame = targetView.superview?.convert(targetView.frame, to: viewController.view) ?? .zero
        
        let tooltipWidth: CGFloat = 200
        let tooltipHeight: CGFloat = 60

        // Create tooltip container
        let container = UIView()
        container.backgroundColor = .clear
        
        // Create label
        let label = UILabel()
        label.text = text
        label.textColor = textColor
        label.backgroundColor = backgroundColor
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.layer.cornerRadius = 8
        label.clipsToBounds = true
        label.frame = CGRect(x: 0, y: 0, width: tooltipWidth, height: tooltipHeight)

        // Arrow layer
        let arrowSize = CGSize(width: 20, height: 10)
        let arrowLayer = CAShapeLayer()
        arrowLayer.fillColor = backgroundColor.cgColor
        
        // Positioning based on direction
        var containerFrame: CGRect
        let arrowPath = UIBezierPath()
        
        switch direction {
        case .top:
            containerFrame = CGRect(x: targetFrame.midX - tooltipWidth / 2, y: targetFrame.minY - tooltipHeight - arrowSize.height, width: tooltipWidth, height: tooltipHeight)
            arrowPath.move(to: CGPoint(x: tooltipWidth / 2 - arrowSize.width / 2, y: tooltipHeight))
            arrowPath.addLine(to: CGPoint(x: tooltipWidth / 2, y: tooltipHeight + arrowSize.height))
            arrowPath.addLine(to: CGPoint(x: tooltipWidth / 2 + arrowSize.width / 2, y: tooltipHeight))
            
        case .bottom:
            containerFrame = CGRect(x: targetFrame.midX - tooltipWidth / 2, y: targetFrame.maxY + arrowSize.height, width: tooltipWidth, height: tooltipHeight)
            arrowPath.move(to: CGPoint(x: tooltipWidth / 2 - arrowSize.width / 2, y: 0))
            arrowPath.addLine(to: CGPoint(x: tooltipWidth / 2, y: -arrowSize.height))
            arrowPath.addLine(to: CGPoint(x: tooltipWidth / 2 + arrowSize.width / 2, y: 0))
            
        case .left:
            containerFrame = CGRect(x: targetFrame.minX - tooltipWidth - arrowSize.height, y: targetFrame.midY - tooltipHeight / 2, width: tooltipWidth, height: tooltipHeight)
            arrowPath.move(to: CGPoint(x: tooltipWidth, y: tooltipHeight / 2 - arrowSize.width / 2))
            arrowPath.addLine(to: CGPoint(x: tooltipWidth + arrowSize.height, y: tooltipHeight / 2))
            arrowPath.addLine(to: CGPoint(x: tooltipWidth, y: tooltipHeight / 2 + arrowSize.width / 2))
            
        case .right:
            containerFrame = CGRect(x: targetFrame.maxX + arrowSize.height, y: targetFrame.midY - tooltipHeight / 2, width: tooltipWidth, height: tooltipHeight)
            arrowPath.move(to: CGPoint(x: 0, y: tooltipHeight / 2 - arrowSize.width / 2))
            arrowPath.addLine(to: CGPoint(x: -arrowSize.height, y: tooltipHeight / 2))
            arrowPath.addLine(to: CGPoint(x: 0, y: tooltipHeight / 2 + arrowSize.width / 2))
        }
        
        // Add label and arrow
        container.frame = containerFrame
        container.addSubview(label)
        arrowLayer.path = arrowPath.cgPath
        container.layer.addSublayer(arrowLayer)

        // Add to view
        viewController.view.addSubview(container)
        self.tooltipContainer = container
    }
    
    // Handle tap to advance to the next tooltip
    @objc private func handleTap(_ gesture: UITapGestureRecognizer) {
        guard let parentVC = gesture.view?.parentViewController else { return }
        
        currentIndex += 1
        if currentIndex < tooltips.count {
            showToolTip(for: tooltips[currentIndex], in: parentVC)
        } else {
            // Remove the last tooltip and clean up
            tooltipContainer?.removeFromSuperview()
            if let tapGesture = tapGesture {
                parentVC.view.removeGestureRecognizer(tapGesture)
            }
        }
    }
}

// Helper to get parent view controller
extension UIView {
    var parentViewController: UIViewController? {
        var responder: UIResponder? = self
        while let r = responder {
            if let vc = r as? UIViewController {
                return vc
            }
            responder = r.next
        }
        return nil
    }
}
