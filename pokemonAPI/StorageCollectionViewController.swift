//
//  StorageCollectionViewController.swift
//  pokemonAPI
//
//  Created by Dylan Sharkey on 3/15/16.
//  Copyright © 2016 Dylan Sharkey. All rights reserved.
//
import RealmSwift
import UIKit

var allPokemon: Results<Pokemon>?
private let sectionInsets = UIEdgeInsets(top: 50.0, left: 20.0, bottom: 50.0, right: 20.0)

extension StorageCollectionViewController : UICollectionViewDelegateFlowLayout {
    //1
    func collectionView(collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
            
            let pokePhoto =  UIImage(data: allPokemon![indexPath.row].image!)
            //2
            var size = pokePhoto!.size
            size.width += 10
            size.height += 10
            return size
    }
    
    //3
    func collectionView(collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        insetForSectionAtIndex section: Int) -> UIEdgeInsets {
            return sectionInsets
    }
}

class StorageCollectionViewController: UICollectionViewController {
    
    let realm = try! Realm()
    
    private let reuseIdentifier = "pokemonCell"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        allPokemon = realm.objects(Pokemon)
        collectionView?.reloadData()
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return allPokemon!.count
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! pokemonCellCollectionViewCell
        let currentImage = UIImage(data: allPokemon![indexPath.row].image!)
        cell.pokemonImage.image = currentImage
        cell.pokemonName.text = allPokemon![indexPath.row].name
        return cell
    }
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        //remove
        try! realm.write {
            realm.delete(allPokemon![indexPath.row])
        }
        collectionView.reloadData()
    }
    

}
