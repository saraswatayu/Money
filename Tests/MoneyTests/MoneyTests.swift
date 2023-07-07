import XCTest
import Foundation
@testable import Money

final class MoneyTests: XCTestCase {
    func testMonetaryCalculations() {
        let prices: [Money<USD>] = [2.19, 5.39, 20.99, 2.99, 1.99, 1.99, 0.99]
        let subtotal = prices.reduce(0.00, +)
        let tax = 0.08 * subtotal
        let total = subtotal + tax
        
        XCTAssertEqual(subtotal.amount, Decimal(string: "36.53", locale: nil))
        XCTAssertEqual(tax.amount, Decimal(string: "2.92", locale: nil))
        XCTAssertEqual(total.amount, Decimal(string: "39.45", locale: nil))
    }

    func testMinorUnits() {
        let twoCents = Money<USD>(minorUnits: 2) // $0.02
        XCTAssertEqual(twoCents.amount, Decimal(string: "0.02", locale: nil))

        let ichimonEn = Money<JPY>(minorUnits: 10_000) // ¥10,000
        XCTAssertEqual(ichimonEn.amount, Decimal(string: "10000", locale: nil))
    }
    
    func testDistributedEvenly() {
        let tenDollars = Money<USD>(10)
        
        let evenSplits = tenDollars.distributedEvenly(intoParts: 5)
        XCTAssertEqual(evenSplits, [Money<USD>(2), Money<USD>(2), Money<USD>(2), Money<USD>(2), Money<USD>(2)])
        
        let unevenSplits = tenDollars.distributedEvenly(intoParts: 6)
        XCTAssertEqual(unevenSplits, [Money<USD>(1.67), Money<USD>(1.67), Money<USD>(1.67), Money<USD>(1.67), Money<USD>(1.66), Money<USD>(1.66)])
        
        let proportionalSplits = tenDollars.distributedProportionally(between: [5, 2])
        XCTAssertEqual(proportionalSplits, [Money<USD>(2.86), Money<USD>(7.14)])
    }

    static var allTests = [
        ("testMonetaryCalculations", testMonetaryCalculations),
        ("testMinorUnits", testMinorUnits),
    ]
}
