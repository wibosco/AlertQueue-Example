//
//  CustomAlertBViewModel.swift
//  AlertQueue-Example
//
//  Created by William Boles on 18/09/2019.
//  Copyright © 2019 William Boles. All rights reserved.
//

import Foundation
import UIKit

struct ErrorAlertViewModel {
    let title: String
    let message: String
    let icon: UIImage
    let button: ErrorAlertButton
}

struct ErrorAlertButton {
    let title: String
    let action: (() -> ())?
}
