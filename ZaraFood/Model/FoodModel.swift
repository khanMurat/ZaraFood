//
//  FoodModel.swift
//  ZaraFood
//
//  Created by Murat on 15.10.2023.
//

import Foundation

// MARK: - FoodModel
struct FoodModel: Codable {
    let yemekler: [Yemekler]
    let success: Int
}

// MARK: - Yemekler
struct Yemekler: Codable {
    let yemekID, yemekAdi, yemekResimAdi, yemekFiyat: String
    var isFavorite : Bool = false

    enum CodingKeys: String, CodingKey {
        case yemekID = "yemek_id"
        case yemekAdi = "yemek_adi"
        case yemekResimAdi = "yemek_resim_adi"
        case yemekFiyat = "yemek_fiyat"
    }
}
