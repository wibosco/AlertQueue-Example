//
//  InformationAlertViewModel.swift
//  AlertQueue-Example
//
//  Created by William Boles on 13/09/2019.
//  Copyright © 2019 William Boles. All rights reserved.
//

import Foundation

struct InformationAlertViewModel {
    let title: String
    let button: InformationalAlertButton
}

struct InformationalAlertButton {
    let title: String
    let action: (() -> ())?
}
