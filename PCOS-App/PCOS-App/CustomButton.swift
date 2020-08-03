//
//  CustomButton.swift
//  PCOS-App
//
//  Created by Hugh Henry on 17/7/20.
//  Copyright © 2020 Hugh Henry. All rights reserved.
//

import UIKit

class CustomButton: UIButton {
    
    var cornerRadius = 0
    
    required init(cornerRadius: Int = 4) {

        super.init(frame: .zero)
        
        self.cornerRadius = cornerRadius

        // set other operations after super.init, if required
        self.layer.cornerRadius = CGFloat(self.cornerRadius)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
