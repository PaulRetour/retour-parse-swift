//
//  RetourStandards.swift
//  retour
//
//  Created by Paul Lancashire on 24/05/2017.
//  Copyright © 2017 toucan. All rights reserved.
//

import Foundation
import UIKit

class standards {
    
    let retourGreen = UIColor(red:0.58, green:0.82, blue:0.76, alpha:1.0)
    let retourGrey = UIColor(colorLiteralRed: 0.79, green: 0.79, blue: 0.78, alpha: 1.0)
}

enum Status {
  
    case Single, Married
    static var count: Int { return Status.count + 1 }
    
}
