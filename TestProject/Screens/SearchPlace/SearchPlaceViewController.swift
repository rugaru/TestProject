//
//  SearchPlaceViewController.swift
//  TestProject
//
//  Created by alina.golubeva on 06/09/2019.
//  Copyright © 2019 alina.golubeva. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class SearchPlaceViewController: UIViewController {
    private let disposeBag = DisposeBag()
    
    private let container = UIView()
    private let searchBar = UISearchBar(frame: .zero)
    private let tableView = UITableView()
    
    private let viewModel: SearchPlaceViewModelProtocol
    
    init(viewModel: SearchPlaceViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
        tableView.rx.modelSelected(Place.self)
            .bind(to: viewModel.selectedCity.asObserver())
            .disposed(by: disposeBag)
        
        viewModel.places
            .observeOn(MainScheduler.instance)
            .bind(to: tableView.rx.items(cellIdentifier: "Cell", cellType: UITableViewCell.self)) { (_, city, cell) in
                cell.textLabel?.text = city.name
                cell.selectionStyle = .none
            }
            .disposed(by: disposeBag)

        searchBar.rx.cancelButtonClicked
            .subscribe(onNext: { [weak self] in
                self?.dismiss(animated: true, completion: nil)
            })
            .disposed(by: disposeBag)
        
        searchBar.rx.text
            .orEmpty
            .debounce(.milliseconds(500), scheduler: MainScheduler.instance)
            .distinctUntilChanged({ $0 == $1 })
            .subscribe(onNext: { [weak self] text in
                guard let self = self else { return }
                self.viewModel.searchPlace(text: text)
            }).disposed(by: disposeBag)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        searchBar.becomeFirstResponder()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        searchBar.resignFirstResponder()
    }
}

extension SearchPlaceViewController {
    private func setupUI() {
        view.addSubview(container)
        container.addSubview(searchBar)
        container.addSubview(tableView)
        
        searchBar.backgroundColor = .white
        searchBar.barStyle = .default
        searchBar.searchBarStyle = .minimal
        searchBar.showsCancelButton = true
        searchBar.placeholder = "Search"
        searchBar.setImage(UIImage(), for: .search, state: .normal)
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        view.setNeedsUpdateConstraints()
        
        container.layer.cornerRadius = 8
        container.layer.shadowRadius = 8
        container.layer.shadowColor = UIColor.black.withAlphaComponent(0.3).cgColor
        container.layer.shadowOpacity = 1
        container.layer.masksToBounds = false
    }
    
    override func updateViewConstraints() {
        container.snp.remakeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.top.equalTo(100)
        }
        
        searchBar.snp.remakeConstraints { make in
            make.left.right.top.equalToSuperview()
        }
        
        tableView.snp.remakeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom)
            make.left.right.bottom.equalToSuperview()
        }
        
        super.updateViewConstraints()
    }
}
