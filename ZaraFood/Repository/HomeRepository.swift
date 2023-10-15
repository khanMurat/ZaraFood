//
//  HomeRepository.swift
//  ZaraFood
//
//  Created by Murat on 16.10.2023.
//

import Foundation
import RxSwift


class HomeRepository{
    
    var foodListObservable : BehaviorSubject<[Yemekler]> = BehaviorSubject(value: [])
    var errorObservable : BehaviorSubject<CustomError?> = BehaviorSubject(value: nil)
    
    func fetchFoods(){
        
        Service.fetchALLFoods { result in
            
            switch result{
            
            case .success(let foods):
                self.foodListObservable.onNext(foods)
            case .failure(let error):
                
                if let customError = error as? CustomError{
                    self.errorObservable.onNext(customError)
                }else{
                    self.errorObservable.onNext(.other(error))
                }
            }
        }
    }
}
