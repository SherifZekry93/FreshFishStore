//
//  SliderCell.swift
//  FreshFishStore
//
//  Created by Sherif  Wagih on 11/6/18.
//  Copyright © 2018 Sherif  Wagih. All rights reserved.
//

import UIKit
protocol DidTapImage {
    func TapImage(_ statusImage:UIImageView)
}
class SliderCell: UICollectionViewCell {
    var delegate:DidTapImage?
    lazy var sliderImage:UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFit
        image.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(magnifyImage)))
        image.isUserInteractionEnabled = true
        return image
    }()
    
    override init(frame: CGRect) {
        super.init(frame:frame)
        backgroundColor = .white
        setupViews()
    }
    func setupViews()
    {
        addSubview(sliderImage)
        sliderImage.fillSuperView()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    @objc func magnifyImage()
    {
        delegate?.TapImage(sliderImage)
    }
}
