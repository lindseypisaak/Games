//
//  LeaguesVC.swift
//  Games
//
//  Created by Lindsey Isaak on 2017-04-29.
//  Copyright © 2017 Lindsey Isaak. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import SwipeCellKit

class LeaguesVC: UITableViewController, SwipeTableViewCellDelegate {

    private var userId: String?
    private var leagues = [[League](), [League]()]
    private var sectionNames = ["My Leagues", "Pending Invites"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        refreshControl?.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl?.addTarget(self, action: #selector(self.refresh(refreshControl:)), for: .valueChanged)
        
        userId = FIRAuth.auth()?.currentUser?.uid
        
        getLeagues()
    }
    
    func getLeagues() {
        ActivitySpinnerView.instance.showProgressView(view)
        
        UserService.instance.getLeagueIdsForUser(userId: userId!) { (leagueIds) in
            if leagueIds.count == 0 {
                ActivitySpinnerView.instance.hideProgressView()
                return
            }
            
            for (index, leagueType) in leagueIds.enumerated() {
                for leagueId in leagueType {
                    
                    LeagueService.instance.getLeague(leagueId: leagueId, onComplete: { (league) in
                        
                        if let league = league, !self.leagues[index-1].contains(league) {
                            self.leagues[index-1].append(league)
                        }
                        
                        self.leagues[0].sort(by: { $0.name < $1.name })
                        self.leagues[1].sort(by: { $0.name < $1.name })
                        self.tableView.reloadData()
                        ActivitySpinnerView.instance.hideProgressView()
                    })
                }
            }
        }
    }
    
    func refresh(refreshControl: UIRefreshControl) {
        getLeagues()
        refreshControl.endRefreshing()
    }
    
    func leaveLeague(leagueArrayIndex: Int) {
        let league = leagues[0][leagueArrayIndex]
        leagues[0].remove(at: leagueArrayIndex)
        
        LeagueService.instance.removeUserFromLeague(leagueId: league.uid, userId: userId!)
        UserService.instance.removeLeagueFromUser(userId: userId!, leagueId: league.uid)
        
        self.tableView.reloadData()
    }

    func acceptLeagueInvite(leagueArrayIndex: Int) {
        let league = leagues[1][leagueArrayIndex]
        
        LeagueService.instance.addUserToLeague(leagueId: league.uid, userId: userId!)
        UserService.instance.addLeagueToUser(userId: userId!, leagueId: league.uid)
        
        leagues[0].append(league)
        leagues[0].sort(by: { $0.name < $1.name })
        
        removeLeagueInvite(leagueArrayIndex: leagueArrayIndex)
    }
    
    func removeLeagueInvite(leagueArrayIndex: Int) {
        let league = leagues[1][leagueArrayIndex]
        leagues[1].remove(at: leagueArrayIndex)
        
        LeagueService.instance.removeUserFromLeagueInvites(leagueId: league.uid, userId: userId!)
        UserService.instance.removeLeagueFromUserInvites(userId: userId!, leagueId: league.uid)
        
        self.tableView.reloadData()
    }
    
    // MARK: - Table View
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return leagues.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return leagues[section].count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section < sectionNames.count, leagues[section].count > 0 {
            return sectionNames[section]
        }
        
        return nil
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0, let cell = tableView.dequeueReusableCell(withIdentifier: "LeagueCell", for: indexPath) as? LeagueCell {
            cell.configureCell(league: leagues[indexPath.section][indexPath.row])
            cell.delegate = self
            return cell
        }
        
        if indexPath.section == 1, let cell = tableView.dequeueReusableCell(withIdentifier: "PendingInviteCell", for: indexPath) as? PendingInviteCell {
            cell.configureCell(league: leagues[indexPath.section][indexPath.row])
            cell.delegate = self
            return cell
        }
        
        return UITableViewCell()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.section == 0, let cell = tableView.cellForRow(at: indexPath) as? LeagueCell {
            let currentLeague = LeagueTBC.instantiate(fromAppStoryboard: .CurrentLeague)
            
            let gamesNC = currentLeague.viewControllers?.first as? GamesNC
            let gamesVC = gamesNC?.topViewController as? GamesVC
            gamesVC?.league = cell.league
            
            let membersNC = currentLeague.viewControllers?.last as? MembersNC
            let membersVC = membersNC?.topViewController as? MembersVC
            membersVC?.league = cell.league
            
            present(currentLeague, animated: true, completion: nil)
        }
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        
        if indexPath.section == 0 {
            let decline = SwipeAction(style: .default, title: "Leave", handler: { (action, indexPath) in
                
                self.showAlertYesOrNo(title: "Leave League", message: "Are you sure you want to leave the league \(self.leagues[indexPath.section][indexPath.row].name)?", handler: { (action) in
                    
                    if action.style == .default {
                        self.leaveLeague(leagueArrayIndex: indexPath.row)
                    }
                })
            })
            
            decline.hidesWhenSelected = true
            decline.font = UIFont(name: "Avenir", size: 13.0)
            decline.backgroundColor = UIColor.red
            decline.image = UIImage(named: "cancel")
            
            return [decline]
        } else {
            let decline = SwipeAction(style: .default, title: "Decline") { (action, indexPath) in
                
                self.showAlertYesOrNo(title: "Decline Invite", message: "Are you sure you want to decline the invite to \(self.leagues[indexPath.section][indexPath.row].name)?", handler: { (action) in
                    
                    if action.style == .default {
                        self.removeLeagueInvite(leagueArrayIndex: indexPath.row)
                    }
                })
            }
            
            decline.hidesWhenSelected = true
            decline.font = UIFont(name: "Avenir", size: 13.0)
            decline.backgroundColor = UIColor.red
            decline.image = UIImage(named: "cancel")
            
            let accept = SwipeAction(style: .default, title: "Accept") { (action, indexPath) in
                self.showAlertYesOrNo(title: "Accept Invite", message: "Are you sure you want to accept the invite to \(self.leagues[indexPath.section][indexPath.row].name)?", handler: { (action) in
                    
                    if action.style == .default {
                        self.acceptLeagueInvite(leagueArrayIndex: indexPath.row)
                    }
                })
            }
            
            accept.hidesWhenSelected = true
            accept.font = UIFont(name: "Avenir", size: 13.0)
            accept.backgroundColor = UIColor(red: 0.02, green: 0.42, blue: 0.02, alpha: 1.0)
            accept.image = UIImage(named: "checkmark")
            
            return [accept, decline]
        }
    }
    
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeTableOptions {
        var options = SwipeTableOptions()
//        options.expansionStyle = .fill
        options.transitionStyle = .border
        return options
    }

    // MARK: - IBActions
    
    @IBAction func logOut(_ sender: Any) {
        AuthService.instance.signOut { (error, user) in
            guard error == nil else {
                self.showAlert(title: "Error", message: error!, handler: nil)
                return
            }

            self.dismiss(animated: true, completion: nil)
        }
    }
}
