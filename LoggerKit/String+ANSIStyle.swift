//
//  String+ANSIStyle.swift
//  LoggerKit
//
//  Created by Pedro José Pereira Vieito on 8/7/26.
//  Copyright © 2026 Pedro José Pereira Vieito. All rights reserved.
//

extension String {
    var green: String { self.applyingANSIStyle("32") }
    var red: String { self.applyingANSIStyle("31") }
    var bold: String { self.applyingANSIStyle("1") }
    var white: String { self.applyingANSIStyle("37") }
    var yellow: String { self.applyingANSIStyle("33") }

    func applyingANSIStyle(_ code: String) -> String {
        return LoggerANSIStyleFormatter.applying(code, to: self)
    }
}
