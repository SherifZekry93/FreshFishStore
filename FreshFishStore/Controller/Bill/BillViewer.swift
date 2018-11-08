//
//  BillViewer.swift
//  FreshFishStore
//
//  Created by Sherif  Wagih on 11/7/18.
//  Copyright © 2018 Sherif  Wagih. All rights reserved.
//

import UIKit
import ProgressHUD
class BillViewer: UIViewController
{
    let mainScrollView:UIScrollView = {
        let scv = UIScrollView()
        
        return scv
    }()
    
    let containerView:UIView = {
        let view = UIView()
        return view
    }()
    
    
    let nameLabel:UILabel = {
        let name = UILabel()
        name.text = "آدخل الاسم"
        name.textAlignment = .center
        return name
    }()
    
    
    let nameTextField:UITextField = {
        let name = UITextField()
        name.placeholder = "آدخل الاسم"
        name.textAlignment = .center
        name.layer.borderColor = UIColor(white: 0.5, alpha: 0.8).cgColor
        name.layer.cornerRadius = 5
        name.layer.borderWidth = 0.5
        return name
    }()
    
    
    lazy var nameStack:UIStackView = {
        let stack = UIStackView(arrangedSubviews: [nameTextField,nameLabel])
        return stack
    }()
    
    
    let addressLabel:UILabel = {
        let label = UILabel()
        label.text = "العنوان"
        label.textAlignment = .center
        return label
    }()
    
    let addressTextField:UITextField = {
        let address = UITextField()
        address.placeholder = "آدخل العنوان"
        address.textAlignment = .center
        address.layer.borderColor = UIColor(white: 0.5, alpha: 0.8).cgColor
        address.layer.cornerRadius = 5
        address.layer.borderWidth = 0.5
        return address
    }()
    
    lazy var addressStack:UIStackView = {
        let address = UIStackView(arrangedSubviews: [addressTextField,addressLabel])
        return address
    }()
    
    let phoneNumberLabel:UILabel = {
        let phone = UILabel()
        phone.text = "رقم الهاتف"
        phone.textAlignment = .center
        return phone
    }()
    
    let phoneTextField:UITextField = {
        let text = UITextField()
        text.placeholder = "آدخل رقم الهاتف"
        text.textAlignment = .center
        text.layer.borderColor = UIColor(white: 0.5, alpha: 0.8).cgColor
        text.layer.cornerRadius = 5
        text.layer.borderWidth = 0.5
        return text
    }()
    
    lazy var phoneStack:UIStackView = {
        let stack = UIStackView(arrangedSubviews: [phoneTextField,phoneNumberLabel])
        return stack
    }()
    
    lazy var fieldsStack:UIStackView = {
        let stack = UIStackView(arrangedSubviews: [nameStack,addressStack,phoneStack])
        stack.axis = .vertical
        stack.distribution = .fillEqually
        stack.spacing = 20
        return stack
    }()
    let itemsLabel:UILabel = {
        let label = UILabel()
        label.text = ""
        label.numberOfLines = -1
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textColor = UIColor.blue
        label.textAlignment = .center
        return label
    }()
    let collectionLabel:UILabel = {
        let label = UILabel()
        label.text = "المجموع"
        label.textAlignment = .center
        return label
    }()
    
    let finalPriceTextField:UITextField = {
        let text = UITextField()
        text.textAlignment = .center
        text.layer.borderColor = UIColor(white: 0.5, alpha: 0.8).cgColor
        text.layer.cornerRadius = 5
        text.layer.borderWidth = 0.5
        text.isEnabled = false
        return text
    }()
    
    lazy var priceStack:UIStackView = {
        let stack = UIStackView(arrangedSubviews: [finalPriceTextField,collectionLabel])
        return stack
    }()
    
    
    let delieveryLabel:UILabel = {
        let label = UILabel()
        label.text = "خدمة التوصيل"
        label.textAlignment = .center
        return label
    }()
    
    let delieveryTextField:UITextField = {
        let text = UITextField()
        text.textAlignment = .center
        text.layer.borderColor = UIColor(white: 0.5, alpha: 0.8).cgColor
        text.layer.cornerRadius = 5
        text.layer.borderWidth = 0.5
        text.isEnabled = false
        text.text = "2 دينار"
        return text
    }()
    
    lazy var delieveryStack:UIStackView = {
        let stack = UIStackView(arrangedSubviews: [delieveryTextField,delieveryLabel])
        return stack
    }()
    
    let confirmButton:UIButton = {
        let button = UIButton()
        button.setTitle("تآكيد", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.addTarget(self, action: #selector(handleConfirmOrder), for: .touchUpInside)
        button.backgroundColor = .yellow
        return button
    }()
    
    let removeAllProductsButton:UIButton = {
        let button = UIButton()
        button.setTitle("مسح المنتجات", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.addTarget(self, action: #selector(handleRemoveAllProducts), for: .touchUpInside)
        button.backgroundColor = .yellow
        return button
    }()
    lazy var buttonsStack:UIStackView = {
        let buttons = UIStackView(arrangedSubviews: [removeAllProductsButton,confirmButton])
        buttons.distribution = .fillEqually
        buttons.spacing = 10
        return buttons
    }()
    
    lazy var bottomFieldsStack:UIStackView = {
        let stack = UIStackView(arrangedSubviews: [priceStack,delieveryStack,buttonsStack])
        stack.spacing = 20
        stack.axis = .vertical
        stack.distribution = .fillEqually
        return stack
    }()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        setupScrollView()
        setupBillData()
        setupNavigationController()
        self.observeKeyboard()
        view.backgroundColor = .white
    }
    func observeKeyboard()
    {
        NotificationCenter.default.addObserver(self, selector: #selector(controlKeypad), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    @objc func controlKeypad(_ notification:Notification)
    {
        let duration = notification.userInfo![UIResponder.keyboardAnimationDurationUserInfoKey] as! Double
        let curve = notification.userInfo![UIResponder.keyboardAnimationCurveUserInfoKey] as? UInt
        let curframe = (notification.userInfo![UIResponder.keyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
        let targetFrame = (notification.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let delta = targetFrame.origin.y - curframe.origin.y
        UIView.animate(withDuration: duration, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: UIView.AnimationOptions(rawValue: curve!), animations: {
            self.mainScrollViewBottomAnchor?.constant += delta
        }, completion: nil)
    }
    
    var mainScrollViewBottomAnchor:NSLayoutConstraint?
    func setupScrollView()
    {
        view.addSubview(mainScrollView)
        mainScrollView.addSubview(containerView)
        mainScrollView.anchorToView(top: view.safeAreaLayoutGuide.topAnchor, leading: view.safeAreaLayoutGuide.leadingAnchor, bottom: nil, trailing: view.safeAreaLayoutGuide.trailingAnchor, padding: .init(top:0,left:0,bottom:150,right:0))
        mainScrollViewBottomAnchor = mainScrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        mainScrollViewBottomAnchor?.isActive = true
        containerView.anchorToView(top: mainScrollView.topAnchor, leading: mainScrollView.leadingAnchor, bottom: mainScrollView.bottomAnchor, trailing: mainScrollView.trailingAnchor)
        containerView.anchorToView(size:.init(width: view.frame.width, height: view.frame.height))
        containerView.addSubview(fieldsStack)
        fieldsStack.anchorToView(top: containerView.topAnchor, leading: containerView.leadingAnchor, bottom: nil, trailing: containerView.trailingAnchor, padding: .init(top: 10, left: 10, bottom: 20, right: 10), size: .init(width: 0, height: 160))
        containerView.addSubview(itemsLabel)
        containerView.addSubview(bottomFieldsStack)
        itemsLabel.anchorToView(top: fieldsStack.bottomAnchor, leading: fieldsStack.leadingAnchor, bottom: bottomFieldsStack.topAnchor, trailing: fieldsStack.trailingAnchor,padding: .init(top: 20, left: 0, bottom: 20, right: 0))
        bottomFieldsStack.anchorToView(top: itemsLabel.bottomAnchor, leading: itemsLabel.leadingAnchor, bottom: nil, trailing: itemsLabel.trailingAnchor, padding: .init(top: 20, left: 0, bottom: 0, right: 0),size: .init(width: 0, height: 160))
        
        let width = 110
        phoneNumberLabel.anchorToView(size:.init(width: width, height: 0))
        addressLabel.anchorToView(size:.init(width: width, height: 0))
        nameLabel.anchorToView(size:.init(width: width, height: 0))
        collectionLabel.anchorToView(size:.init(width: width, height: 0))
        delieveryLabel.anchorToView(size:.init(width: width, height: 0))
    }
    override func viewDidLayoutSubviews() {
        self.view.setNeedsLayout()
        let height = 160 + 160 + itemsLabel.frame.height + 100
        self.mainScrollView.contentSize = CGSize(width: view.frame.width, height: height)
    }
    
    func setupNavigationController()
    {
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "back").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handleDismiss))
    }
    func setupBillData()
    {
        let path = (UIApplication.shared.delegate as? AppDelegate)
        let allBills = path?.sharedBill
        var fullPrice:Double = 0
        allBills?.forEach({ (bill) in
            guard let billPrice = bill.price else {return}
            guard let fishName = bill.fish?.name else {return}
            
            itemsLabel.text?.append(contentsOf: "\(fishName)         \(billPrice) \n\n")
            fullPrice += bill.price ?? 0
        })
        finalPriceTextField.text = "\(fullPrice) دينار"
    }
    @objc func handleDismiss()
    {
        dismiss(animated: true, completion: nil)
    }
    @objc func handleRemoveAllProducts()
    {
        let path = (UIApplication.shared.delegate as? AppDelegate)
        path?.sharedBill.removeAll()
        handleDismiss()
    }
    @objc func handleConfirmOrder()
    {
        let bills = (UIApplication.shared.delegate as? AppDelegate)?.sharedBill
        var details = ""
        guard let address = addressTextField.text,address != "" else {return}
        guard let name = nameTextField.text, name != "" else {return}
        guard let totalPrice = finalPriceTextField.text, totalPrice != "" else {return}
        
        guard let phone = phoneTextField.text, phone != "" else {return}
        //guard let details = itemsLabel.text , details != "" else {return}
        bills?.forEach({ (bill) in
            guard let quantity = bill.quantity else {return}
            guard let type = bill.type else {return}
            guard let name = bill.fish?.name else {return}
            details.append(contentsOf: "\(quantity) \(type)  \(name) \n")
        })
        guard let tawseel = delieveryTextField.text,tawseel != "" else {return}
        confirmButton.isEnabled = false
        ProgressHUD.show()
        let parameters = ["name":name,"address":address,"phone":phone,"total_price":totalPrice,"tawsel":tawseel,"talab_details":details]
        ApiService.confirmOrder(parameters: parameters) { (response) in
            if response.response?.statusCode == 200
            {
                ProgressHUD.showSuccess("تم تآكيد طلبك")
                let path = UIApplication.shared.delegate as? AppDelegate
                path?.sharedBill.removeAll()
                self.dismiss(animated: true, completion: nil)
            }
            else if response.error != nil || response.response?.statusCode != 200
            {
                self.confirmButton.isEnabled = true
                ProgressHUD.showError("لم يتم تآكيد طلبك حاول مرة آخري ")
            }
        }
    }
}
