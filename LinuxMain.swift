//
//  LinuxMain.swift
//  AppTests
//
//  Created by Katherine Ebel on 10/27/18.
//

import XCTest

@testable import AppTests

XCTMain([
  testCase(AcronymTests.allTests),
  testCase(CategoryTests.allTests),
  testCase(UserTests.allTests)
])
