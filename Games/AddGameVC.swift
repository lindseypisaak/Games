//
//  AddGameVC.swift
//  Games
//
//  Created by Lindsey Isaak on 2017-05-20.
//  Copyright © 2017 Lindsey Isaak. All rights reserved.
//

import UIKit

class AddGameVC: UIViewController, UISearchBarDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var collection: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var league: League!
    var games = [Game]()
    var filteredGames = [Game]()
    var gamesAlreadyInLeague: [Game]!
    var inSearchMode = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        collection.dataSource = self
        collection.delegate = self
        searchBar.delegate = self
        
        self.navigationItem.title = "Add Game"
        self.hideKeyboardWhenTappedElsewhere()
        
        getAllGamesNotAlreadyInLeague()
    }

    func getAllGamesNotAlreadyInLeague() {
        ActivitySpinnerView.instance.showProgressView(view)
        GameService.instance.getAllGames { (games) in
            
            for game in games {
                if !self.gamesAlreadyInLeague.contains(game) {
                    self.games.append(game)
                }
            }
            
            self.collection.reloadData()
            ActivitySpinnerView.instance.hideProgressView()
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        view.endEditing(true)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchBar.text == nil || searchBar.text == "" {
            
            inSearchMode = false
            collection.reloadData()
            
        } else {
            
            inSearchMode = true
            
            let lower = searchBar.text!.lowercased()
            
            filteredGames = games.filter({$0.name.lowercased().range(of: lower) != nil})
            collection.reloadData()
            
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if inSearchMode {
            return filteredGames.count
        }
        
        return games.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GameCell", for: indexPath) as? GameCell {
            let game: Game!
            
            if inSearchMode {
                game = filteredGames[indexPath.row]
            } else {
                game = games[indexPath.row]
            }
            
            cell.configureCell(game: game)
            return cell
        } else {
            return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        // Go to a setup screen? Or just give a modal for confirmation and add it?
        // Maybe depend on which game was selected?
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 150, height: 150)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
