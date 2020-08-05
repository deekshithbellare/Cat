//
//  String.swift
//  Cat
//
//  Created by Deekshith Bellare on 05/08/20.
//  Copyright © 2020 Deekshith Bellare. All rights reserved.
//

import Foundation

extension String {

    var localized:String {
        self.localized()
    }
    func localized(withComment comment: String? = nil) -> String {
        return NSLocalizedString(self, comment: comment ?? "")
    }

}
