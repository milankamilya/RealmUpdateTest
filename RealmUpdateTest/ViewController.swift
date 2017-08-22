//
//  ViewController.swift
//  RealmUpdateTest
//
//  Created by Menlo on 22/08/17.
//  Copyright © 2017 zooft. All rights reserved.
//

import UIKit
import RealmSwift

class ViewController: UIViewController {

  @IBOutlet weak var tableView: UITableView?
  
  let teamService = TeamService()
  let realm = try! Realm();
  var teams: Results<Team>?
  var notificationToken: NotificationToken?
  
  override func viewDidLoad() {
    super.viewDidLoad()
  
    if let path = Bundle.main.url(forResource: "teams-sample", withExtension: "json") {
      let data = try! Data(contentsOf: path, options: .mappedIfSafe)
      let json = try! JSONSerialization.jsonObject(with: data, options: .mutableContainers)
      
      teamService.createAndUpdate(teams: json as? [[String:Any]])
      
    }
    
    teams = realm.objects(Team.self);
    notificationToken = teams?._addNotificationBlock({ [weak self](changes) in
      switch( changes ) {
      case .initial:
        self?.tableView?.reloadData()
      case .update(_,let deletions,let insertions,let modifications):
        
        print("Modified: deletions: \(deletions.count),\n insertions: \(insertions.count),\n modifications:\(modifications.count)")
        self?.tableView?.beginUpdates()
        self?.tableView?.insertRows( at: insertions.map({ IndexPath(row: $0, section: 0)}), with: .automatic)
        self?.tableView?.deleteRows( at: deletions.map({ IndexPath(row: $0, section: 0)}), with: .automatic)
        self?.tableView?.reloadRows( at: modifications.map({ IndexPath(row: $0, section: 0)}), with: .automatic)
        self?.tableView?.endUpdates()
      case .error:
        break
      }
    })
    
    /**
     * Member's properties are updated through MQTT in real project.
     * I simulate it here using timer.
     */
    
    
    // 1st Team's Member `lastSeenAt` property updated
    Timer.scheduledTimer(withTimeInterval: 10, repeats: true) { (timer) in
      
      print("\nTimer fired.")
      let memberService = MemberService()
      memberService.createAndUpdate(member: [
        "_id": "12",
        "role": "Admin",
        "lastSeenAt": "\(Date().description)"
      ])
    }
    
    // 2nd Team's Member `lastSeenAt` property updated
    Timer.scheduledTimer(withTimeInterval: 11, repeats: true) { (timer) in
      
      print("\nTimer fired.")
      let memberService = MemberService()
      memberService.createAndUpdate(member: [
        "_id": "122",
        "role": "Admin",
        "lastSeenAt": "\(Date().description)"
        ])
    }
    
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }


}

extension ViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if let count = teams?.count { return count } else { return 0 }
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    if let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as? TeamCell,
       let team = teams?[indexPath.row] {
      cell.title.text = team.title
      
      if let logo = team.logo,
        let logoUrl = URL(string: logo) {
      
        DispatchQueue(label: "download image").async {
          
          let imageData = try! Data(contentsOf: logoUrl)
          
          DispatchQueue.main.async {
            cell.logo.image = UIImage(data: imageData)
            cell.logo.contentMode = .scaleAspectFit
          }
        }
      }
      
      
      return cell
    }
    return UITableViewCell()
    
  }
}

