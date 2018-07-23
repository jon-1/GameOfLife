//
//  ViewController.swift
//  GameOfLife
//
//  Created by Jon Michael on 7/18/18.
//  Copyright © 2018 Jon Michael. All rights reserved.
//

import UIKit

class ViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    // MARK: - Properties
    
    @IBOutlet weak var cycleLabel: UILabel!
    
    private var count = 0 {
        didSet {
            cycleLabel.text = "\(count)"
        }
    }
    
    private var gameState = GameState()
    private var timer = Timer()
    private var color = UIColor.black
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(cycleLabel)
        cycleLabel.frame.origin = CGPoint(x: 30, y: 30)
        cycleLabel.alpha = 0.5
        collectionView?.register(LifeCell.self, forCellWithReuseIdentifier: LifeCell.reuseIdentifier)
        collectionView?.reloadData()
        reset()
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(reset)))
    }
    
    // MARK: - UICollectionView
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: LifeCell.reuseIdentifier, for: indexPath) as? LifeCell else { fatalError() }
        let index = (row: (indexPath.row / gameState.grid[0].count), column: Int(indexPath.row % gameState.grid[0].count))
        if gameState.grid[index.row][index.column] == 1 {
            cell.backgroundColor = color
        } else {
            cell.backgroundColor = .clear
        }
        cell.layer.cornerRadius = cell.frame.width/2
        return cell
    }

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return gameState.gridCount
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let rect = collectionView.bounds
        let cellWidth = rect.width/CGFloat(gameState.grid[0].count)
        return CGSize(width: cellWidth, height: cellWidth)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

    
    // MARK: - Updating state
    
    func scheduledTimerWithTimeInterval(){
        timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(self.updateState), userInfo: nil, repeats: true)
    }
    
    @objc func updateState() {
        count += 1
        DispatchQueue.global().async { [unowned self] in
            self.gameState.refresh()
        }
        
        DispatchQueue.main.async {
            self.collectionView?.reloadData()
        }
    }
    
    @objc func reset() {
        count = 0
        timer.invalidate()
        var newGrid = gameState.grid
        for i in 0..<gameState.grid.count {
            for j in 0..<gameState.grid[i].count {
                newGrid[i][j] = arc4random() % 5 == 0 ? 1 : 0
            }
        }
        gameState.grid = newGrid
        color = UIColor.random()
        scheduledTimerWithTimeInterval()
    }
}
