//
//  TabbarController.swift
//  ZaraFood
//
//  Created by Murat on 14.10.2023.
//

import UIKit

class TabbarController: UITabBarController {

    //MARK: - Properties
    let highlightView = UIView()
    
    var previousSelectedIndex: Int = 0

    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        highlightView.backgroundColor = .white
        highlightView.frame = CGRect(x: 0, y: tabBar.bounds.height, width:5, height: 2)
        tabBar.addSubview(highlightView)
        
        
        configureTabbar()
        updateHighlightPosition(from: 0, to: 0)
        
    }
    
    //MARK: - Helpers
    
    func configureTabbar(){
        
        let appearance = UITabBarAppearance()
        appearance.backgroundColor = UIColor.black
        
        changeSelectedIndex(itemApperance: appearance.stackedLayoutAppearance)
        changeSelectedIndex(itemApperance: appearance.inlineLayoutAppearance)
        changeSelectedIndex(itemApperance: appearance.compactInlineLayoutAppearance)
        
        tabBar.standardAppearance = appearance
       tabBar.scrollEdgeAppearance = appearance
        
    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        if let index = tabBar.items?.firstIndex(of: item) {
            previousSelectedIndex = selectedIndex
            selectedIndex = index
            updateHighlightPosition(from: previousSelectedIndex, to: selectedIndex)
        }
    }

    func changeSelectedIndex(itemApperance:UITabBarItemAppearance){
        
        itemApperance.selected.titleTextAttributes = [.foregroundColor:UIColor.white]
        
        itemApperance.normal.titleTextAttributes = [.foregroundColor:UIColor.white]
        
    }
    
    func updateHighlightPosition(from oldIndex: Int, to newIndex: Int) {
        let width = tabBar.bounds.width / CGFloat(tabBar.items!.count)
        let newWidth : CGFloat = 5
        let startPosition = CGFloat(oldIndex) * width + width / 2
        let endPosition = CGFloat(newIndex) * width + width / 2
        
        highlightView.frame.size.width = newWidth
        highlightView.center.x = startPosition
        UIView.animate(withDuration: 0.2) {
            self.highlightView.center.x = endPosition
        }
    }
}

