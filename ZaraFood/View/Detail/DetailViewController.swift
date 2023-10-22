//
//  DetailViewController.swift
//  ZaraFood
//
//  Created by Murat on 16.10.2023.
//

import UIKit
import SDWebImage
import Alamofire

class DetailViewController: UIViewController {
    
    @IBOutlet weak var favoriteButton: UIBarButtonItem!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var basketButton: UIButton!
    @IBOutlet weak var foodImage: UIImageView!
    @IBOutlet weak var foodDetail: UILabel!
    @IBOutlet weak var foodPrice: UILabel!
    
    var food : Yemekler?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        configureButtonsLayer()
        
        configureUI()
    }
    
    func configureButtonsLayer(){
        basketButton.layer.borderWidth = 1.0
        basketButton.layer.borderColor = UIColor.darkGray.cgColor
        
        addButton.layer.borderWidth = 1.0
        addButton.layer.borderColor = UIColor.darkGray.cgColor
    }
    
    func configureUI(){
        DispatchQueue.main.async {
            
            guard self.food != nil else {return}
            
            self.foodDetail.text = self.food!.yemekAdi
            self.foodPrice.text = "\(self.food!.yemekFiyat) tl"
            
            let URL = URL(string: "\(IMAGE_URL)\(self.food!.yemekResimAdi)")
            self.foodImage.sd_setImage(with:URL)
        }
    }
    
    @IBAction func closeDetailPressed(_ sender: UIBarButtonItem) {
        
        self.dismiss(animated: true)
        
    }
}
