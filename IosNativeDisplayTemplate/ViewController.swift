//
//  ViewController.swift
//  IosNativeDisplayTemplate
//
//  Created by Gaurav Bhoyar on 20/09/24.
//

import UIKit
import AVKit

import CleverTapSDK

//Start-Top: (20, 20)
//Start-Bottom: (20, 704)
//End-Top: (190, 20)
//End-Bottom: (190, 704)

//nd_id  Required  Value -nd_pip_video
//nd_video_url Required Video URL
//nd_loop Optional Number of video plays
//nd_type Required Value -custom
//nd_movable Optional Allow to move the window Value - true/false
//nd_position Optional Default window position Values-start-top start-bottom end-top end-bottom

let images = [
UIImage(named: "slider1"),
UIImage(named: "slider2"),
UIImage(named: "slider3"),
UIImage(named: "slider4"),
]

var currentIndex = 0
var timer : Timer?

class ViewController: UIViewController,CleverTapDisplayUnitDelegate,UICollectionViewDelegate ,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
   
    
    @IBOutlet weak var CollectionView: UICollectionView!
    @IBOutlet weak var clickme: UIButton!
    
    @IBOutlet weak var searchicon: UIImageView!
    @IBOutlet weak var BurgerMenu: UIImageView!
    
    @IBOutlet weak var PIP: UIButton!
    
    
    @IBOutlet weak var NewDeals: UIButton!
    
    @IBOutlet weak var myAccount: UIButton!
    @IBOutlet weak var PriceDrop: UIButton!
    
    

    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count

    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "slide", for: indexPath) as! SliderCell;
        cell.image = images[indexPath.item]
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
    
    func startTimer(){
    timer = Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(timerAction), userInfo: nil, repeats: true)
    }
    @objc func timerAction(){
    let desiredScrollPosition = (currentIndex < images.count - 1) ? currentIndex + 1 : 0
        CollectionView.scrollToItem(at: IndexPath(item: desiredScrollPosition, section: 0), at: .centeredHorizontally, animated: true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        SetupCoachMarksForUser()
    }
    
    private func SetupCoachMarksForUser()
    {
        // Do any additional setup after loading the view.
        
        //Need to write a logic here to get data from Native Display
        //Coach Shape,Coach titile, Coach id
        
        let elements: [(rect: CGRect, caption: String)] = [
            (searchicon.extendedFrame, "Search Product and Items"),
            (BurgerMenu.extendedFrame, "Full Menu"),
            (PIP.extendedFrame, "Picture in Picture"),
            (myAccount.extendedFrame, "My Account"),
            (NewDeals.extendedFrame, "New Deals Here!!"),
            (PriceDrop.extendedFrame, "Check for the Drops")
        ]

        let coachMarks: [[CoachMark]] = elements.map { element in
            [CoachMark(rect: element.rect, caption: element.caption, shape: .square)]
        }

        let coachMarksView = CoachMarksView(frame: self.view.bounds, coachMarksGroups: coachMarks)
        coachMarksView.delegate = self
        self.view.addSubview(coachMarksView)
        coachMarksView.start()
    }
    



    override func viewDidLoad() {
        super.viewDidLoad()
        setupRootScene()
        // Do any additional setup after loading the view.
        CollectionView.delegate = self
        CollectionView.dataSource = self
        
        let profile: Dictionary<String, String> = [
            //Update pre-defined profile properties
            "Name": "Jack Sonata",
            "Email": "jack.montana@ykg.com",
            //Update custom profile properties
            "Plan type": "Silver",
            "Favorite Food": "Pizza"
        ]
        
        startTimer()

        CleverTap.sharedInstance()?.onUserLogin(profile)
        CleverTap.sharedInstance()?.setDisplayUnitDelegate(self)
        
        
        let tooltips: [(UIView, String, UIColor, UIColor, TooltipDirection)] = [
            (searchicon, "Tap here to search items", UIColor.white, UIColor.red, .left),
            (PriceDrop, "Tap here to open the menu", UIColor.white, UIColor.blue, .top),
            (myAccount, "Tap here for more info", UIColor.white, UIColor.green, .bottom)
        ]
        
        TooltipManager.shared.startSequentialToolTips(for: tooltips, in: self)

        
    
      
        
        }
    
    @IBAction func showPiPButtonTapped(_ sender: UIButton) {
        // Create an instance of PiPViewController
        
        print("Story button tapped!")


//        PiPHandler.shared.startPiP();
    }
    @IBAction func getNaitvePButtonTapped(_ sender: UIButton) {
        // Create an instance of PiPViewController
        
        print("GettNavive button tapped!")
        CleverTap.sharedInstance()?.recordEvent("Get_Native")
       
    }
    
    @objc func backgroundButtonTapped() {
        print("Background button tapped!")
    }

    func displayUnitsUpdated(_ displayUnits: [CleverTapDisplayUnit]) {
        
    
            let units:[CleverTapDisplayUnit] = displayUnits
            for i in 0..<(units.count) {
                print("ND Unit:", units[i].customExtras as Any)
                prepareDisplayView(units[i].customExtras as Any as! NSDictionary)
            }
        }
        //only Custom K Y
        func prepareDisplayView(_ unit: NSDictionary) {
//            PiPHandler.shared.setupPiPView(customUnit: unit, in: self)
                 

        }
    
    private func setupRootScene() {
           // Create the UINavigationController using the method
        // Create the UINavigationController using the method
               let rootNavigationController = createRootScene()
               
               // Add the rootNavigationController's view as a child view
               addChild(rootNavigationController)
               
               // Set the frame of the navigation controller to have a height of 200 dp
               rootNavigationController.view.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: 200)
               
               // Add the view to the parent
               view.addSubview(rootNavigationController.view)
               
               // Notify the child that it has been added to the parent
               rootNavigationController.didMove(toParent: self)
       }
       
       // Include the createRootScene method here or in an extension
       func createRootScene() -> UINavigationController {
           let navigationController = UINavigationController(rootViewController: IGHomeController())
           navigationController.navigationBar.isTranslucent = false
           return navigationController
       }
    
}

extension ViewController: CoachMarksViewDelegate {
    func coachMarksView(_ coachMarksView: CoachMarksView, willNavigateTo index: Int) {
    }
    
    func coachMarksView(_ coachMarksView: CoachMarksView, didNavigateTo index: Int) {
    }
    
    func coachMarksViewWillCleanup(_ coachMarksView: CoachMarksView) {
    }
    
    func didTap(at index: Int) {
        print(index)
    }
    
    func coachMarksViewDidCleanup(_ coachMarksView: CoachMarksView) {
        print("coach marks completed")
    }
}


