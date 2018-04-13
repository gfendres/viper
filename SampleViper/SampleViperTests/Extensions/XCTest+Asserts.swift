import Foundation
import XCTest

enum TestError: Error {
    case objectNotFound
}

extension XCTest {
    func AssertNotNil<T>(_ element: T?) throws ->  T {
        guard let element = element else {
            XCTFail("fail", file: #file, line: #line)
            throw TestError.objectNotFound
        }
        return element
    }
}