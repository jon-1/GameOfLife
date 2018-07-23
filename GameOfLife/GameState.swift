//
//  GameState.swift
//  GameOfLife
//
//  Created by Jon Michael on 7/23/18.
//  Copyright © 2018 Jon Michael. All rights reserved.
//

import Foundation

class GameState {
    
    // MARK: - Properties
    
    var grid: [[Int]] = Array<[Int]>(repeating: Array<Int>(repeating: 0, count: 20), count: 32)
    
    var gridCount: Int {
        return grid.count * grid[0].count
    }
    
    func refresh() {
        var newGrid = grid
        for i in 0..<grid.count {
            for j in 0..<grid[i].count {
                let liveN = liveNeighborsAtIndex(row: i, column: j)
                
                if grid[i][j] == 1 {
                    if liveN < 2 || liveN > 3 {
                        newGrid[i][j] = 0
                    }
                } else {
                    if liveN == 3 {
                        newGrid[i][j] = 1
                    }
                }
                
            }
        }
        self.grid = newGrid
    }
    
    private func liveNeighborsAtIndex(row: Int, column: Int) -> Int {
        typealias Location = (row: Int, column: Int)
        
        var neighborsLive = 0
        let rowMax = grid.count
        let columnMax = grid[0].count
        let topLeft = (row: row - 1, column: column - 1)
        let topCenter = (row: row - 1, column: column)
        let topRight = (row: row - 1, column: column + 1)
        let left = (row: row, column: column - 1)
        let right = (row: row, column: column + 1)
        let bottomLeft = (row: row + 1, column: column - 1)
        let bottomCenter = (row: row + 1, column: column)
        let bottomRight = (row: row + 1, column: column + 1)
        let locations : [Location] = [topLeft, topCenter, topRight, left, right, bottomLeft, bottomRight, bottomCenter]
        
        for location in locations {
            guard location.row >= 0 && location.row < rowMax && location.column >= 0 && location.column < columnMax else { continue }
            if grid[location.row ][location.column] == 1 {
                neighborsLive += 1
            }
        }
        return neighborsLive
    }
}
