//
//  LocalFishCell.swift
//  FreshFishStore
//
//  Created by Sherif  Wagih on 11/6/18.
//  Copyright © 2018 Sherif  Wagih. All rights reserved.
//

import UIKit
import SDWebImage
import ProgressHUD
class FishCell: UICollectionViewCell{
    var fish:Fish?{
        didSet{
            guard let fish = fish else {return}
            if let url =  fish.img
            {
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
            let fishName = fish.name ?? ""
            let attributedString = NSMutableAttributedString(attributedString: NSAttributedString(string: "\(fishName) \n", attributes: [
                NSAttributedString.Key.font:UIFont.boldSystemFont(ofSize: 22),
                NSAttributedString.Key.foregroundColor:UIColor(red: 132/255, green: 112/255, blue: 255/255, alpha: 1)
                ]))
            let kiloPrice = fish.kilo_price ?? ""
            attributedString.append(NSAttributedString(string: "سعر الكيلو:\(kiloPrice) دينار \n", attributes: [
                NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 20),
                NSAttributedString.Key.foregroundColor : UIColor.gray
                ]))
            let salaPrice = fish.sala_price ?? ""
            attributedString.append(NSAttributedString(string: "سعر السلة:\(salaPrice) دينار", attributes:
                [
                    NSAttributedString.Key.font:UIFont.boldSystemFont(ofSize: 20),
                    NSAttributedString.Key.foregroundColor:UIColor.gray
                ]
            ))
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineSpacing = 15
            attributedString.addAttribute(.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, attributedString.length))
            titleStack.attributedText = attributedString
            titleStack.textAlignment = .right
        }
    }
    
    let fishImage:UIImageView = {
       let image = UIImageView()
        image.sd_setIndicatorStyle(.gray)
        image.sd_showActivityIndicatorView()
       return image
    }()
    
    let separator:UIView = {
        let separator = UIView()
        separator.backgroundColor = .blue
        return separator
    }()
    
    let titleStack:UILabel = {
        let label = UILabel()
        label.numberOfLines = -1
        label.text = "Sherif\nWagih\nBolas"
        label.textAlignment = .right
        return label
    }()
    
    lazy var mainStack:UIStackView = {
        let stack = UIStackView(arrangedSubviews: [titleStack,separator,fishImage])
        stack.spacing = 4
        return stack
    }()
    
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        setupViews()
    }
    
    func setupViews()
    {
        addSubview(mainStack)
        mainStack.fillSuperView()
        fishImage.anchorToView(size: .init(width: 150, height: 150))
        separator.anchorToView(size:.init(width: 1, height: 150))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
