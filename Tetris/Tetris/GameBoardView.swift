//
//  GameBoardView.swift
//  Tetris
//
//  Created by Ilija Tovilo on 25/12/14.
//  Copyright (c) 2014 Ilija Tovilo. All rights reserved.
//

import UIKit

class GameBoardView: UIView, GameDelegate {
    
    /// An instance of a game
    let game = Game()
    
    /// The timer that calls step() on the game instance
    var timer: NSTimer!
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        // Set the game delegate
        game.delegate = self
        
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
        NSRunLoop.mainRunLoop().addTimer(timer, forMode: NSDefaultRunLoopMode)
    }
    
    deinit {
        timer.invalidate()
    }
    
    /// Moves the current tetromino one row down
    func step() {
        game.step()
        setNeedsDisplay()
    }
    
    
    // MARK: - GameDelegate -
    
    /// Called when the game is over
    func gameOver() {
        println("Game over!")
    }
    
    
    // MARK: - Rendering -
    
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
                _drawTile(tile)
            }
        }
        
        for (x, y, tile) in game.grid {
            if let unwrappedTile = tile {
                _drawTile(unwrappedTile)
            }
        }
    }
    
    /// Draws a tile
    func _drawTile(tile: Tile) {
        (tile.color ?? UIColor(white: 0.0, alpha: 1.0)).set()
        UIRectFill(rectOfTileCoordinates(tile.worldCoordinates))
    }
    
    
    // MARK: - Gestures -
    
    var deltaXCoordinate: Float?
    
    /// Called for manual handling of touches
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        if touches.count == 1 {
            let initialTouchPosition = touches.allObjects[0].locationInView(self)
            let tetrominoXCoord = rectOfTileCoordinates(game.currentTetromino!.rootTile.worldCoordinates)
            deltaXCoordinate = Float(tetrominoXCoord.origin.x - initialTouchPosition.x)
        }
    }
    
    /// Called when a touch moved
    override func touchesMoved(touches: NSSet, withEvent event: UIEvent) {
        if touches.count == 1 {
            let touchPosition = touches.allObjects[0].locationInView(self)
            let xCoordinate = xCoordinateForPoint(Float(touchPosition.x) + deltaXCoordinate!)
            game.setXCoordinateForCurrentTetromino(xCoordinate)
        }
        
        setNeedsDisplay()
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
    
    
    // MARK: - Helpers -
    
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
        return result
    }
    
    /// Calculates the size of a single tile
    func sizeOfTile() -> CGSize {
        let size = fminf(Float(bounds.size.width) / Float(game.grid.width), Float(bounds.size.height) / Float(game.grid.height))
        
        return CGSize(
            width: CGFloat(size),
            height: CGFloat(size)
        )
    }
}
