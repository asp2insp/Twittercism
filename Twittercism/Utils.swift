//
//  Utils.swift
//  Twittercism
//
//  Created by Josiah Gaskin on 5/20/15.
//  Copyright (c) 2015 Josiah Gaskin. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    func setHeight(newHeight : CGFloat) {
        var frame = self.frame;
        frame.size.height = newHeight;
        self.frame = frame;
    }
}