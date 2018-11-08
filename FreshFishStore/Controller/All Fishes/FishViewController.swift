//
//  LocalFishViewController.swift
//  FreshFishStore
//
//  Created by Sherif  Wagih on 11/6/18.
//  Copyright © 2018 Sherif  Wagih. All rights reserved.
//

import UIKit
import ProgressHUD
import SDWebImage
class FishViewController: UICollectionViewController,UICollectionViewDelegateFlowLayout
{
    let cellID = "CellID"
    var allFishes:[Fish] = [Fish]()
    var localFishMode:Bool?{
        didSet{
            getAllFishes()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        setupNavigationBar()
    }
    func getAllFishes()
    {
        var url = ""
        if localFishMode == true
        {
            url = "mahaly.php"
            ProgressHUD.show("تحميل الاسماك المحلية")
        }
        else
        {
            url = "mustawrad.php"
            ProgressHUD.show("تحميل الاسماك المستوردة")
        }
        ApiService.getAllLocalFish(fishURL: url) { (allfishes) in
            if allfishes == nil
            {
                ProgressHUD.showError("Please make sure you are connected to the internet")
            }
            else
            {
                self.allFishes = allfishes! //?? [Fish]()
                self.collectionView.reloadData()
                ProgressHUD.dismiss()
            }
        }
    }
    func setupCollectionView()
    {
        collectionView.register(FishCell.self, forCellWithReuseIdentifier: cellID)
        collectionView.backgroundColor = .white
    }
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return  allFishes.count
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! FishCell
        cell.fish = allFishes[indexPath.item]
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width,height:120)
    }
    func setupNavigationBar()
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
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewItemDetails()
    }
    lazy var blackFadedView :UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0, alpha: 0.3)
        view.frame = self.view.frame
        return view
    }()
    var fish:Fish!
    func viewItemDetails()
    {
        fish = allFishes[collectionView.indexPathsForSelectedItems?.first?.item ?? 0]
        guard let window = UIApplication.shared.keyWindow else {
            return
        }
        window.addSubview(blackFadedView)
        let itemView = UIView()
        blackFadedView.addSubview(itemView)
        itemView.backgroundColor = .white
        let height = view.frame.height > 450 ? 450 : view.frame.height
        itemView.anchorToView(size: .init(width:view.frame.width - 50 ,height:height), centerH: true, centerV: true)
        blackFadedView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(removeBlackFadedView)))
        let titleLabel = UILabel()
        titleLabel.text = fish.name
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = -1
        titleLabel.font = UIFont.boldSystemFont(ofSize: 20)
        itemView.addSubview(titleLabel)
        titleLabel.anchorToView(top: itemView.topAnchor, leading: itemView.leadingAnchor, bottom: nil, trailing: itemView.trailingAnchor,padding: .init(top: 20, left: 0, bottom: 10, right: 0))
        let itemImage = UIImageView()
        guard let fish = fish else {return}
        guard let url = fish.img else {return}
        guard let urlwithPercentEscapes = url.addingPercentEncoding( withAllowedCharacters: .urlQueryAllowed) else{
            return
        }
        guard  let actualURL = URL(string: urlwithPercentEscapes) else {return}
        itemImage.sd_setImage(with: actualURL) { (image, err, cache, url) in
            if err != nil
            {
                return
            }
        }
        
        
        let kiloPrice = fish.kilo_price ?? ""
        itemView.addSubview(itemImage)
        itemImage.anchorToView(top: titleLabel.bottomAnchor, leading: titleLabel.leadingAnchor, bottom: nil, trailing: titleLabel.trailingAnchor, padding: .init(top: 10, left: 0, bottom: 15, right: 0), size: .init(width: 0, height: 200))
        let titleStack = UILabel()
        let attributedString = NSMutableAttributedString(attributedString: NSAttributedString(string: "سعر الكيلو:  \(kiloPrice) دينار \n", attributes: [
            NSAttributedString.Key.font:UIFont.boldSystemFont(ofSize: 22),
            NSAttributedString.Key.foregroundColor:UIColor.gray
            ]))
        let salaPrice = fish.sala_price ?? ""
        attributedString.append(NSAttributedString(string: "سعر السلة:  \(salaPrice) دينار \n", attributes:
            [
                NSAttributedString.Key.font:UIFont.boldSystemFont(ofSize: 22),
                NSAttributedString.Key.foregroundColor:UIColor.gray
            ]
        ))
        let salaKilo = fish.sala_size ?? ""
        attributedString.append(NSAttributedString(string: "وزن السلة:  \(salaKilo) كيلو", attributes: [
            NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 22),
            NSAttributedString.Key.foregroundColor : UIColor.gray
            ]))
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 15
        attributedString.addAttribute(.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, attributedString.length))
        titleStack.attributedText = attributedString
        titleStack.textAlignment = .right
        titleStack.numberOfLines = -1
        itemView.addSubview(titleStack)
        titleStack.anchorToView(top: itemImage.bottomAnchor, leading: itemImage.leadingAnchor, bottom: nil, trailing: itemImage.trailingAnchor,padding: .init(top: 15, left: 0, bottom: 0, right: 0))
        let buyByKilo = UIButton(type: .system)
        buyByKilo.setTitle("شراء بالكيلو", for: .normal)
        buyByKilo.addTarget(self, action: #selector(handleBuyByKilo), for: .touchUpInside)
        buyByKilo.backgroundColor = .yellow
        buyByKilo.setTitleColor(.black, for: .normal)
        buyByKilo.titleLabel?.font = UIFont.boldSystemFont(ofSize: 19)
        let buyBySala = UIButton(type: .system)
        buyBySala.setTitle("شراء بالسلة", for: .normal)
        buyBySala.setTitleColor(.black, for: .normal)
        buyBySala.backgroundColor = .yellow
        buyBySala.titleLabel?.font = UIFont.boldSystemFont(ofSize: 19)
        buyBySala.addTarget(self, action: #selector(handleBuyBySala), for: .touchUpInside)
        let buttonsStack =  UIStackView(arrangedSubviews: [buyBySala,buyByKilo])
        buttonsStack.spacing = 10
        buttonsStack.distribution = .fillEqually
        itemView.addSubview(buttonsStack)
        buttonsStack.anchorToView(top: titleStack.bottomAnchor, leading: titleStack.leadingAnchor, bottom: itemView.bottomAnchor, trailing: titleStack.trailingAnchor, padding: .init(top:10,left:10,bottom:10,right:10),size: .init(width: 0, height: 50))
    }
    @objc func removeBlackFadedView()
    {
        blackFadedView.removeFromSuperview()
    }
    @objc func handleBuyByKilo()
    {
        let addProduct = AddProduct()
        addProduct.fish = self.fish
        addProduct.kiloMode = true
        self.navigationController?.pushViewController(addProduct, animated: true)
    }
    @objc func handleBuyBySala()
    {
        let addProduct = AddProduct()
        addProduct.fish = self.fish
        addProduct.kiloMode = false
        self.navigationController?.pushViewController(addProduct, animated: true)
    }
    override func viewWillDisappear(_ animated: Bool) {
        ProgressHUD.dismiss()
        self.blackFadedView.removeFromSuperview()
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
}
