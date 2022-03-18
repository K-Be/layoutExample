//
//  CustomView.swift
//  ConstraintAnimationExample
//
//  Created by Andrew Romanov on 18.03.2022.
//

import Foundation
import UIKit

class CustomView: UIView {
    override func setNeedsLayout() {
        super.setNeedsLayout()
        StaticLogger.log("CustomView: in setNeedsLayout")
    }

    override func setNeedsUpdateConstraints() {
        super.setNeedsUpdateConstraints()
        StaticLogger.log("CustomView: in setNeedsUpdateConstraints")
    }
}

