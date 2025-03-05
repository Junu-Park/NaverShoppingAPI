//
//  ListCollectionViewController.swift
//  NaverShoppingAPI
//
//  Created by 박준우 on 2/26/25.
//

import UIKit

import SnapKit

private struct Wish: Hashable, Identifiable {
    let id: UUID = UUID()
    let name: String
    let price: Int = Int.random(in: 234567...890123)
}

final class ListCollectionViewController: CustomViewController {

    private enum PriceType: CaseIterable {
        case low
        case high
        case normal
    }
    
    private let collectionView: UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())
    private var diffableDataSource: UICollectionViewDiffableDataSource<PriceType, Wish>!
    
    private var wishList: [Wish] = [Wish(name: "아이폰"), Wish(name: "아이패드"),Wish(name: "아이폰"), Wish(name: "아이패드"), Wish(name: "아이폰"), Wish(name: "아이패드")]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.configureCollectionViewLayout()
        self.configureCollectionViewDelegate()
        self.configureDiffableDataSource()
        self.updateSnapshot()
    }
    override func configureHierarchy() {
        self.view.addSubview(self.collectionView)
    }
    override func configureLayout() {
        self.collectionView.snp.makeConstraints { make in
            make.edges.equalTo(self.view.safeAreaLayoutGuide)
        }
    }
    override func configureView() {
        self.navigationItem.searchController = CustomSearchController(searchResultsController: nil)
        self.navigationItem.searchController?.searchBar.searchTextField.textColor = UIColor.white
        self.navigationItem.hidesSearchBarWhenScrolling = false
        self.navigationItem.searchController?.searchBar.delegate = self
    }
    private func configureCollectionViewLayout() {
        let layoutListConfiguration = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
        let layout = UICollectionViewCompositionalLayout.list(using: layoutListConfiguration)
        
        self.collectionView.collectionViewLayout = layout
    }
    private func configureCollectionViewDelegate() {
        self.collectionView.delegate = self
    }
    private func configureDiffableDataSource() {
        let cellRegistration = UICollectionView.CellRegistration<UICollectionViewCell, Wish> { cell, indexPath, itemIdentifier in
            var listContentConfiguration = UIListContentConfiguration.valueCell()
            listContentConfiguration.text = itemIdentifier.name
            listContentConfiguration.secondaryText = "₩\(itemIdentifier.price.formatted())"
            cell.contentConfiguration = listContentConfiguration
            
            var backgroundConfiguration = UIBackgroundConfiguration.listGroupedCell()
            backgroundConfiguration.backgroundColor = .systemBrown
            backgroundConfiguration.cornerRadius = 10
            backgroundConfiguration.strokeColor = .systemRed
            backgroundConfiguration.strokeWidth = 2
            cell.backgroundConfiguration = backgroundConfiguration
        }
        
        self.diffableDataSource = UICollectionViewDiffableDataSource(collectionView: self.collectionView) { collectionView, indexPath, itemIdentifier in
            let cell = collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: itemIdentifier)
            return cell
        }
    }
    private func updateSnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<PriceType, Wish>()
        
        snapshot.appendSections(PriceType.allCases)
        
        for wish in self.wishList {
            switch wish.price {
            case 234567..<500000:
                snapshot.appendItems([wish], toSection: PriceType.low)
            case 500000..<600000:
                snapshot.appendItems([wish], toSection: PriceType.normal)
            default:
                snapshot.appendItems([wish], toSection: PriceType.high)
            }
        }
        
        self.diffableDataSource.apply(snapshot)
    }
}
extension ListCollectionViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchBar.text else {
            return
        }
        self.wishList.append(Wish(name: text))
        self.updateSnapshot()
    }
}

extension ListCollectionViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let data = diffableDataSource.itemIdentifier(for: indexPath) else {
            return
        }
        guard let index = self.wishList.firstIndex(where: { $0.id == data.id }) else {
            return
        }
        self.wishList.remove(at: index)
        self.updateSnapshot()
    }
}
