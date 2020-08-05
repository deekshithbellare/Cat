//
//  FavouritesViewController.swift
//  Cat
//
//  Created by Deekshith Bellare on 04/08/20.
//  Copyright © 2020 Deekshith Bellare. All rights reserved.
//

import UIKit

class FavouritesViewController: UIViewController {
    private var viewModel = FavouriteViewModel()
    @IBOutlet weak var catsCollectionView: UICollectionView!
    
    enum Section {
        case catSectoon
    }
    
    private var dataSource: UICollectionViewDiffableDataSource<Section, Cat>!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Favourites"
        configureCollectionView()
        configureDataSource()
        // Do any additional setup after loading the view.
    }
    
}

// MARK: - UI
extension FavouritesViewController {
    func configureCollectionView() {
        catsCollectionView.collectionViewLayout = generateLayout()
        catsCollectionView.register(CatCollectionViewCell.self, forCellWithReuseIdentifier: CatCollectionViewCell.reuseIdentifer)
    }
    
    func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource
            <Section, Cat>(collectionView: catsCollectionView) {
                (collectionView: UICollectionView, indexPath: IndexPath, detailItem: Cat) -> UICollectionViewCell? in
                guard let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: CatCollectionViewCell.reuseIdentifer,
                    for: indexPath) as? CatCollectionViewCell else { fatalError("Could not create new cell") }
                cell.photoURL = detailItem.url
                cell.configure(isFavorited: false,shouldHideFavButton:true)
                return cell
        }
        
        // load our initial data
        let snapshot = snapshotForCurrentState()
        dataSource.apply(snapshot, animatingDifferences: false)
    }
    
    func generateLayout() -> UICollectionViewLayout {
        // We have three row styles
        // Style 1: 'Full'
        // A full width photo
        // Style 2: 'Main with pair'
        // A 2/3 width photo with two 1/3 width photos stacked vertically
        // Style 3: 'Triplet'
        // Three 1/3 width photos stacked horizontally
        // Full
        // Full
        let fullPhotoItem = NSCollectionLayoutItem(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .fractionalWidth(0.5)))
        fullPhotoItem.contentInsets = NSDirectionalEdgeInsets(top:2, leading:5, bottom: 5, trailing: 5)
        
        
        
        let nestedGroup = NSCollectionLayoutGroup.vertical(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .fractionalWidth(0.5)),
            subitems: [fullPhotoItem])
        
        let section = NSCollectionLayoutSection(group: nestedGroup)
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
    
    func snapshotForCurrentState() -> NSDiffableDataSourceSnapshot<Section, Cat> {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Cat>()
        snapshot.appendSections([Section.catSectoon])
        snapshot.appendItems(self.viewModel.favouriteCats)
        return snapshot
    }
}

