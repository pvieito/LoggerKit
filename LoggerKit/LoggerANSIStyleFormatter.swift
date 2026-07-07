//
//  LoggerANSIStyleFormatter.swift
//  LoggerKit
//
//  Created by Pedro José Pereira Vieito on 8/7/26.
//  Copyright © 2026 Pedro José Pereira Vieito. All rights reserved.
//

import Foundation

#if canImport(Darwin)
import Darwin
#elseif canImport(Glibc)
import Glibc
#elseif canImport(Musl)
import Musl
#elseif os(Windows)
import CRT
#endif

enum LoggerANSIStyleFormatter {
    private static let escape = "\u{001B}"
    private static let forceColorEnvironmentVariableName = "FORCE_COLOR"
    private static let noColorEnvironmentVariableName = "NO_COLOR"
    private static let termEnvironmentVariableName = "TERM"

    static func applying(_ code: String, to string: String) -> String {
        guard self.isEnabled else {
            return string
        }

        return "\(self.escape)[\(code)m\(string)\(self.escape)[0m"
    }

    private static var isEnabled: Bool {
        guard case .commandLine = Logger.logMode else {
            return false
        }

        let environment = ProcessInfo.processInfo.environment

        guard self.hasTerminalEnvironment(in: environment), self.isStandardErrorConnectedToTerminal else {
            return false
        }

        if self.hasValidValue(self.forceColorEnvironmentVariableName, in: environment) {
            return true
        }

        if self.hasValidValue(self.noColorEnvironmentVariableName, in: environment) {
            return false
        }

        return true
    }

    private static func hasTerminalEnvironment(in environment: [String: String]) -> Bool {
        if let term = environment[self.termEnvironmentVariableName] {
            return term.lowercased() != "dumb"
        }

        #if os(Windows)
        return environment["ANSICON"] != nil || environment["WT_SESSION"] != nil || environment["ConEmuANSI"] == "ON" || environment["TERM_PROGRAM"] != nil
        #else
        return false
        #endif
    }

    private static func hasValidValue(_ key: String, in environment: [String: String]) -> Bool {
        guard let value = environment[key] else {
            return false
        }

        return !value.isEmpty && value != "0"
    }

    private static var isStandardErrorConnectedToTerminal: Bool {
        #if os(Windows)
        return _isatty(FileHandle.standardError.fileDescriptor) != 0
        #elseif canImport(Darwin) || canImport(Glibc) || canImport(Musl)
        return isatty(FileHandle.standardError.fileDescriptor) != 0
        #else
        return false
        #endif
    }
}
