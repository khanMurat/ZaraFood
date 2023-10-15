//
//  Service.swift
//  ZaraFood
//
//  Created by Murat on 15.10.2023.
//

import Foundation
import Alamofire


class Service {
    
    
    static func fetchALLFoods(completion:@escaping (Result<[Yemekler],Error>)->Void){
        
        let urlString = "\(BASE_URL)tumYemekleriGetir.php"
        
        AF.request(urlString,method: .get).response{
            response in
            
            guard let data = response.data else{completion(.failure(CustomError.noData))
                return}
            
            do{
                let result = try JSONDecoder().decode(FoodModel.self, from: data)
                
                if result.yemekler.isEmpty{
                    completion(.failure(CustomError.emptyData))
                }
                
                completion(.success(result.yemekler))
             
                
            }catch{
                completion(.failure(CustomError.decodingError))
            }
            
        }
    }
    
    
    
}
