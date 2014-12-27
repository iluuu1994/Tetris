//
//  Game.swift
//  Tetris
//
//  Created by Ilija Tovilo on 25/12/14.
//  Copyright (c) 2014 Ilija Tovilo. All rights reserved.
//

import Foundation

enum Direction {
    case Left;
    case Right;
}

class Game {

    /// The grid that stores all 
    let grid = Matrix<Tile?>(width: 10, height: 30, repeatedValue: nil)
    
    /// The current Tetromino controlled by the user
    var currentTetromino: Tetromino?
    
    init() {
        spawnRandomTetromino()
    }
    
    
    
    // MARK: - Actions -
    
    /// Check if there are any full rows and deletes them
    func checkFullRows() {
        var fullRows = 0
        
        for var y = grid.height - 1; y >= 0; y-- {
            var fullRow = true
            
            for var x = 0; x < grid.width; x++ {
                grid[x, y] = y - fullRows >= 0 ? grid[x, y - fullRows] : nil
                if grid[x, y] == nil { fullRow = false }
            }
            
            if fullRow {
                fullRows++
                // Repeat the current row
                y++
            }
        }
        
        // Update coordinates
        for (x, y, tile) in grid {
            tile?.localCoordinates = (x, y)
        }
    }
    
    /// Detaches the tiles of current tetromino
    func detachTilesOfTetromino() {
        if let unwrappedCurrentTetromino = currentTetromino {
            for tile in unwrappedCurrentTetromino.rootTile.subTiles {
                let worldCoordinates = tile.worldCoordinates
                unwrappedCurrentTetromino.rootTile.removeSubTile(tile)
                tile.localCoordinates = worldCoordinates
                grid[worldCoordinates.x, worldCoordinates.y] = tile
            }
            
            checkFullRows()
        }
    }
    
    /// Drops the current Tetromino
    func drop() {
        let tetromino = currentTetromino
        
        // Step until the current tetronimo changes
        while currentTetromino === tetromino {
            step()
        }
    }
    
    /// Rotates the current Tetromino
    func rotate() {
        currentTetromino?.rotate()
        
        if findCollisions() { unrotate() }
    }
    
    /// Undoes the last rotation
    func unrotate() {
        // Just rotate three times :P
        for i in 0..<3 { currentTetromino?.rotate() }
    }
    
    /// Moves the current tetromino one row down
    func step() {
        currentTetromino?.rootTile.localCoordinates.y++
        
        if findCollisions() {
            unstep()
            detachTilesOfTetromino()
            spawnRandomTetromino()
        }
    }
    
    /// Reverses the last step
    func unstep() {
        currentTetromino?.rootTile.localCoordinates.y--
    }
    
    /// Detects collisions between the current tetromino and the tiles
    /// Returns true if collisions are found
    func findCollisions() -> Bool {
        if let unwrappedCurrentTetromino = currentTetromino {
            // Map the world coordinates of the root tile
            let tetrominoWorldCoordinates = unwrappedCurrentTetromino.rootTile.subTiles.map { (tile: Tile) -> TileCoordinates in
                return tile.worldCoordinates
            }
            
            for (x, y) in tetrominoWorldCoordinates {
                // x bounds check
                if x < 0 || x >= grid.width { return true }
                // y bounds check
                if y < 0 || y >= grid.height { return true }
                // Check the grid to find collisions
                if grid[x, y] != nil { return true }
            }
        }
        
        return false
    }
    
    
    // MARK: - Methods -
    
    /// Spawn a random tetromino
    func spawnRandomTetromino() {
        currentTetromino = randomTetromino()
    }
    
    /// Generates a random tetromino
    func randomTetromino() -> Tetromino {
        var tiles: [Tile]!
        
        switch arc4random_uniform(7) {
        case 0:
            //
            //  [ ][ ]
            //  [ ][ ]
            //
            tiles = [
                Tile(localCoordinates: (x: 0, y: 0)),
                Tile(localCoordinates: (x: 1, y: 0)),
                Tile(localCoordinates: (x: 0, y: 1)),
                Tile(localCoordinates: (x: 1, y: 1)),
            ];
        case 1:
            //
            //  [ ]
            //  [ ]
            //  [ ]
            //  [ ]
            //
            tiles = [
                Tile(localCoordinates: (x: 0, y: 0)),
                Tile(localCoordinates: (x: 1, y: 0)),
                Tile(localCoordinates: (x: 2, y: 0)),
                Tile(localCoordinates: (x: 3, y: 0)),
            ];
        case 2:
            //
            //  [ ]
            //  [ ]
            //  [ ][ ]
            //
            tiles = [
                Tile(localCoordinates: (x: 0, y: 0)),
                Tile(localCoordinates: (x: 0, y: 1)),
                Tile(localCoordinates: (x: 0, y: 2)),
                Tile(localCoordinates: (x: 1, y: 2)),
            ];
        case 3:
            //
            //  [ ][ ]
            //  [ ]
            //  [ ]
            //
            tiles = [
                Tile(localCoordinates: (x: 0, y: 0)),
                Tile(localCoordinates: (x: 1, y: 0)),
                Tile(localCoordinates: (x: 0, y: 1)),
                Tile(localCoordinates: (x: 0, y: 2)),
            ];
        case 4:
            //
            //  [ ]
            //  [ ][ ]
            //  [ ]
            //
            tiles = [
                Tile(localCoordinates: (x: 0, y: 0)),
                Tile(localCoordinates: (x: 0, y: 1)),
                Tile(localCoordinates: (x: 1, y: 1)),
                Tile(localCoordinates: (x: 0, y: 2)),
            ];
        case 5:
            //
            //  [ ]
            //  [ ][ ]
            //     [ ]
            //
            tiles = [
                Tile(localCoordinates: (x: 0, y: 0)),
                Tile(localCoordinates: (x: 0, y: 1)),
                Tile(localCoordinates: (x: 1, y: 1)),
                Tile(localCoordinates: (x: 1, y: 2)),
            ];
        case 6:
            //
            //     [ ]
            //  [ ][ ]
            //  [ ]
            //
            tiles = [
                Tile(localCoordinates: (x: 1, y: 0)),
                Tile(localCoordinates: (x: 1, y: 1)),
                Tile(localCoordinates: (x: 0, y: 1)),
                Tile(localCoordinates: (x: 0, y: 2)),
            ];
        default:
            break
        }
        
        return Tetromino(tiles: tiles)
    }
    
    /// Sets the x coordinate of the current tetromino
    func setXCoordinateForCurrentTetromino(xCoordinate: Int) {
        if let unwrappedTetromino = currentTetromino {
            let oldXCoordinate = unwrappedTetromino.rootTile.worldCoordinates.x
            let moveBy = xCoordinate - oldXCoordinate
            for i in 0..<abs(moveBy) {
                move(moveBy < 0 ? .Left : .Right)
            }
        }
    }
    
    /// Moves the current tetromino to the left or right
    func move(direction: Direction) -> Bool {
        // Calculate x delta
        let deltaX = direction == .Left ? -1 : 1
        // Move
        currentTetromino?.rootTile.localCoordinates.x += deltaX
        // Check for collisions
        let collided = findCollisions()
        // Unmove if there was a collision
        if collided { currentTetromino?.rootTile.localCoordinates.x -= deltaX }
        // Return the collision result
        return collided
    }
    
}
