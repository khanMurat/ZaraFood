//
//  Service.swift
//  ZaraFood
//
//  Created by Murat on 15.10.2023.
//

import Foundation
import Alamofire
import RxSwift


class Service {
    
    
    static func fetchALLFoods() -> Observable<[Yemekler]>{
        
        return Observable.create { observer in
            
            let urlString = "\(BASE_URL)tumYemekleriGetir.php"
            
            AF.request(urlString,method: .get).response { response in
                    
                guard let data = response.data else{
                    observer.onError(CustomError.noData)
                    return
                }
                
                do{
                    let result = try JSONDecoder().decode(FoodModel.self, from: data)
                    
                    if result.yemekler.isEmpty{
                        observer.onError(CustomError.emptyData)
                    }
                    else{
                        observer.onNext(result.yemekler)
                        observer.onCompleted()
                    }
                }catch{
                    print("DEBUG \(CustomError.decodingError.errorDescription ?? "error")")
                }
            }
            return Disposables.create()
        }
    }
}
