//
//  Extensions.swift
//  ZaraFood
//
//  Created by Murat on 16.10.2023.
//

import Foundation
import UIKit

extension UIViewController {
    
    func showErrorAlert(error: CustomError) {
           let alertController = UIAlertController(title: "Error", message: error.errorDescription, preferredStyle: .alert)
           alertController.addAction(UIAlertAction(title: "OK", style: .default))
           present(alertController, animated: true)
       }
}
