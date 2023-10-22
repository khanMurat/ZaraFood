//
//  HomeRepository.swift
//  ZaraFood
//
//  Created by Murat on 16.10.2023.
//

import Foundation
import RxSwift
import RxCocoa


class HomeRepository{
    
    var isLoading  = BehaviorRelay(value: false)
    var foodListObservable : BehaviorSubject<[Yemekler]> = BehaviorSubject(value: [])
    var errorObservable : BehaviorSubject<CustomError?> = BehaviorSubject(value: nil)
    let disposeBag = DisposeBag()
    
    func fetchAndSaveFoods(){
        isLoading.accept(true)
        Service.fetchALLFoods()
            .subscribe(onNext: {foods in
                for food in foods {
                    LocalDataSource.shared.insertFood(food: food)
                }
                self.fetchFoodFromDatabase()
                
            },onError: {error in
                
                if let customError = error as? CustomError{
                    
                    self.errorObservable.onNext(customError)
                    self.isLoading.accept(false)
                }else{
                    self.errorObservable.onNext(.other(error))
                    self.isLoading.accept(false)
                }
            })
            .disposed(by: disposeBag)
    }
    
    func fetchFoodFromDatabase(){
        
        LocalDataSource.shared.getAllFoods().subscribe(onNext: { foods in
            
            self.foodListObservable.onNext(foods)
            
        },onError: {error in
            self.errorObservable.onNext(.other(error))
            }
        ).disposed(by: disposeBag)
    }
    
    func searchFoods(query:String){
        LocalDataSource.shared.searchFoods(query: query).subscribe(onNext: { foods in
            self.foodListObservable.onNext(foods)
            self.isLoading.accept(false)
        },onError: { error in
            self.errorObservable.onNext(.other(error))
            self.isLoading.accept(false)
        }
        ).disposed(by: disposeBag)
    }
}
