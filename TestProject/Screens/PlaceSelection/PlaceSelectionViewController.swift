//
//  PlaceSelectionViewController.swift
//  TestProject
//
//  Created by alina.golubeva on 04/09/2019.
//  Copyright © 2019 alina.golubeva. All rights reserved.
//

import Action
import SnapKit
import RxSwift

class PlaceSelectionViewController: UIViewController {
    private let disposeBag = DisposeBag()
    private let openMapButton = UIButton()
    
    private let fromTextField = UITextField()
    private let toTextField = UITextField()
    
    private let viewModel: PlaceSelectionViewModelProtocol
    init(viewModel: PlaceSelectionViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
        let fromTextFieldValidation = viewModel.fromCitySubject
            .map { $0 != nil }
            .share(replay: 1)

        let toTextFieldValidation = viewModel.toCitySubject
            .map { $0 != nil }
            .share(replay: 1)

        let enableButton = Observable.combineLatest(fromTextFieldValidation, toTextFieldValidation) { (from, to) in
            return from && to
        }

        enableButton
            .bind(to: openMapButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        openMapButton.rx.tap
            .bind(to: viewModel.searchCityObserver)
            .disposed(by: disposeBag)
        
        viewModel.fromCitySubject
            .map({ $0?.name })
            .bind(to: fromTextField.rx.text)
            .disposed(by: disposeBag)
        
        fromTextField.rx
            .controlEvent([.editingDidBegin])
            .bind(to: viewModel.fromCityObserver)
            .disposed(by: disposeBag)
        
        viewModel.toCitySubject
            .map({ $0?.name })
            .bind(to: toTextField.rx.text)
            .disposed(by: disposeBag)
        
        toTextField.rx
            .controlEvent([.editingDidBegin])
            .bind(to: viewModel.toCityObserver)
            .disposed(by: disposeBag)
    }
}

extension PlaceSelectionViewController {
    private func setupUI() {
        view.backgroundColor = .white
        view.addSubview(fromTextField)
        view.addSubview(toTextField)
        view.addSubview(openMapButton)
        openMapButton.backgroundColor = UIColor(red: 19/255, green: 128/255, blue: 115/255, alpha: 1.0)
        openMapButton.layer.cornerRadius = 10
        
        fromTextField.placeholder = "Откуда"
        toTextField.placeholder = "Куда"
        openMapButton.setTitle("Search", for: .normal)
        
        fromTextField.inputView = UIView()
        toTextField.inputView = UIView()
        
        fromTextField.borderStyle = .roundedRect
        toTextField.borderStyle = .roundedRect
        
        view.setNeedsUpdateConstraints()
    }
    
    override func updateViewConstraints() {
        fromTextField.snp.remakeConstraints { make in
            make.top.equalTo(safeAreaTopInset + 16)
            make.left.equalTo(16)
            make.right.equalTo(-16)
            make.height.equalTo(50)
        }
        
        toTextField.snp.remakeConstraints { make in
            make.left.equalTo(16)
            make.right.equalTo(-16)
            make.top.equalTo(fromTextField.snp.bottom).offset(16)
            make.height.equalTo(50)
        }
        
        openMapButton.snp.remakeConstraints { make in
            make.left.equalTo(16)
            make.right.equalTo(-16)
            make.top.equalTo(toTextField.snp.bottom).offset(16)
            make.height.equalTo(50)
        }
        
        super.updateViewConstraints()
    }
}
