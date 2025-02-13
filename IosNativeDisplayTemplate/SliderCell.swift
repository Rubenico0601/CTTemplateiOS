//
//  SliderCell.swift
//  IosNativeDisplayTemplate
//
//  Created by Gaurav Bhoyar on 16/10/24.
//

import UIKit

class SliderCell: UICollectionViewCell {
    
    @IBOutlet weak var images: UIImageView!
    
    var image : UIImage!{
              didSet{
                  images.image = image
                  }
          }
}
