//
//  HomeViewModel.swift
//  ZaraFood
//
//  Created by Murat on 16.10.2023.
//

import Foundation
import RxSwift

class HomeViewModel{
    
    var repository = HomeRepository()
    var foodList = BehaviorSubject<[Yemekler]>(value: [Yemekler]())
    var errorObservable: BehaviorSubject<CustomError?> = BehaviorSubject(value: nil)
    var disposeBag = DisposeBag()
    
    init() {
        bindFoods()
        bindErrors()
    }
    
    func bindFoods(){
        
        repository.foodListObservable
            .subscribe { foods in
                self.foodList.onNext(foods)
            }
            .disposed(by: disposeBag)
    }
    
    func bindErrors(){
        
        repository.errorObservable
            .subscribe { customError in
                self.errorObservable.onNext(customError)
            }
            .disposed(by: disposeBag)
    }

    func getAllFoods(){
        
        repository.fetchFoods()
    }
}
