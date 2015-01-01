//
//  Tile.swift
//  Tetris
//
//  Created by Ilija Tovilo on 25/12/14.
//  Copyright (c) 2014 Ilija Tovilo. All rights reserved.
//

import UIKit

/// Represent the 2d coordinates of a tile
typealias TileCoordinates = (x: Int, y: Int)

/// Class that represents a single cell in Tetrix
class Tile: Equatable {
    
    /// The parent tiles
    weak var parentTile: Tile?
    
    /// The children of the tile
    private(set) var subTiles: [Tile] = []
    
    /// The color that the tile is rendered in
    var color: UIColor?
    
    /// The coordinates the tile is currently positioned in
    var localCoordinates: TileCoordinates
    
    /// Calculates the world coordinates of the tile
    var worldCoordinates: TileCoordinates {
        let parentX = parentTile != nil ? parentTile!.worldCoordinates.x : 0
        let parentY = parentTile != nil ? parentTile!.worldCoordinates.y : 0
        
        return TileCoordinates(
            x: parentX + localCoordinates.x,
            y: parentY + localCoordinates.y
        )
    }
    
    /// The designated initializer
    required init(localCoordinates: TileCoordinates) {
        self.localCoordinates = localCoordinates
    }
    
    /// Adds the tile as a sub tile
    func addSubTile(tile: Tile) {
        tile.parentTile = self
        subTiles.append(tile)
    }
    
    /// Removes the tile from the children
    func removeSubTile(tile: Tile) {
        tile.parentTile = nil
        subTiles.removeElement(tile)
    }
    
}


// MARK: - Equatable -

/// Tiles are only equal if they're the exact same object
func ==(lhs: Tile, rhs: Tile) -> Bool {
    return lhs === rhs
}
