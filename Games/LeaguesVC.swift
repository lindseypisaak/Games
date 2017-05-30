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
//    private var leagues = [[League](), [League]()]
    private var leagues = Dictionary<String, [League]>()
    private var sectionNames = ["My Leagues", "Pending Invites"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        refreshControl?.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl?.addTarget(self, action: #selector(self.refresh(refreshControl:)), for: .valueChanged)
        
        leagues["leagues"] = [League]()
        leagues["invites"] = [League]()
        
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
            
            for leagueType in leagueIds {
                for leagueId in leagueType.value {
                    
                    LeagueService.instance.getLeague(leagueId: leagueId.key, invitedBy: leagueId.value, onComplete: { (league) in
                        
                        if let league = league, let leagues = self.leagues[leagueType.key], !leagues.contains(league) {
                            self.leagues[leagueType.key]?.append(league)
                        }
                        
                        self.leagues[leagueType.key]?.sort(by: { $0.name < $1.name } )
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
        let league = (leagues["leagues"]?[leagueArrayIndex])!
        leagues["leagues"]?.remove(at: leagueArrayIndex)
        
        LeagueService.instance.removeUserFromLeague(leagueId: league.uid, userId: userId!)
        UserService.instance.removeLeagueFromUser(userId: userId!, leagueId: league.uid)
        
        self.tableView.reloadData()
    }

    func acceptLeagueInvite(leagueArrayIndex: Int) {
        let league = (leagues["invites"]?[leagueArrayIndex])!
        
        LeagueService.instance.addUserToLeague(leagueId: league.uid, userId: userId!)
        UserService.instance.addLeagueToUser(userId: userId!, leagueId: league.uid)
        
        leagues["leagues"]?.append(league)
        leagues["leagues"]?.sort(by: { $0.name < $1.name } )
        
        removeLeagueInvite(leagueArrayIndex: leagueArrayIndex)
    }
    
    func removeLeagueInvite(leagueArrayIndex: Int) {
        let league = (leagues["invites"]?[leagueArrayIndex])!
        leagues["invites"]?.remove(at: leagueArrayIndex)
        
        LeagueService.instance.removeUserFromLeagueInvites(leagueId: league.uid, userId: userId!)
        UserService.instance.removeLeagueFromUserInvites(userId: userId!, leagueId: league.uid)
        
        self.tableView.reloadData()
    }
    
    // MARK: - Table View
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return leagues.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return leagues["leagues"]?.count ?? 0
        }
        
        return leagues["invites"]?.count ?? 0
    }
    
//    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        if section == 0, (leagues["leagues"]?.count)! > 0 {
//            return sectionNames[section]
//        } else if section == 1, (leagues["invites"]?.count)! > 0 {
//            return sectionNames[section]
//        }
//        
//        return nil
//    }
    
//    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        if indexPath.section == 0 {
//            return 70.0
//        }
//        
//        return 70.0
//    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0, let cell = tableView.dequeueReusableCell(withIdentifier: "LeagueCell", for: indexPath) as? LeagueCell {
            cell.configureCell(league: (leagues["leagues"]?[indexPath.row])!)
            cell.delegate = self
            return cell
        }
        
        if indexPath.section == 1, let cell = tableView.dequeueReusableCell(withIdentifier: "LeagueInviteCell", for: indexPath) as? LeagueInviteCell {
            cell.configureCell(league: (leagues["invites"]?[indexPath.row])!)
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
        
        if indexPath.section == 0, let league = self.leagues["leagues"]?[indexPath.row] {
            let leave = SwipeAction(style: .default, title: "Leave", handler: { (action, indexPath) in
                
                self.showAlertYesOrNo(title: "Leave League", message: "Are you sure you want to leave the league \(league.name)?", handler: { (action) in
                    
                    if action.style == .default {
                        self.leaveLeague(leagueArrayIndex: indexPath.row)
                    }
                })
            })
            
            leave.hidesWhenSelected = true
            leave.font = UIFont(name: "Avenir", size: 13.0)
            leave.backgroundColor = UIColor.red
            leave.image = UIImage(named: "cancel")
            
            return [leave]
        } else if let league = self.leagues["invites"]?[indexPath.row] {
            let decline = SwipeAction(style: .default, title: "Decline") { (action, indexPath) in
                
                self.showAlertYesOrNo(title: "Decline Invite", message: "Are you sure you want to decline the invite to \(league.name)?", handler: { (action) in
                    
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
                self.showAlertYesOrNo(title: "Accept Invite", message: "Are you sure you want to accept the invite to \(league.name)?", handler: { (action) in
                    
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
        
        return nil
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
