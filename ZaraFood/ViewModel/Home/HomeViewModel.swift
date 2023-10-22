//
//  HomeViewModel.swift
//  ZaraFood
//
//  Created by Murat on 16.10.2023.
//

import Foundation
import RxSwift
import RxCocoa

class HomeViewModel{
    
    var repository = HomeRepository()
    var foodList = BehaviorSubject<[Yemekler]>(value: [Yemekler]())
    var isLoading  = BehaviorRelay(value: false)
    var errorObservable: BehaviorSubject<CustomError?> = BehaviorSubject(value: nil)
    let disposeBag = DisposeBag()
    
    init() {
        bindFoods()
        bindErrors()
        bindIndicator()
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
    
    func bindIndicator(){
        
        repository.isLoading.subscribe { loading in
            self.isLoading.accept(loading)
        }.disposed(by: disposeBag)
    }

    func getAllFoods(){
        
        repository.fetchAndSaveFoods()
    }
    
    func searchFood(query:String){
        
        if query.isEmpty{
            getAllFoods()
        }else{
            repository.searchFoods(query: query)
        }
    }
}
