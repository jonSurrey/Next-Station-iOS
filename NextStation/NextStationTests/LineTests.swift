//
//  LineTests.swift
//  NextStationTests
//
//  Created by Jonathan Martins on 14/03/19.
//  Copyright © 2019 Jonathan Martins. All rights reserved.
//

import XCTest
@testable import NextStation

class LineTests: XCTestCase {

    let lines = [(number:1 ,colour:"Azul"),
                 (number:2  ,colour:"Verde"),
                 (number:3  ,colour:"Vermelha"),
                 (number:4  ,colour:"Amarela"),
                 (number:5  ,colour:"Lilás"),
                 (number:7  ,colour:"Rubi"),
                 (number:8  ,colour:"Diamante"),
                 (number:9  ,colour:"Esmeralda"),
                 (number:10 ,colour:"Turquesa"),
                 (number:11 ,colour:"Coral"),
                 (number:12 ,colour:"Safira"),
                 (number:13 ,colour:"Jade"),
                 (number:15 ,colour:"Prata")]
    
    func testLineColoursAreAccordingToTheNumbers() {
        for line in lines{
            let number              = line.number
            let colour              = line.colour
            let colourBelongsToLine = isNumber(number, equalToColour: colour)
            
            XCTAssertTrue(colourBelongsToLine, "The colour \(colour) does not belong to line \(number)")
        }
    }
    
    func testParseLastUpdateTime() {
        var line = Line(1)
        line.lastUpdate = "2019-03-14T16:16:55"
        
        XCTAssertEqual(line.lastUpdate, "14/03/2019 - 16:16", "The given date does not match the expected result")
    }
    
    private func isNumber(_ number:Int, equalToColour colour:String)->Bool{
        let line = Line(number)
        return line.colourName.elementsEqual(colour)
    }
}
