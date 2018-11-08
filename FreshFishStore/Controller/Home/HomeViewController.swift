//
//  ViewController.swift
//  FreshFishStore
//
//  Created by Sherif  Wagih on 11/6/18.
//  Copyright © 2018 Sherif  Wagih. All rights reserved.
//

import UIKit
import ProgressHUD
class HomeViewController: UIViewController,DidTapImage{
    var originalStatusImageView:UIImageView?
    let blackBGview = UIView()
    let detailsView = UIImageView()
    let activeWindow = UIApplication.shared.keyWindow
    func TapImage(_ statusImage: UIImageView) {
        guard let activeWindow = activeWindow else {return}
        blackBGview.frame = activeWindow.frame
        blackBGview.backgroundColor = .black
        UIApplication.shared.keyWindow?.addSubview(blackBGview)
        blackBGview.alpha = 0
        if let startingFrame = statusImage.superview?.convert(statusImage.frame, to: collectionView.superview?.superview)
        {
            statusImage.alpha = 0
            detailsView.backgroundColor = .red
            detailsView.frame = startingFrame
            detailsView.image = statusImage.image
            detailsView.isUserInteractionEnabled = true
           detailsView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(zoomOutHandle)))
            activeWindow.addSubview(detailsView)
            UIView.animate(withDuration: 0.5) {
                self.blackBGview.alpha = 1
                self.detailsView.frame = CGRect(x: 0, y:(self.activeWindow?.frame.height)! / 2 - self.detailsView.frame.height / 2, width: self.detailsView.frame.width, height: self.detailsView.frame.height)
            }
            originalStatusImageView = statusImage
        }
    }
    @objc func zoomOutHandle()
    {
        if let startingFrame = originalStatusImageView?.superview?.convert((originalStatusImageView?.frame)!, to: collectionView.superview?.superview)
        {
            UIView.animate(withDuration: 0.5, animations: {
                self.blackBGview.alpha = 1
                self.detailsView.frame = CGRect(x: startingFrame.origin.x, y:startingFrame.origin.y, width: self.self.detailsView.frame.width, height: self.self.detailsView.frame.height)
                self.originalStatusImageView?.alpha = 1
                self.blackBGview.alpha = 0
            }) { (completed) in
                self.detailsView.removeFromSuperview()
                self.blackBGview.removeFromSuperview()
            }
        }
    }
    let cellID = "CellID"
    let imageName = ["first","second","last"]
    lazy var collectionView:UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collection = UICollectionView(frame: .zero,collectionViewLayout:layout)
        collection.isPagingEnabled = true
        collection.bounces = false
        collection.dataSource = self
        collection.delegate = self
        collection.showsHorizontalScrollIndicator = false
        collection.showsVerticalScrollIndicator = false
        collection.semanticContentAttribute = .forceLeftToRight
        return collection
    }()
    
    lazy var importedFishButton:UIButton = {
        let button = UIButton()
        let image = UIImage(named: "ImportedFish")
        button.setImage(image, for: .normal)
        button.addTarget(self, action: #selector(handleImportedFish), for: .touchUpInside)
        return button
    }()
    
    
    let localFishButton:UIButton = {
        let button = UIButton()
        let image = UIImage(named: "LocalFish")
        button.setImage(image, for: .normal)
        button.addTarget(self, action: #selector(handleLocalFish), for: .touchUpInside)
        return button
    }()
    
    lazy var buttonsStack:UIStackView = {
        let stack = UIStackView(arrangedSubviews: [importedFishButton,localFishButton])
        stack.spacing = 20
        stack.distribution = .fillEqually
        return stack
    }()
    
    let nextButton:UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "next").withRenderingMode(.alwaysTemplate), for: .normal)
        button.tintColor = .gray
        button.addTarget(self, action: #selector(nextIndex), for: .touchUpInside)
        return button
    }()
    
    let previousButton:UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "previous").withRenderingMode(.alwaysTemplate), for: .normal)
        button.tintColor = .gray
        button.addTarget(self, action: #selector(previousIndex), for: .touchUpInside)
        return button
    }()
    let callButton:UIButton = {
       let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "contactusimage"), for: .normal)
        button.addTarget(self, action: #selector(handleCallingUS), for: .touchUpInside)
        return button
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationController()
        setupCollectionView()
        setupMenuView()
        setupSliderButtons()
        setupCallingButton()
        view.backgroundColor = .white
    }
    
    func setupCollectionView()
    {
        view.addSubview(collectionView)
        collectionView.anchorToView(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0), size: CGSize(width: 0, height: view.frame.height / 2))
        collectionView.register(SliderCell.self, forCellWithReuseIdentifier: cellID)
    }
    
    func setupMenuView()
    {
        view.addSubview(buttonsStack)
        buttonsStack.anchorToView(top: collectionView.bottomAnchor, leading: collectionView.leadingAnchor, bottom: nil, trailing: collectionView.trailingAnchor, padding: .init(top: 20, left: 20, bottom: 20, right: 20),size: .init(width: 0, height: 120))
    }
    
    func setupNavigationController()
    {
        navigationController?.navigationBar.isHidden = true
    }
    @objc func handleImportedFish()
    {
        let navController = getNav(mode: false)
        present(navController, animated: true, completion: nil)
    }
    @objc func handleLocalFish()
    {
        let navController = getNav(mode: true)
        present(navController, animated: true, completion: nil)
    }
    func getNav(mode:Bool) -> UINavigationController
    {
        let layout = UICollectionViewFlowLayout()
        let FishController = FishViewController(collectionViewLayout:layout)
        let navController = UINavigationController(rootViewController: FishController)
        FishController.localFishMode = mode
        return navController
    }
    func setupSliderButtons()
    {
        view.addSubview(nextButton)
        view.addSubview(previousButton)
        nextButton.anchorToView(top: nil, leading: nil, bottom: nil, trailing: collectionView.trailingAnchor, padding: .init(top: 0, left: 0, bottom: 0, right: 0), size: .init(width: 40, height: 40)); nextButton.centerYAnchor.constraint(equalTo:collectionView.centerYAnchor).isActive = true
        previousButton.anchorToView(top: nil, leading: collectionView.leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: 0, left: 0, bottom: 0, right: 0), size: .init(width: 40, height: 40));
        previousButton.centerYAnchor.constraint(equalTo:collectionView.centerYAnchor).isActive = true
    }
    @objc func nextIndex()
    {
        let currentIdex = collectionView.indexPathsForVisibleItems.first
        if currentIdex?.item != imageName.count - 1
        {
            let nextIndex = IndexPath(item: (currentIdex?.item)! + 1, section: 0)
            collectionView.scrollToItem(at: nextIndex, at: .centeredHorizontally, animated: true)
        }
    }
    @objc func previousIndex()
    {
        let currentIdex = collectionView.indexPathsForVisibleItems.first
        if currentIdex?.item != 0
        {
            let previousIndex = IndexPath(item: (currentIdex?.item)! - 1, section: 0)
            collectionView.scrollToItem(at: previousIndex, at: .centeredHorizontally, animated: true)
        }
    }
    
    func setupCallingButton()
    {
        self.view.addSubview(callButton)
        callButton.anchorToView(top: buttonsStack.bottomAnchor, leading: nil, bottom: nil, trailing: nil, padding: .init(top: 10, left: 0, bottom: 10, right: 0), size: .init(width: 200, height: 100), centerH: true)
    }
    
    @objc func handleCallingUS()
    {
        if let url = URL(string: "tel://+96565050597"), UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
}
