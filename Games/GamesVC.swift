//
//  GamesVC.swift
//  Games
//
//  Created by Lindsey Isaak on 2017-05-14.
//  Copyright © 2017 Lindsey Isaak. All rights reserved.
//

import UIKit

class GamesVC: UIViewController, UISearchBarDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var collection: UICollectionView!
    
    var league: League!
    var games = [Game]()
    var filteredGames = [Game]()
    var inSearchMode = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        collection.dataSource = self
        collection.delegate = self
        searchBar.delegate = self
        
        self.navigationItem.title = league.name
        self.hideKeyboardWhenTappedElsewhere()
        
        getGamesForLeague()
    }

    func getGamesForLeague() {
        ActivitySpinnerView.instance.showProgressView(view)
        
        LeagueService.instance.getGamesIdsForLeague(leagueId: league.uid) { (gamesIds) in
            if gamesIds.count == 0 {
                ActivitySpinnerView.instance.hideProgressView()
            }
            
            for gameId in gamesIds {
                
                GameService.instance.getGame(gameId: gameId, onComplete: { (game) in
                    
                    if let game = game, !self.games.contains(game) {
                        self.games.append(game)
                    }
                    
                    self.collection.reloadData()
                    ActivitySpinnerView.instance.hideProgressView()
                })
            }
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
        
        // go to game and pass league
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 150, height: 150)
    }
    
    @IBAction func leaguesPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AddGame" {
            if let destinationVC = segue.destination as? AddGameVC {
                destinationVC.league = league
                destinationVC.gamesAlreadyInLeague = games
            }
        }
    }

}
