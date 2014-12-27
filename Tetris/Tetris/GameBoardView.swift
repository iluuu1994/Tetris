//
//  GameBoardView.swift
//  Tetris
//
//  Created by Ilija Tovilo on 25/12/14.
//  Copyright (c) 2014 Ilija Tovilo. All rights reserved.
//

import UIKit

class GameBoardView: UIView {
    
    /// An instance of a game
    let game = Game()
    
    /// The timer that calls step() on the game instance
    var timer: NSTimer?
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        // Pan
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: "panGesture:")
        addGestureRecognizer(panGestureRecognizer)
        
        // Swipe down
        let swipeRecognizer = UISwipeGestureRecognizer(target: self, action: "swipeGesture:")
        swipeRecognizer.direction = UISwipeGestureRecognizerDirection.Down
        addGestureRecognizer(swipeRecognizer)
        
        // Tap
        let singleTapRecognizer = UITapGestureRecognizer(target: self, action: "tapGesture:")
        addGestureRecognizer(singleTapRecognizer)
        
        // Double Tap
        let doubleTapRecognizer = UITapGestureRecognizer(target: self, action: "doubleTapGesture:")
        doubleTapRecognizer.numberOfTouchesRequired = 2
        addGestureRecognizer(doubleTapRecognizer)
        
        // Start the timer
        timer = NSTimer(timeInterval: 1, target: self, selector: "step", userInfo: nil, repeats: true)
        NSRunLoop.mainRunLoop().addTimer(timer!, forMode: NSDefaultRunLoopMode)
    }
    
    /// Debug draw all tiles
    override func drawRect(rect: CGRect) {
        for x in 0..<game.grid.width {
            for y in 0..<game.grid.height {
                UIColor(white: 0.95, alpha: 1.0).set()
                UIRectFill(rectOfTileCoordinates((x, y)))
            }
        }
        
        if let tetromino = game.currentTetromino {
            for tile in tetromino.rootTile.subTiles {
                UIColor(white: 0.0, alpha: 1.0).set()
                UIRectFill(rectOfTileCoordinates(tile.worldCoordinates))
            }
        }
        
        for (x, y, tile) in game.grid {
            UIColor(white: 0.0, alpha: 1.0).set()
            if let unwrappedTile = tile {
                UIColor(white: 0.0, alpha: 1.0).set()
                UIRectFill(rectOfTileCoordinates(unwrappedTile.worldCoordinates))
            }
        }
    }
    
    /// Gets the rect of tile coordinates
    func rectOfTileCoordinates(tileCoordinates: TileCoordinates) -> CGRect {
        let size = sizeOfTile()
        
        return CGRectInset(CGRect(
            x: CGFloat(size.width) * CGFloat(tileCoordinates.x),
            y: CGFloat(size.height) * CGFloat(tileCoordinates.y),
            width: CGFloat(size.width),
            height: CGFloat(size.height)
        ), 1, 1)
    }
    
    /// Calculates the x tile coordinate for a pixel coordinate
    func xCoordinateForPoint(xPixelCoordinate: Float) -> Int {
        let result = Int(ceilf(xPixelCoordinate / Float(sizeOfTile().width)))
        return max(min(result, game.grid.width), 0)
    }
    
    /// Calculates the size of a single tile
    func sizeOfTile() -> CGSize {
        let size = fminf(Float(bounds.size.width) / Float(game.grid.width), Float(bounds.size.height) / Float(game.grid.height))
        
        return CGSize(
            width: CGFloat(size),
            height: CGFloat(size)
        )
    }
    
    /// Called when we swipe down
    func swipeGesture(gestureRecognizer: UISwipeGestureRecognizer) {
        game.drop()
        setNeedsDisplay()
    }
    
    func doubleTapGesture(gestureRecognizer: UITapGestureRecognizer) {
        game.drop()
        setNeedsDisplay()
    }
    
    /// Called when we tap the view
    func tapGesture(gestureRecognizer: UITapGestureRecognizer) {
        game.rotate()
        setNeedsDisplay()
    }
    
    /// Called when we pan
    func panGesture(gestureRecognizer: UIPanGestureRecognizer) {
        let point = gestureRecognizer.translationInView(self)
        game.setXCoordinateForCurrentTetromino(xCoordinateForPoint(Float(point.x)))
        setNeedsDisplay()
    }
    
    /// Moves the current tetromino one row down
    func step() {
        game.step()
        setNeedsDisplay()
    }
}
