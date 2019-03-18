//
//  DatabaseManager.swift
//  NextStation
//
//  Created by Jonathan Martins on 23/01/19.
//  Copyright © 2019 Jonathan Martins. All rights reserved.
//

import Foundation
import SQLite3

/// Types the possible SQLite errors
enum SQLiteError: Error {
    case OpenDatabase(message: String)
    case Prepare(message: String)
    case Step(message: String)
    case Bind(message: String)
}

class DatabaseManager {

    /// Singleton of the Database
    static let current = DatabaseManager()
    
    private let TABLE_PATH        = "Path"
    private let TABLE_LINE        = "Line"
    private let TABLE_STATION     = "Station"
    private let TABLE_TRANFERENCE = "Tranference"
    
    /// The pointer to perform the actions in the Database
    private var db: OpaquePointer?
    
    /// Parse the possible error messages
    private var errorMessage: String {
        if let errorPointer = sqlite3_errmsg(db) {
            let errorMessage = String(cString: errorPointer)
            return errorMessage
        } else {
            return "No error message provided from sqlite."
        }
    }
    
    init() {
        try! openDatabase()
    }
    
    deinit {
        if sqlite3_close_v2(db) == SQLITE_OK {
            print("Database was successfully closed")
        }else{
            print("Error closing database")
        }
    }
    
    /// Opens the SQLite database
    private func openDatabase() throws {
        do {
            let manager      = FileManager.default
            let documentsURL = try manager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent("subway.db")
            
            if !manager.fileExists(atPath: documentsURL.path){
                let bundleURL = Bundle.main.url(forResource: "subway", withExtension: "db")!
                try manager.copyItem(at: bundleURL, to: documentsURL)
            }
            if sqlite3_open_v2(documentsURL.path, &db, SQLITE_OPEN_READONLY, nil) == SQLITE_OK {
                print("Database successfully opened")
            }
            else{
                defer {
                    if db != nil {
                        sqlite3_close(db)
                    }
                }
                
                if let errorPointer = sqlite3_errmsg(db) {
                    let message = String.init(cString: errorPointer)
                    throw SQLiteError.OpenDatabase(message: message)
                } else {
                    throw SQLiteError.OpenDatabase(message: "No error message provided from sqlite.")
                }
            }
        } catch {
            throw SQLiteError.OpenDatabase(message: "Error traying to copy database.")
        }
    }

//    private func isNewVersion()->Bool{
//
//        let current    = "1.0"
//        let newVersion = "1.0"
//
//        let versionCompare = current.compare(newVersion, options: .numeric)
//        return versionCompare == .orderedSame ? false:true
//    }

    /// Prepares the pointer to execute a given query
    private func prepareStatement(sql:String) throws -> OpaquePointer?{
        var statement:OpaquePointer? = nil
        guard sqlite3_prepare_v2(db, sql, -1, &statement, nil) == SQLITE_OK else{
             throw SQLiteError.Prepare(message: errorMessage)
        }
        return statement
    }
    
    /// Selects a specific line or all lines, if no index is passed
    func selectLines(number:Int?=nil) throws -> [Line]{
        var query = "select LineId, Company, AverageTimeBetweenStations from \(TABLE_LINE)"
        if let number = number{
            query = "\(query) where lineId = \(number)"
        }

        let statement = try prepareStatement(sql: query)
        defer {
            sqlite3_finalize(statement)
        }

        var lines:[Line] = []
        while(sqlite3_step(statement) == SQLITE_ROW){
            let number      = Int(sqlite3_column_int(statement, 0))
            let company     = String(cString: sqlite3_column_text(statement, 1))
            let averageTime = Double(sqlite3_column_double(statement, 2))
            let stations    = try selectStations(line:number)
            let path        = try selectPathFrom(line:number)

            lines.append(Line(number, company, path, stations, averageTime))
        }
        
        return lines
    }
    
    /// Selects the stations of a line, if an index is passed, or all stations, if no index is passed
    func selectStations(line number:Int?=nil) throws -> [Station]{
        var query = "select StationId, Number, Name, Latitude, Longitude, Address, LineId from \(TABLE_STATION)"
        if let number = number{
            query = "\(query) where lineId = \(number) order by Number"
        }
        let statement = try prepareStatement(sql: query)
        defer {
            sqlite3_finalize(statement)
        }

        var stations:[Station] = []
        while(sqlite3_step(statement) == SQLITE_ROW){
            let id           = Int(sqlite3_column_int(statement, 0))
            let order        = Int(sqlite3_column_int(statement, 1))
            let name         = String(cString: sqlite3_column_text(statement, 2))
            let latitude     = sqlite3_column_double(statement, 3)
            let longitude    = sqlite3_column_double(statement, 4)
            let address      = String(cString: sqlite3_column_text(statement, 5))
            let lineId       = Int(sqlite3_column_int(statement, 6))
            let tranferences = try selectTranferencesFrom(station: id)
        
            stations.append(Station(id, lineId, order, name, address, latitude, longitude, tranferences))
        }
        return stations
    }
    
    /// Selects the tranferences of the passed station id
    func selectTranferencesFrom(station id:Int) throws -> [Station]{

        let statement = try prepareStatement(sql: "select Tranference.ToStationId, Tranference.LineId from \(TABLE_STATION) inner join \(TABLE_TRANFERENCE) on Station.StationId = Tranference.FromStationId where Tranference.FromStationId = \(id)")
        defer {
            sqlite3_finalize(statement)
        }

        var tranferences:[Station] = []
        while(sqlite3_step(statement) == SQLITE_ROW){
            let id           = Int(sqlite3_column_int(statement, 0))
            let lineId       = Int(sqlite3_column_int(statement, 1))
            
            tranferences.append(Station(id, lineId, 0, "", "", 0.0, 0.0, []))
        }
 
        return tranferences
    }
    
    /// Selects the path coordinates of a passed line index
    func selectPathFrom(line number:Int) throws -> [Path]{
        
        let statement = try prepareStatement(sql: "select Latitude, Longitude from \(TABLE_PATH) where lineId = \(number)")
        defer {
            sqlite3_finalize(statement)
        }

        var path:[Path] = []
        while(sqlite3_step(statement) == SQLITE_ROW){
            let latitude  = sqlite3_column_double(statement, 0)
            let longitude = sqlite3_column_double(statement, 1)
            
            path.append(Path(latitude, longitude))
        }
        
        return path
    }
}
