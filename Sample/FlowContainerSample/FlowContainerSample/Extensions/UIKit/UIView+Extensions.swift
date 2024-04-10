//
//  UIView+Extensions.swift
//  FlowContainerSample
//
//  Created by Peter Schuette on 4/9/24.
//

import Foundation
import UIKit

extension UIView {
    func addSubviews(_ subviews: UIView...) {
        for subview in subviews {
            addSubview(subview)
        }
    }
}
