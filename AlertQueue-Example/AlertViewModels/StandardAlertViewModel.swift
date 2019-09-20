//
//  StandardAlertViewModel.swift
//  AlertQueue-Example
//
//  Created by William Boles on 13/09/2019.
//  Copyright © 2019 William Boles. All rights reserved.
//

import Foundation

struct StandardAlertViewModel {
    let title: String
    let message: String
    let buttons: [StandardAlertButton]
}

struct StandardAlertButton {
    let title: String
    let style: StandardAlertButtonStyle
    let action: (() -> ())?
}

enum StandardAlertButtonStyle {
    case `default`
    case cancel
    case destructive
}
