//
//  FoodCellViewModel.swift
//  ZaraFood
//
//  Created by Murat on 16.10.2023.
//

import Foundation
import UIKit

struct HomeCellViewModel {
    var food: Yemekler
    
    init(food: Yemekler) {
        self.food = food
    }
    
    var foodName: String {
        return food.yemekAdi
    }
    
    var foodPrice: String {
        return "\(food.yemekFiyat) TL"
    }
    
    var foodImageURL: URL? {
        return URL(string: "\(IMAGE_URL)\(food.yemekResimAdi)")
    }
}
