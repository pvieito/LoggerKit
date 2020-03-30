//
//  LoggerKitTests.swift
//  LoggerKitTests
//
//  Created by Pedro José Pereira Vieito on 24/11/2019.
//  Copyright © 2019 Pedro José Pereira Vieito. All rights reserved.
//

import Foundation
import XCTest
@testable import LoggerKit

class LoggerKitTests: XCTestCase {
    static let loggerTestMessage = "__TEST__"
    static var loggerMessages: [String] = []
    
    override func setUp() {
        Logger.logLevel = .debug
        Logger.logMode = .customLogger{ Self.loggerMessages.append($0) }
    }
    
    func testLogger() {
        for logLevel in Logger.LogLevel.allCases {
            Logger.logLevel = logLevel
            
            Self.loggerMessages.append(Self.loggerTestMessage)
            Logger.log(debug: "DEBUG")
            XCTAssertEqual(Self.loggerMessages.last, Logger.logLevel >= .debug ? "[>] DEBUG" : Self.loggerTestMessage)
            
            Self.loggerMessages.append(Self.loggerTestMessage)
            Logger.log(info: "INFO")
            XCTAssertEqual(Self.loggerMessages.last, Logger.logLevel >= .info ? "[ ] INFO" : Self.loggerTestMessage)
            
            Self.loggerMessages.append(Self.loggerTestMessage)
            Logger.log(success: "SUCCESS")
            XCTAssertEqual(Self.loggerMessages.last, Logger.logLevel >= .success ? "[*] SUCCESS" : Self.loggerTestMessage)
            
            Self.loggerMessages.append(Self.loggerTestMessage)
            Logger.log(notice: "NOTICE")
            XCTAssertEqual(Self.loggerMessages.last, Logger.logLevel >= .notice ? "[!] NOTICE" : Self.loggerTestMessage)
            
            Self.loggerMessages.append(Self.loggerTestMessage)
            Logger.log(important: "IMPORTANT")
            XCTAssertEqual(Self.loggerMessages.last, Logger.logLevel >= .important ? "[*] IMPORTANT" : Self.loggerTestMessage)
            
            Self.loggerMessages.append(Self.loggerTestMessage)
            Logger.log(warning: "WARNING")
            XCTAssertEqual(Self.loggerMessages.last, Logger.logLevel >= .warning ? "[!] WARNING" : Self.loggerTestMessage)
            
            Self.loggerMessages.append(Self.loggerTestMessage)
            Logger.log(error: "ERROR")
            XCTAssertEqual(Self.loggerMessages.last, Logger.logLevel >= .error ? "[x] ERROR" : Self.loggerTestMessage)
        }
    }
}
