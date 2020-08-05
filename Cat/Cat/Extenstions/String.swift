//
//  String.swift
//  Cat
//
//  Created by Deekshith Bellare on 05/08/20.
//  Copyright © 2020 Deekshith Bellare. All rights reserved.
//

import Foundation

//Localisation
extension String {

    var localized:String {
        self.localized()
    }
    func localized(withComment comment: String? = nil) -> String {
        return NSLocalizedString(self, comment: comment ?? "")
    }
}

//Named colors from the Asset catalog
//This is a helper enum for named colors.
//It helps in inteligent code completion and typos while using named colors
enum Colors:String {
    case catGrey
    case catRed
}
