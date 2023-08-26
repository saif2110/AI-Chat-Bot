//
//  HistoryVC.swift
//  AI Chat Bot
//
//  Created by Admin on 25/08/23.
//

import UIKit

class HistoryVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var proButtunOutlet: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        isProTrigger = {
            self.whenPROactivated()
        }
        
        if Manager.isPro {
            whenPROactivated()
        }
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.reloadData()
    }
    
    private func whenPROactivated(){
        self.proButtunOutlet.tintColor = .systemOrange
    }
    

    @IBAction func deleteHistory(_ sender: Any) {
        guard Manager.historyArray.count > 0  else {return}
        let alert = UIAlertController(title: "Delete History!", message: "🧹 Would you like to sweep away your history?", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default, handler: nil))
        alert.addAction(UIAlertAction(title: "Confirm", style: UIAlertAction.Style.destructive, handler: { UIAlertAction in
            Manager.historyArray.removeAll()
            self.tableView.reloadData()
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
}

extension HistoryVC:UITableViewDataSource,UITableViewDelegate {
   
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if Manager.historyArray.count == 0 {
            self.tableView.setEmptyMessage("⏳ No history available yet.\nKeep using app & come back later!")
        } else {
            self.tableView.restore()
        }
        
        return Manager.historyArray.count
    }
    
  
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: HistoryCell.identifire, for: indexPath) as! HistoryCell
        let arrays = Array(Manager.historyArray.reversed())
        cell.quetion.text = arrays[indexPath.row][0]
        cell.answer.text = arrays[indexPath.row][1]
        cell.viewMoreButtonTapped = {
            self.tabBarController?.selectedIndex = 0
            NotificationCenter.default.post(name: Notification.Name("historyViewmoreTapped"), object: nil, userInfo: ["array":arrays[indexPath.row]])
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
    
    
    
}


extension UITableView {

    func setEmptyMessage(_ message: String) {
        let messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height))
        messageLabel.text = message
        messageLabel.textColor = .white
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
        messageLabel.font = UIFont(name: "Montserrat-SemiBold", size: 15)
        messageLabel.sizeToFit()

        self.backgroundView = messageLabel
        self.separatorStyle = .none
    }

    func restore() {
        self.backgroundView = nil
        self.separatorStyle = .none
    }
}
