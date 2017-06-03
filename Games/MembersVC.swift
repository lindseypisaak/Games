//
//  MembersVC.swift
//  Games
//
//  Created by Lindsey Isaak on 2017-05-21.
//  Copyright © 2017 Lindsey Isaak. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class MembersVC: UITableViewController {

    var league: League!
    private var userId: String?
    private var members = [[User](), [User]()]
    private var sectionNames = ["Members", "Invite Sent"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        refreshControl?.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl?.addTarget(self, action: #selector(self.refresh(refreshControl:)), for: .valueChanged)
        
        userId = FIRAuth.auth()?.currentUser?.uid
        
        getMembers()
    }
    
    func getMembers() {
        ActivitySpinnerView.instance.showProgressView(view)
        
        LeagueService.instance.getMembersAndInvitesForLeague(leagueId: league.uid) { (memberIds) in
            if memberIds.count == 0 {
                ActivitySpinnerView.instance.hideProgressView()
                return
            }
            
            for (index, memberType) in memberIds.enumerated() {
                for memberId in memberType {
                    
                    UserService.instance.getUser(userId: memberId, onComplete: { (user) in
                        
                        if let user = user, !self.members[index-1].contains(user) {
                            self.members[index-1].append(user)
                        }
                        
                        self.members[0].sort(by: { $0.name < $1.name })
                        self.members[1].sort(by: { $0.name < $1.name })
                        self.tableView.reloadData()
                        ActivitySpinnerView.instance.hideProgressView()

                    })
                }
            }
        }
    }
    
    func refresh(refreshControl: UIRefreshControl) {
        getMembers()
        refreshControl.endRefreshing()
    }
    
    // MARK: - Table View
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return members.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return members[section].count
    }
    
//    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        if section < sectionNames.count, members[1].count > 0 {
//            return sectionNames[section]
//        }
//        
//        return nil
//    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0, let cell = tableView.dequeueReusableCell(withIdentifier: "MemberCell", for: indexPath) as? MemberCell {
            cell.configureCell(user: self.members[indexPath.section][indexPath.row])
            return cell
        }
        
        if indexPath.section == 1, let cell = tableView.dequeueReusableCell(withIdentifier: "MemberInviteCell", for: indexPath) as? MemberInviteCell {
            cell.configureCell(user: self.members[indexPath.section][indexPath.row])
            return cell
        }
        
        return UITableViewCell()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
    }

    // MARK: - IBActions
    
    @IBAction func leaguesPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "inviteFriendModal" {
            if let destination = segue.destination as? InviteMemberModalVC {
                destination.league = league
            }
        }
    }
    

}
