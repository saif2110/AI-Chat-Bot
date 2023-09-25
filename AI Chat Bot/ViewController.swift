//
//  ViewController.swift
//  AI Chat Bot
//
//  Created by Admin on 19/08/23.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var topNevigationView: UIView!
    
    @IBOutlet weak var offerView: UIView!
    
    var allQuestionAnswers:[String] = []
    
    @IBOutlet weak var proButtunOutlet: UIButton!
    @IBOutlet weak var suggestionView: UIView!
    @IBOutlet weak var quetionTextFiled: UITextField!
    @IBOutlet weak var bottomContanierView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var queryTextFiled: UITextField!
    
    //Depth
    @IBOutlet weak var short: UIButton!
    @IBOutlet weak var medium: UIButton!
    @IBOutlet weak var heigh: UIButton!
    
    
    func onBoardingProcess(){
        if Manager.numberofTimesAppOpen == 1 {
        DispatchQueue.main.async {
            let story = UIStoryboard(name: "Welcome", bundle: nil)
            let vc = story.instantiateViewController(withIdentifier: "Nevigation")
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: false)
        }
            
        }else{
            openInappPurchase(context: self)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
        onBoardingProcess()
        
        let tap = UITapGestureRecognizer()
        tap.addTarget(self, action: #selector(offerViewtapped))
        offerView.addGestureRecognizer(tap)
        
        self.quetionTextFiled.delegate = self
        self.bottomContanierView.round(corners: [.topLeft,.topRight], radius: 22)
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3, execute: {
            openInappPurchase(context: self)
        })
        
        
        isProTrigger = {
            self.whenPROactivated()
        }
        
        if Manager.isPro {
            whenPROactivated()
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(appWillTerminate), name: UIApplication.willTerminateNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(historyViewmoreTapped), name: Notification.Name("historyViewmoreTapped"), object: nil)
    }
    
    @objc func appWillTerminate() {
        guard allQuestionAnswers.count > 1 else {return}
        Manager.historyArray.append(allQuestionAnswers)
        
    }
    
    @objc func historyViewmoreTapped(notification: NSNotification){
        if !(notification.userInfo?.isEmpty ?? true) {
            let array = notification.userInfo?["array"]
            self.allQuestionAnswers = array as! [String]
            self.suggestionView.isHidden = true
            self.tableView.reloadData()
            let topIndexPath = IndexPath(row: 0, section: 0)
            self.tableView.scrollToRow(at: topIndexPath, at: .top, animated: false)
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func offerViewtapped(){
        openInappPurchase(context: self)
    }
    
    @IBAction func proButton(_ sender: UIButton) {
        openInappPurchase(context: self)
    }
    
    
    private func whenPROactivated(){
        self.proButtunOutlet.tintColor = .systemOrange
        self.short.setImage(nil, for: .normal)
        self.medium.setImage(nil, for: .normal)
        self.heigh.setImage(nil, for: .normal)
        selectButton(tag:Manager.depthSelectedValue)
        self.offerView.bounds.size.height = 0
        self.offerView.isHidden = true
    }
    
    
    
    @IBAction func depthAction(_ sender: UIButton) {
        guard Manager.isPro else {
            openInappPurchase(context: self)
            return
        }
        
        selectButton(tag:sender.tag)
        Manager.depthSelectedValue = sender.tag
    }
    
    @IBAction func suggestionAction(_ sender: UIButton) {
        let text = sender.titleLabel?.text
        quetionTextFiled.text = text
    }
    
    
    private func selectButton(tag:Int){
        
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
        
        let deselectTitleColor = #colorLiteral(red: 0.5704585314, green: 0.5704723597, blue: 0.5704649091, alpha: 1)
        let backgroundColor = #colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 0.1765573262)
        let selectedColor = #colorLiteral(red: 0, green: 0.6928513646, blue: 0.6272605658, alpha: 1)
        
        short.backgroundColor = backgroundColor
        short.setTitleColor(deselectTitleColor, for: .normal)
        medium.backgroundColor = backgroundColor
        medium.setTitleColor(deselectTitleColor, for: .normal)
        heigh.backgroundColor = backgroundColor
        heigh.setTitleColor(deselectTitleColor, for: .normal)
        
        let tag = tag
        
        switch tag {
        case 0:
            short.backgroundColor = selectedColor
            short.setTitleColor(.white, for: .normal)
            break
        case 1:
            medium.backgroundColor = selectedColor
            medium.setTitleColor(.white, for: .normal)
            break
        case 2:
            heigh.backgroundColor = selectedColor
            heigh.setTitleColor(.white, for: .normal)
            break
        default:
            break
        }
    }
    
    @IBAction func sendButton(_ sender: Any) {
        //if user asked quetion (numberofTimeUsage) times block whole app.
        if !Manager.isPro {
            guard Manager.queryHitValue < numberofTimeUsage else {
                openInappPurchase(context: self)
                return}
        }
        
        Manager.queryHitValue = Manager.queryHitValue + 1
        guard queryTextFiled.text != "" else {return}
        view.endEditing(true)
        suggestionView.isHidden = true
        queryTextFiled.isUserInteractionEnabled = false
        allQuestionAnswers.append(queryTextFiled.text ?? "")
        askQuestionAPI(quetion: queryTextFiled.text ?? "")
        queryTextFiled.text = ""
        self.tableView.reloadData()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.scrolltoBottom()
        }
        playSound(type: .send)
        
//        if Manager.queryHitValue%2 == 0 {
//            openInappPurchase(context: self)
//        }
        
    }
    
}

extension ViewController: UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        allQuestionAnswers.count
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row%2 != 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: AnswerCell.identifire, for: indexPath) as! AnswerCell
            cell.output.text = allQuestionAnswers[indexPath.row].prefix(1).uppercased() + allQuestionAnswers[indexPath.row].dropFirst()
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: QuestionCell.identifire, for: indexPath) as! QuestionCell
            cell.output.text = allQuestionAnswers[indexPath.row].prefix(1).uppercased() + allQuestionAnswers[indexPath.row].dropFirst()
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
    
    
}

//API
extension ViewController {
    
    private func scrolltoBottom(){
        let lastSection = self.tableView.numberOfSections - 1
        let lastRow = self.tableView.numberOfRows(inSection: lastSection) - 1
        let indexPath = IndexPath(row: lastRow, section: lastSection)
        self.tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
    }
    
    func askQuestionAPI(quetion:String){
        guard !quetion.isEmpty else {return}
        hitAPI(question: quetion,messages: allQuestionAnswers) { errSecSuccess, result in
            
            DispatchQueue.main.async {
                self.allQuestionAnswers.append(result)
                self.tableView.reloadData()
                self.queryTextFiled.isUserInteractionEnabled = true
                self.scrolltoBottom()
                playSound(type: .receive)
            }
            
            
        }
    }
    
}


// Text Delegate
extension ViewController:UITextFieldDelegate {
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        if let text = textField.text, !text.isEmpty {
            let capitalizedText = text.prefix(1).uppercased() + text.dropFirst()
            textField.text = capitalizedText
        }
    }
    
}
