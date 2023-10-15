//
//  CustomError.swift
//  ZaraFood
//
//  Created by Murat on 15.10.2023.
//

import Foundation


enum CustomError : Error,LocalizedError{
    
    case invalidURL
    case noData
    case emptyData
    case decodingError
    case other(Error)
    
    var errorDescription: String?{
        
        switch self{
            
        case .invalidURL:
            return "Invalid URL error occured"
        case .noData:
            return "Problem is occured when try to access data"
        case .emptyData:
            return "The data which you want to access is empty"
        case .decodingError:
            return "Error occured when try decoding data"
        case .other(let error):
            return error.localizedDescription
        }
    }
}
