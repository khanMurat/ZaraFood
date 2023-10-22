//
//  LocalDataSource.swift
//  ZaraFood
//
//  Created by Murat on 22.10.2023.
//

import Foundation
import SQLite
import RxSwift


class LocalDataSource {
    
    static let shared = LocalDataSource()
    
    private var database : Connection!
    
    let foodTable = Table("Foods")
    let id = Expression<String>("id")
    let foodName = Expression<String>("foodName")
    let foodImageName = Expression<String>("foodImageName")
    let foodPrice = Expression<String>("foodPrice")
    let isFavorite = Expression<Bool>("isFavorite")
    
    
   private init() {

       getDatabasePath()
       
    }
    
    private func getDatabasePath(){
        
        do{
            let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
            
            self.database = try Connection("\(path)/db.sqlite3")
            
            createTable()
        }catch{
            print("DEBUG : Error when database connection \(error.localizedDescription)")
        }
    }
    
    private func createTable(){
        
        do{
            let existingTables = try database.scalar("SELECT name FROM sqlite_master WHERE type='table' AND name='Foods'")
            if existingTables != nil{
                print("Table already exists")
                return
            }
        }catch{
            print("Error checking for existing table: \(error)")
        }
        
        do{
            
            try database.run(foodTable.create { t in
                t.column(id, primaryKey: true)
                t.column(foodName)
                t.column(foodPrice)
                t.column(foodImageName)
                t.column(isFavorite)
            })
        }catch{
            print(error.localizedDescription)
        }
        
    }
    
    func insertFood(food:Yemekler){
        
        let insertOrUpdate = foodTable.insert(or: .replace,
                                              id <- food.yemekID,
                                              foodName <- food.yemekAdi,
                                              foodPrice <- food.yemekFiyat,
                                              foodImageName <- food.yemekResimAdi,
                                              isFavorite <- food.isFavorite
        )
        do{
            try database.run(insertOrUpdate)
        }catch{
            print("DEBUG : Error when insert food to table \(error.localizedDescription)")
        }
    }
    
    func getAllFoods() -> Observable<[Yemekler]> {
        
        return Observable.create { observer in
            
            do{
                
                var foods = [Yemekler]()
                
                for food in try self.database.prepare(self.foodTable){
                    
                    let yemek = Yemekler(yemekID: food[self.id], yemekAdi: food[self.foodName], yemekResimAdi: food[self.foodImageName], yemekFiyat: food[self.foodPrice],isFavorite: food[self.isFavorite])
                    foods.append(yemek)
                }
                
                observer.onNext(foods)
                observer.onCompleted()
            }catch{
                observer.onError(error)
            }
            return Disposables.create()
        }
        
    }
    
    func searchFoods(query: String) -> Observable<[Yemekler]> {
        return Observable.create { observer in
            do {
                var foods = [Yemekler]()
                let queryResult = self.foodTable.filter(self.foodName.like("%\(query)%"))
                for food in try self.database.prepare(queryResult) {
                    let yemek = Yemekler(yemekID: food[self.id], yemekAdi: food[self.foodName], yemekResimAdi: food[self.foodImageName], yemekFiyat: food[self.foodPrice], isFavorite: food[self.isFavorite])
                    foods.append(yemek)
                }
                observer.onNext(foods)
                observer.onCompleted()
            } catch {
                observer.onError(error)
            }
            return Disposables.create()
        }
    }

}
