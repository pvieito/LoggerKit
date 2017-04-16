//
//  Logger.swift
//  LoggerKit
//
//  Created by Pedro José Pereira Vieito on 15/1/17.
//  Copyright © 2017 Pedro José Pereira Vieito. All rights reserved.
//

import Foundation

/// Main class of LoggerKit. It allows you to log actions and description with different log levels.
public class Logger {

    // MARK: Log Level

    /// Possible levels of the log.
    public enum LogLevel: Int, Comparable {
        case silence = 0
        case error
        case important
        case warning
        case notice
        case success
        case info
        case verbose
        case debug

        public static func < (a: LogLevel, b: LogLevel) -> Bool {
            return a.rawValue < b.rawValue
        }
    }

    /// Log level of the Logger.
    ///
    /// The Logger will only log messages with a level equal or higher than this.
    #if DEBUG
    public static var logLevel: LogLevel = .debug
    #else
    public static var logLevel: LogLevel = .warning
    #endif


    // MARK: Log Mode

    /// Possible modes to log.
    ///
    /// - logger: The messages are sended to the System Log and printed with a timestamp in the Standard Output.
    /// - commandLine: The messages are printed in the Standard Output with colors.
    public enum LogMode: Int {
        case logger
        case commandLine
    }

    /// The mode of the Logger.
    public static var logMode: LogMode = .logger


    // MARK: Log Action

    /// Action to log.
    ///
    /// - read: Read action.
    /// - write: Write action.
    /// - delete: Delete action.
    /// - reset: Reset or initialize action.
    public enum LogAction: Int {
        case read
        case write
        case delete
        case reset
    }

    /// Log action in Debug level.
    ///
    /// - Parameters:
    ///   - mode: Action mode.
    ///   - domain: Domain of the action.
    ///   - key: Specific part of the domain of the action.
    ///   - data: Data transferred during the action.
    public static func log(action mode: LogAction, domain: String, key: String, data: String = "--") {

        switch mode {
        case .read:
            log(debug: "\(domain).\(key) -> \(data)")
        case .write:
            log(debug: "\(domain).\(key) <- \(data)")
        case .delete:
            log(debug: "\(domain).\(key) xx \(data)")
        case .reset:
            log(debug: "\(domain).\(key) ** \(data)")
        }
    }


    // MARK: Log Functions

    /// Private general log function. The rest of Log functions should call this one.
    private static func log(_ message: String) {
        switch Logger.logMode {
        case .logger:
            NSLog(message.replacingOccurrences(of: "%", with: "％"))
        case .commandLine:
            print(message)
        }
    }

    /// Log description in Error level.
    public static func log(error message: String) {
        if logLevel >= .error {
            log("[x] \(message)".red)
        }
    }

    /// Log description in Important level.
    public static func log(important message: String) {
        if logLevel >= .important {
            log("[*] \(message)".bold)
        }
    }

    /// Log description in Warning level.
    public static func log(warning message: String) {
        if logLevel >= .warning {
            log("[!] \(message)".yellow)
        }
    }

    /// Log description in Notice level.
    public static func log(notice message: String) {
        if logLevel >= .notice {
            log("[*] \(message)")
        }
    }

    /// Log description in Success level.
    public static func log(success message: String) {
        if logLevel >= .success {
            log("[*] \(message)".green)
        }
    }

    /// Log description in Info level.
    public static func log(info message: String) {
        if logLevel >= .info {
            log("[ ] \(message)".white)
        }
    }

    /// Log description in Verbose level.
    public static func log(verbose message: String) {
        if logLevel >= .verbose {
            log("[ ] \(message)".white)
        }
    }

    /// Log description in Debug level.
    public static func log(debug message: String) {
        if logLevel >= .debug {
            log("[>] \(message)".white)
        }
    }
}
