//
//  Logger.swift
//  LoggerKit
//
//  Created by Pedro José Pereira Vieito on 15/1/17.
//  Copyright © 2017 Pedro José Pereira Vieito. All rights reserved.
//

import Foundation

#if canImport(Rainbow)
import Rainbow
#endif

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
        
        public static func < (lhs: LogLevel, rhs: LogLevel) -> Bool {
            return lhs.rawValue < rhs.rawValue
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
    
    private static let _maxLogLevel = LogLevel.allCases.max()!
    private static var _logLevel: LogLevel {
        if self.isExtendedLogEnabled {
            return self._maxLogLevel
        }
        return self.logLevel
    }
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
    // MARK: Private Log Functions
    private static let extendedLogEnvironmentVariableName = "LOGGERKIT_EXTENDED_LOG"
    private static var isExtendedLogEnabled: Bool = {
        return ProcessInfo.processInfo.environment[Logger.extendedLogEnvironmentVariableName] != nil
    }()
    
    /// Private general log function. The rest of Log functions should call this one.
    private static func log(
        _ message: CustomStringConvertible, _error: Error? = nil,
        _file: String = #file, _function: String = #function, _line: Int = #line) {
        switch Logger.logMode {
        case .logger:
            var escapedMessage = message.description.replacingOccurrences(of: "%", with: "%%")
            if Self.isExtendedLogEnabled {
                if let error = _error {
                    escapedMessage += "\nError Details: \(String(describing: error))"
                }
                escapedMessage += "\nReference: \(_file):\(_line) @ \(_function)"
            }
            NSLog(escapedMessage)
        case .commandLine:
            self.log(message)
        case .customLogger(let customHandler):
            customHandler(message.description)
        }
    }
    
    private static func log(_ message: CustomStringConvertible, to fileHandle: FileHandle? = nil) {
        let fileHandle = fileHandle ?? .standardError
        let messageData = Data((message.description + "\n").utf8)
        fileHandle.write(messageData)
    }
}

extension Logger {
    // MARK: Log Functions
    
    /// Log message in Error level and terminate the process.
    public static func log(
        fatalError: CustomStringConvertible, _error: Error? = nil,
        _file: String = #file, _function: String = #function, _line: Int = #line) -> Never {
        self.log(error: fatalError, _error: _error, _file: _file, _function: _function, _line: _line)
        exit(1)
    }
    
    /// Convenience function to log an Error in Error level and terminate the process.
    public static func log(
        fatalError error: Error,
        _file: String = #file, _function: String = #function, _line: Int = #line) -> Never {
        self.log(fatalError: error.localizedDescription, _error: error, _file: _file, _function: _function, _line: _line)
    }
    
    /// Log message in Error level.
    public static func log(
        error message: CustomStringConvertible, _error: Error? = nil,
        _file: String = #file, _function: String = #function, _line: Int = #line) {
        if self._logLevel >= .error {
            self.log("[x] \(message)".red, _error: _error, _file: _file, _function: _function, _line: _line)
        }
    }
    
    /// Convenience function to log an Error in Error level.
    public static func log(
        error: Error,
        _file: String = #file, _function: String = #function, _line: Int = #line) {
        self.log(error: error.localizedDescription, _error: error, _file: _file, _function: _function, _line: _line)
    }
    
    /// Log message in Warning level.
    public static func log(
        warning message: CustomStringConvertible, _error: Error? = nil,
        _file: String = #file, _function: String = #function, _line: Int = #line) {
        if self._logLevel >= .warning {
            self.log("[!] \(message)".yellow, _error: _error, _file: _file, _function: _function, _line: _line)
        }
    }
    
    /// Convenience function to log an Error in Warning level.
    public static func log(
        warning error: Error,
        _file: String = #file, _function: String = #function, _line: Int = #line) {
        self.log(warning: error.localizedDescription, _error: error, _file: _file, _function: _function, _line: _line)
    }
    
    /// Log description in Important level.
    public static func log(
        important message: CustomStringConvertible,
        _file: String = #file, _function: String = #function, _line: Int = #line) {
        if self._logLevel >= .important {
            self.log("[*] \(message)".bold, _file: _file, _function: _function, _line: _line)
        }
    }
    
    /// Log description in Notice level.
    public static func log(
        notice message: CustomStringConvertible,
        _file: String = #file, _function: String = #function, _line: Int = #line) {
        if self._logLevel >= .notice {
            self.log("[!] \(message)", _file: _file, _function: _function, _line: _line)
        }
    }
    
    /// Log description in Success level.
    public static func log(
        success message: CustomStringConvertible,
        _file: String = #file, _function: String = #function, _line: Int = #line) {
        if self._logLevel >= .success {
            self.log("[*] \(message)".green, _file: _file, _function: _function, _line: _line)
        }
    }
    
    /// Log description in Info level.
    public static func log(
        action message: CustomStringConvertible,
        _file: String = #file, _function: String = #function, _line: Int = #line) {
        if self._logLevel >= .action {
            self.log("[*] \(message)", _file: _file, _function: _function, _line: _line)
        }
    }
    
    /// Log description in Info level.
    public static func log(
        info message: CustomStringConvertible,
        _file: String = #file, _function: String = #function, _line: Int = #line) {
        if self._logLevel >= .info {
            self.log("[ ] \(message)".white, _file: _file, _function: _function, _line: _line)
        }
    }
    
    /// Log description in Verbose level.
    public static func log(
        verbose message: CustomStringConvertible,
        _file: String = #file, _function: String = #function, _line: Int = #line) {
        if self._logLevel >= .verbose {
            self.log("[ ] \(message)".white, _file: _file, _function: _function, _line: _line)
        }
    }
    
    /// Log description in Debug level.
    public static func log(
        debug message: CustomStringConvertible,
        _file: String = #file, _function: String = #function, _line: Int = #line) {
        if self._logLevel >= .debug {
            self.log("[>] \(message)".white, _file: _file, _function: _function, _line: _line)
        }
    }
}

extension Logger {
    public static func log(
        condition: Bool, message: CustomStringConvertible,
        _file: String = #file, _function: String = #function, _line: Int = #line) {
        if condition {
            self.log(success: message, _file: _file, _function: _function, _line: _line)
        }
        else {
            self.log(warning: message, _file: _file, _function: _function, _line: _line)
        }
    }
}

extension Logger {
    @available(*, deprecated)
    public static func logEmptyLine() {
        if self._logLevel >= .error {
            self.log("")
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

#if !canImport(Rainbow)
extension String {
    var green: String { self }
    var red: String { self }
    var bold: String { self }
    var white: String { self }
    var yellow: String { self }
}
#endif
