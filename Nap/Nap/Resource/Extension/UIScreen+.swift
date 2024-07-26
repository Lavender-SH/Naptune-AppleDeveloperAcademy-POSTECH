//
//  UIScreen+.swift
//  Nap
//
//  Created by YunhakLee on 7/26/24.
//

import UIKit

extension UIScreen {
    static var isSE: Bool { UIScreen.main.bounds.height < 680 }
}
