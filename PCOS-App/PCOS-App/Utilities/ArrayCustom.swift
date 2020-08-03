//
//  ArrayCustom.swift
//  PCOS-App
//
//  Created by Hugh Henry on 29/7/20.
//  Copyright © 2020 Hugh Henry. All rights reserved.
//

import Foundation

class ArrayCustom {
    
    public static func Array2D(_ innerSize: Int, _ outerSize: Int) -> [[String]] {
        var array = [[String]]()

        var temp = [String]()

        for _ in 0...innerSize {
            temp.append("")
        }

        for _ in 0...outerSize {
            array.append(temp)
        }
        
        return array
    }
}
