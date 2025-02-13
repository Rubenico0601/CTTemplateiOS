//// SliderViewController.swift
//
//import UIKit
//
//class SliderViewController: UIViewController {
//
////    @IBOutlet weak var collectionView: UICollectionView!
////    @IBOutlet weak var collectionview: UICollectionView!
//    
//    @IBOutlet weak var collectionview: UICollectionView!
//    @IBOutlet var collectionView: UIView!
//    private let images: [UIImage] = [
//        UIImage(named: "image1")!,
//        UIImage(named: "image2")!,
//        UIImage(named: "image3")!
//    ]
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
//        collectionview.delegate = self
//        collectionview.dataSource = self
//        collectionview.register(SliderCell.self, forCellWithReuseIdentifier: SliderCell.identifier)
//        collectionview.isPagingEnabled = true // Enable paging
//    }
//}
//
//// MARK: - UICollectionViewDataSource
//extension SliderViewController: UICollectionViewDataSource {
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return images.count
//    }
//
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SliderCell.identifier, for: indexPath) as? SliderCell else {
//            return UICollectionViewCell()
//        }
//        cell.configure(with: images[indexPath.item])
//        return cell
//    }
//}
//
//// MARK: - UICollectionViewDelegateFlowLayout
//extension SliderViewController: UICollectionViewDelegateFlowLayout {
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        return CGSize(width: view.frame.width, height: 300) // Adjust width and height as needed
//    }
//}
