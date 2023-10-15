//
//  HomeCollectionViewCell.swift
//  ZaraFood
//
//  Created by Murat on 15.10.2023.
//

import UIKit
import SDWebImage

class HomeCollectionViewCell: UICollectionViewCell {
    
    var viewModel : HomeCellViewModel?{
        didSet{
            configureCell()
        }
    }
    
    
    @IBOutlet weak var itemName: UILabel!
    
    
    @IBOutlet weak var itemFavorite: UIButton!
    
    
    @IBOutlet weak var itemPrice: UILabel!
    
    
    @IBOutlet weak var itemImage: UIImageView!
    
    
    func configureCell(){
        
        guard let viewModel = viewModel else {return}
        
        itemName.text = viewModel.foodName
        itemPrice.text = viewModel.foodPrice
        itemImage.sd_setImage(with: viewModel.foodImageURL)
        
    }
}
