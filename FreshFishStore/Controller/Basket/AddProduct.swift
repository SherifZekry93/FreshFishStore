//
//  Basket.swift
//  FreshFishStore
//
//  Created by Sherif  Wagih on 11/6/18.
//  Copyright © 2018 Sherif  Wagih. All rights reserved.
//

import UIKit
import ProgressHUD
class AddProduct: UIViewController,UITextFieldDelegate {
    var kiloMode:Bool?{
        didSet{
            if kiloMode!
            {
                unitLabel.text = "آدخل عدد الكيلوات :"
            }
            else
            {
                unitLabel.text = "آدخل عدد السلات :"
            }
        }
    }
    var fish:Fish?{
        didSet{
            guard let fish = fish else {return}
            guard let url = fish.img else {return}
            guard let urlwithPercentEscapes = url.addingPercentEncoding( withAllowedCharacters: .urlQueryAllowed) else{
                return
            }
            guard  let actualURL = URL(string: urlwithPercentEscapes) else {return}
            fishImage.sd_setImage(with: actualURL) { (image, err, cache, url) in
                if err != nil
                {
                    return
                }
            }
        }
    }
    var currentPrice:Double = 0
    let fishImage:UIImageView = {
        let image = UIImageView()
        image.backgroundColor = .red
        return image
    }()
    
    lazy var mainStack:UIStackView = {
        let stack = UIStackView(arrangedSubviews: [fishImage,unitStack,priceStack,buttonsStack])
        stack.axis = .vertical
        stack.spacing = 25
        return stack
    }()
    
    let unitLabel:UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        return label
    }()
    
    lazy var unitTextField:UITextField = {
       let text = UITextField()
        text.placeholder = "0"
        text.textAlignment = .center
        text.layer.borderColor = UIColor.lightGray.cgColor
        text.layer.borderWidth = 1
        text.delegate = self
        text.addTarget(self, action: #selector(handleUnitTextChange), for: .editingChanged)
        return text
    }()
    
    let priceLabel:UILabel = {
        let label = UILabel()
        label.text = "المجموع : "
        label.textAlignment = .center
        return label
    }()
    
    let priceText:UITextField =
    {
        let price = UITextField()
        price.placeholder = "0"
        // price.text = "0"
        price.textAlignment = .center
        //price.backgroundColor = .yellow
        price.layer.borderColor = UIColor.lightGray.cgColor
        price.layer.borderWidth = 1
        price.isEnabled = false
        return price
    }()
    
    let buyAndAddNew:UIButton = {
       let button = UIButton()
        button.setTitle("شراء و تحديد منتج آخر", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.layer.cornerRadius = 4
        button.backgroundColor = .yellow
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(handleBuyAndAddNew), for: .touchUpInside)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        return button
    }()
    
    let buyAndViewBill:UIButton = {
       let button = UIButton()
        button.setTitle("شراء و آظهار فاتورة", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.layer.cornerRadius = 4
        button.clipsToBounds = true
        button.backgroundColor = .yellow
        button.addTarget(self, action: #selector(handleBuyAndViewBill), for: .touchUpInside)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        return button
    }()
    
    lazy var unitStack:UIStackView = {
        let stack = UIStackView(arrangedSubviews: [unitTextField,unitLabel])
        stack.distribution = .fill
        stack.spacing = 4
        return stack
    }()
    
    
    lazy var priceStack:UIStackView = {
        let stack = UIStackView(arrangedSubviews: [priceText,priceLabel])
        stack.distribution = .fill
        stack.spacing = 4
        return stack
    }()
    
    
    lazy var buttonsStack:UIStackView = {
        let stack = UIStackView(arrangedSubviews: [buyAndViewBill,buyAndAddNew])
        stack.spacing = 10
        stack.distribution = .fillEqually
        return stack
    }()
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        setupViews()
        setupNavigationController()
        self.view.observeKeyboard()
    }
    func setupNavigationController()
    {
        navigationController?.navigationBar.barTintColor = UIColor(red: 42/255, green: 210/255, blue: 201/255, alpha: 1)
        navigationController?.navigationBar.isTranslucent = false
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "back").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handleDismiss))
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "shopping").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handleViewBasket))
        navigationItem.leftBarButtonItem?.tintColor = .black
    }
    @objc func handleDismiss()
    {
        dismiss(animated: true, completion: nil)
    }
    @objc func handleViewBasket()
    {
        guard let count = (UIApplication.shared.delegate as? AppDelegate)?.sharedBill.count else {return}
        if count > 0
        {
            let viewBill = BillViewer()
            let navController = UINavigationController(rootViewController: viewBill)
            present(navController, animated: true, completion: nil)
        }
        else
        {
            ProgressHUD.showError("لا توجد منتجات بالسلة")
        }
    }
    func setupViews()
    {
        view.backgroundColor = .white
        self.view.addSubview(mainStack)
        mainStack.anchorToView(top: view.safeAreaLayoutGuide.topAnchor, leading: view.safeAreaLayoutGuide.leadingAnchor, bottom: nil, trailing: view.safeAreaLayoutGuide.trailingAnchor, padding: .init(top: 0, left: 10,bottom:0,right:10),size: .init(width: 0, height: 455))
        priceLabel.anchorToView(size:.init(width: 70, height: 0))
        unitLabel.anchorToView(size:.init(width: 140, height: 0))
        buttonsStack.anchorToView(size:.init(width: 0, height: 50))
        fishImage.anchorToView(size:.init(width: 0, height: 250))
        unitStack.anchorToView(size:.init(width: 0, height: 40))
        priceStack.anchorToView(size:.init(width: 0, height: 40))
    }
    
    @objc func handleUnitTextChange(sender:UITextField)
    {
        if sender.text == ""
        {
            priceText.text = ""
        }
        guard let amount = NumberFormatter().number(from: sender.text ?? "")?.doubleValue else {return}
        guard  let kiloPrice = NumberFormatter().number(from: fish?.kilo_price ?? "")?.doubleValue else {return}
        guard let salaPrice = NumberFormatter().number(from: fish?.sala_price ?? "")?.doubleValue else {return}
        let kiloFullPrice = amount * kiloPrice
        let salaFullPrice = amount * salaPrice
        if kiloMode!
        {
            currentPrice = kiloFullPrice
            priceText.text = "\(kiloFullPrice)"
        }
        else
        {
            currentPrice = salaFullPrice
            priceText.text = "\(salaFullPrice)"
        }
        
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    {
        let allowedCharacters = CharacterSet.decimalDigits
        let characterSet = CharacterSet(charactersIn: string)
        return allowedCharacters.isSuperset(of: characterSet)
    }
    @objc func handleBuyAndAddNew()
    {
        guard let amount = unitTextField.text, amount != "" else {return}
        guard let doubleAmount = NumberFormatter().number(from: amount)?.doubleValue else {return}
        let bill = Bill(fish: fish, price: currentPrice, quantity: doubleAmount, type: kiloMode == true ? "كيلو" : "سله")
        let path = UIApplication.shared.delegate as? AppDelegate
        path?.sharedBill.append(bill)
        navigationController?.popViewController(animated: true)
    }
    @objc func handleBuyAndViewBill()
    {
        let viewBill = BillViewer()
        let navController = UINavigationController(rootViewController: viewBill)
        let sharedBills = (UIApplication.shared.delegate as? AppDelegate)?.sharedBill
        if sharedBills?.count == 0
        {
            if let amount = unitTextField.text, amount != ""
            {
                guard let doubleAmount = NumberFormatter().number(from: amount)?.doubleValue else {return}
                let bill = Bill(fish: fish, price: currentPrice, quantity: doubleAmount, type: kiloMode == true ? "كيلو" : "سله")
                (UIApplication.shared.delegate as? AppDelegate)?.sharedBill.append(bill)
                present(navController, animated: true, completion: nil)
            }
            else
            {
                
                ProgressHUD.showError("لابد من آختيار منتجات لاظهار فاتورة")
            }
        }
        else
        {
            if let amount = unitTextField.text, amount != ""
            {
                guard let doubleAmount = NumberFormatter().number(from: amount)?.doubleValue else {return}
                let bill = Bill(fish: fish, price: currentPrice, quantity: doubleAmount, type: kiloMode == true ? "كيلو" : "سله")
                (UIApplication.shared.delegate as? AppDelegate)?.sharedBill.append(bill)
            }
            present(navController, animated: true, completion: nil)
        }
    }
}
