//
//  ViewController.swift
//  Cat
//
//  Created by Deekshith Bellare on 04/08/20.
//  Copyright © 2020 Deekshith Bellare. All rights reserved.
//

import UIKit

//Displays cats which can be favorited/unfavorited
class CatsViewController: UIViewController {
    
    var coordinator:MainCoordinator?
    private var viewModel = CatsViewModel()
    @IBOutlet weak var catsCollectionView: UICollectionView!
    
    @IBOutlet weak var viewFavouritesButton: UIBarButtonItem!
    enum Section {
        case catSectoon
    }
    
    private var dataSource: UICollectionViewDiffableDataSource<Section, Cat>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "cat_Cats".localized
        viewFavouritesButton.title = "cat_Favs".localized
        configureCollectionView()
        configureDataSource()
        viewModel.fetchRandomCats { [weak self](error) in
            guard let self = self else {return}
            if let _ = error {
                //Todo: Show error
                
            }
            self.configureDataSource()
        }
    }
    
    @IBAction func favoriteTapped(_ sender: Any) {
        coordinator?.showFavourites()
    }
}

// MARK: - UI
extension CatsViewController {
    func configureCollectionView() {
        catsCollectionView.collectionViewLayout = generateLayout()
        catsCollectionView.delegate = self
        catsCollectionView.register(CatCollectionViewCell.self, forCellWithReuseIdentifier: CatCollectionViewCell.reuseIdentifer)
    }
    
    func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource
            <Section, Cat>(collectionView: catsCollectionView) {
                (collectionView: UICollectionView, indexPath: IndexPath, detailItem: Cat) -> UICollectionViewCell? in
                guard let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: CatCollectionViewCell.reuseIdentifer,
                    for: indexPath) as? CatCollectionViewCell else { fatalError("Could not create new cell") }
                cell.delegate = self
                cell.photoURL = detailItem.url
                let isFavorited = self.viewModel.isFavorited(detailItem)
                cell.configure(isFavorited: isFavorited)
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
                heightDimension: .fractionalWidth(2/3)))
        fullPhotoItem.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)
        
        // Main with pair
        let mainItem = NSCollectionLayoutItem(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(2/3),
                heightDimension: .fractionalHeight(1.0)))
        mainItem.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)
        
        let pairItem = NSCollectionLayoutItem(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .fractionalHeight(0.5)))
        pairItem.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)
        let trailingGroup = NSCollectionLayoutGroup.vertical(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1/3),
                heightDimension: .fractionalHeight(1.0)),
            subitem: pairItem,
            count: 2)
        
        let mainWithPairGroup = NSCollectionLayoutGroup.horizontal(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .fractionalWidth(4/9)),
            subitems: [mainItem, trailingGroup])
        
        // Triplet
        let tripletItem = NSCollectionLayoutItem(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1/3),
                heightDimension: .fractionalHeight(1.0)))
        tripletItem.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)
        
        let tripletGroup = NSCollectionLayoutGroup.horizontal(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .fractionalWidth(2/9)),
            subitems: [tripletItem, tripletItem, tripletItem])
        
        // Reversed main with pair
        let mainWithPairReversedGroup = NSCollectionLayoutGroup.horizontal(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .fractionalWidth(4/9)),
            subitems: [trailingGroup, mainItem])
        
        let nestedGroup = NSCollectionLayoutGroup.vertical(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .fractionalWidth(16/9)),
            subitems: [fullPhotoItem, mainWithPairGroup, tripletGroup, mainWithPairReversedGroup])
        
        let section = NSCollectionLayoutSection(group: nestedGroup)
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
    
    func snapshotForCurrentState() -> NSDiffableDataSourceSnapshot<Section, Cat> {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Cat>()
        snapshot.appendSections([Section.catSectoon])
        if let items = self.viewModel.cats {
            snapshot.appendItems(items)
        }
        return snapshot
    }
}

extension CatsViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let cat = viewModel.cat(at: indexPath) {
        coordinator?.showCat(cat)
        }
    }
}

extension CatsViewController:CatCollectionViewCellDelegate {
    func favoriteTap(at cell:CatCollectionViewCell,isFavorited:Bool) {
        if let indexPath = catsCollectionView.indexPath(for: cell),
            let cat = self.viewModel.cat(at: indexPath) {
            self.viewModel.favourite(cat, isFavourited: isFavorited)
        }
    }
}


