//
//  CustomAlert.swift
//  Graffy
//
//  Created by Marty Avedon on 2/7/17.
//  Copyright © 2017 C4Q. All rights reserved.
//

import Foundation
import JSSAlertView

func showAlert(_ message: String, presentOn: UIViewController) {
    let thisAlert = JSSAlertView()
    
    //thisAlert.recolorText(Colors.accentColor)
    
    thisAlert.show(
        presentOn,
        title: message.uppercased()
    )
}
