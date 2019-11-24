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
    public enum LogLevel: Int, Comparable, CaseIterable {
        case silence = 0
        case error
        case warning
        case important
        case notice
        case success
        case action
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
}

extension Logger {
    // MARK: Log Mode

    /// Possible modes to log.
    ///
    /// - logger: The messages are sended to the System Log and printed with a timestamp in the Standard Error.
    /// - commandLine: The messages are printed in the Standard Error with colors.
    public enum LogMode {
        case logger
        case commandLine
        case customLogger((String) -> ())
    }

    /// The mode of the Logger.
    public static var logMode: LogMode = .logger
}

extension Logger {
    // MARK: Log Functions

    /// Private general log function. The rest of Log functions should call this one.
    private static func log(_ message: CustomStringConvertible) {
        switch Logger.logMode {
        case .logger:
            NSLog(message.description)
        case .commandLine:
            log(message, to: FileHandle.standardError)
        case .customLogger(let customHandler):
            customHandler(message.description)
        }
    }
    
    private static func log(_ message: CustomStringConvertible, to fileHandle: FileHandle) {
        let messageData = Data((message.description + "\n").utf8)
        fileHandle.write(messageData)
    }
    
    /// Log message in Error level and terminate the process.
    public static func log(fatalError: CustomStringConvertible) -> Never {
        log(error: fatalError)
        exit(1)
    }
    
    /// Convenience function to log an Error in Error level and terminate the process.
    public static func log(fatalError: Error) -> Never {
        log(fatalError: fatalError.localizedDescription)
    }

    /// Log message in Error level.
    public static func log(error message: CustomStringConvertible) {
        if logLevel >= .error {
            log("[x] \(message)".red)
        }
    }
    
    /// Convenience function to log an Error in Error level.
    public static func log(error: Error) {
        log(error: error.localizedDescription)
    }

    /// Log message in Warning level.
    public static func log(warning message: CustomStringConvertible) {
        if logLevel >= .warning {
            log("[!] \(message)".yellow)
        }
    }

    /// Convenience function to log an Error in Warning level.
    public static func log(warning: Error) {
        log(warning: warning.localizedDescription)
    }

    /// Log description in Important level.
    public static func log(important message: CustomStringConvertible) {
        if logLevel >= .important {
            log("[*] \(message)".bold)
        }
    }

    /// Log description in Notice level.
    public static func log(notice message: CustomStringConvertible) {
        if logLevel >= .notice {
            log("[!] \(message)")
        }
    }

    /// Log description in Success level.
    public static func log(success message: CustomStringConvertible) {
        if logLevel >= .success {
            log("[*] \(message)".green)
        }
    }
    
    /// Log description in Info level.
    public static func log(action message: CustomStringConvertible) {
        if logLevel >= .action {
            log("[*] \(message)")
        }
    }

    /// Log description in Info level.
    public static func log(info message: CustomStringConvertible) {
        if logLevel >= .info {
            log("[ ] \(message)".white)
        }
    }

    /// Log description in Verbose level.
    public static func log(verbose message: CustomStringConvertible) {
        if logLevel >= .verbose {
            log("[ ] \(message)".white)
        }
    }

    /// Log description in Debug level.
    public static func log(debug message: CustomStringConvertible) {
        if logLevel >= .debug {
            log("[>] \(message)".white)
        }
    }
}

extension Logger {
    /// Log empty line.
    public static func logEmptyLine() {
        if logLevel >= .error {
            log("")
        }
    }
}

@available(*, deprecated)
extension Logger {
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
    public static func log(action mode: LogAction, domain: CustomStringConvertible, key: CustomStringConvertible, data: CustomStringConvertible? = nil) {
        
        switch mode {
        case .read:
            log(debug: "\(domain).\(key) -> \(data ?? "--")")
        case .write:
            log(debug: "\(domain).\(key) <- \(data ?? "--")")
        case .delete:
            log(debug: "\(domain).\(key) x \(data ?? "--")")
        case .reset:
            log(debug: "\(domain).\(key) @ \(data ?? "--")")
        }
    }
}
