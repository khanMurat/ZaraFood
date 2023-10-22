//
//  HomeViewController.swift
//  ZaraFood
//
//  Created by Murat on 14.10.2023.
//

import UIKit
import RxSwift
import RxCocoa

class HomeViewController: UIViewController {
    
    // MARK: - Properties
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var searchField: UITextField!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    
    private var foodList = [Yemekler]() {
        didSet {
            collectionView.reloadData()
        }
    }
    private var index : IndexPath?
    private var viewModel: HomeViewModel!
    private let disposeBag = DisposeBag()

    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewModel()
        setupUI()
        bindViewModel()
        viewModel.getAllFoods()
    }
    
    // MARK: - UI Setup
    
    private func setupUI() {
        configureSearchField()
        configureNavigationBar()
        configureCollectionView(itemCount: 2, spacing: 0.5)
        
        indicator.hidesWhenStopped = true
    }
    
    private func configureSearchField() {
        searchField.layer.borderWidth = 0.5
        searchField.layer.borderColor = UIColor.white.cgColor
        searchField.attributedPlaceholder = NSAttributedString(string: "SEARCH", attributes: [NSAttributedString.Key.foregroundColor : UIColor.white])
    }
    
    private func configureNavigationBar() {
        self.navigationItem.title = "Home"
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
    }
    
    private func configureCollectionView(itemCount: CGFloat, spacing: CGFloat) {
        let design = UICollectionViewFlowLayout()
        design.sectionInset = UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0)
        design.minimumInteritemSpacing = 0.5
        design.minimumLineSpacing = 0
        
        let screenWidth = UIScreen.main.bounds.width
        let itemWidth = (screenWidth - spacing) / itemCount
        design.itemSize = CGSize(width: itemWidth, height: itemWidth * 2)
        
        collectionView.collectionViewLayout = design
        collectionView.keyboardDismissMode = .interactive
    }
    
    // MARK: - ViewModel Setup & Binding
    
    private func setupViewModel() {
        viewModel = HomeViewModel()
    }
    
    private func bindViewModel() {
        viewModel.foodList
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] foods in
                self?.foodList = foods
            })
            .disposed(by: disposeBag)

        viewModel.errorObservable
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] error in
                if error != nil {
                    self?.showErrorAlert(error: error!)
                }
            })
            .disposed(by: disposeBag)
        
        viewModel.isLoading.bind(to: indicator.rx.isAnimating)
            .disposed(by: disposeBag)
        
        let _ = searchField.rx.text.orEmpty
            .debounce(.milliseconds(500), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .subscribe(onNext: { [weak self] query in
                self?.viewModel.searchFood(query: query)
            }).disposed(by: disposeBag)
    }

    // MARK: - Actions
    
    @IBAction func twoGridButtonPressed(_ sender: UIBarButtonItem) {
        configureCollectionView(itemCount: 2, spacing: 0.5)
    }
    
    @IBAction func fourGridButtonPressed(_ sender: UIBarButtonItem) {
        configureCollectionView(itemCount: 3, spacing: 1)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDetailVC"{
            
            let nav = segue.destination as! UINavigationController
            let vc = nav.topViewController as! DetailViewController
            vc.food = foodList[index?.row ?? 0]
        }
    }
}

// MARK: - UICollectionViewDelegate & UICollectionViewDataSource

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return foodList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionCell", for: indexPath) as! HomeCollectionViewCell
        cell.viewModel = HomeCellViewModel(food: foodList[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        index = indexPath
        performSegue(withIdentifier: "toDetailVC", sender: nil)
        
    }
}
