//
//  Tetromino.swift
//  Tetris
//
//  Created by Ilija Tovilo on 25/12/14.
//  Copyright (c) 2014 Ilija Tovilo. All rights reserved.
//

import Foundation

/// A Tetrimino is a shape in Tetris that has exactly 4 tiles
class Tetromino {

    /// The root tile that holds all other
    let rootTile: Tile
    
    /// Designated initializer
    required init(tiles: [Tile]) {
        rootTile = Tile(localCoordinates: TileCoordinates(x: 0, y: 0))
        
        for tile in tiles {
            rootTile.addSubTile(tile)
        }
    }
    
    /// Rotates the tetromino
    func rotate() {
        for tile in rootTile.subTiles {
            tile.localCoordinates = TileCoordinates(
                x: 4 - tile.localCoordinates.y - 1,
                y: tile.localCoordinates.x
            )
        }
    }
}
