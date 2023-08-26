//
//  ViewController.swift
//  AI Chat Bot
//
//  Created by Admin on 19/08/23.
//

import UIKit

class ViewControllerGenerate: UIViewController {
    
    @IBOutlet weak var topicLabal: UILabel!
    
    //StackViewEmails
    @IBOutlet weak var que1: UIButton!
    @IBOutlet weak var que2: UIButton!
    @IBOutlet weak var que3: UIButton!
    @IBOutlet weak var que4: UIButton!
    @IBOutlet weak var que5: UIButton!
    @IBOutlet weak var que6: UIButton!
    @IBOutlet weak var que7: UIButton!
    @IBOutlet weak var que8: UIButton!
    @IBOutlet weak var que9: UIButton!
    
    
    
    @IBOutlet weak var topNevigationView: UIView!
    
    @IBOutlet weak var offerView: UIView!
    
    var allQuestionAnswers:[String] = []
    
    @IBOutlet weak var proButtunOutlet: UIButton!
    @IBOutlet weak var suggestionView: UIView!
    @IBOutlet weak var quetionTextFiled: UITextField!
    @IBOutlet weak var bottomContanierView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var queryTextFiled: UITextField!
    
    
    @IBOutlet weak var email: UIButton!
    @IBOutlet weak var fun: UIButton!
    @IBOutlet weak var education: UIButton!
    @IBOutlet weak var idea: UIButton!
    @IBOutlet weak var lifestyle: UIButton!
    @IBOutlet weak var business: UIButton!
    @IBOutlet weak var social: UIButton!
    @IBOutlet weak var letter: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
             
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
        
    }
    
    @objc func offerViewtapped(){
        openInappPurchase(context: self)
    }
    
    @IBAction func proButton(_ sender: UIButton) {
        openInappPurchase(context: self)
    }
    
    private func addIntostackQuetions(arraofString:[String]){
        que1.setTitle(arraofString[0], for: .normal)
        que2.setTitle(arraofString[1], for: .normal)
        que3.setTitle(arraofString[2], for: .normal)
        que4.setTitle(arraofString[3], for: .normal)
        que5.setTitle(arraofString[4], for: .normal)
        que6.setTitle(arraofString[5], for: .normal)
        que7.setTitle(arraofString[6], for: .normal)
        que8.setTitle(arraofString[7], for: .normal)
        que9.setTitle(arraofString[8], for: .normal)
    }
    
    
    private func whenPROactivated(){
        self.proButtunOutlet.tintColor = .systemOrange
        self.offerView.bounds.size.height = 0
        self.offerView.isHidden = true
    }
    
    
    
    @IBAction func depthAction(_ sender: UIButton) {
        suggestionView.isHidden = false
        topicLabal.text = "Generate \(topic[sender.tag]) Prompt !"
        selectButton(sender:sender)
        addIntostackQuetions(arraofString: mainPromtArray[sender.tag])
        
    }
    
    @IBAction func suggestionAction(_ sender: UIButton) {
        let text = sender.titleLabel?.text
        quetionTextFiled.text = text
    }
    
    
    private func selectButton(sender: UIButton){

        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()

        let deselectTitleColor = #colorLiteral(red: 0.5704585314, green: 0.5704723597, blue: 0.5704649091, alpha: 1)
        let backgroundColor = #colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 0.1765573262)
        let selectedColor = #colorLiteral(red: 0, green: 0.6928513646, blue: 0.6272605658, alpha: 1)
        
        email.backgroundColor = backgroundColor
        email.setTitleColor(deselectTitleColor, for: .normal)
        fun.backgroundColor = backgroundColor
        fun.setTitleColor(deselectTitleColor, for: .normal)
        education.backgroundColor = backgroundColor
        education.setTitleColor(deselectTitleColor, for: .normal)
        idea.backgroundColor = backgroundColor
        idea.setTitleColor(deselectTitleColor, for: .normal)
        lifestyle.backgroundColor = backgroundColor
        lifestyle.setTitleColor(deselectTitleColor, for: .normal)
        business.backgroundColor = backgroundColor
        business.setTitleColor(deselectTitleColor, for: .normal)
        social.backgroundColor = backgroundColor
        social.setTitleColor(deselectTitleColor, for: .normal)
        letter.backgroundColor = backgroundColor
        letter.setTitleColor(deselectTitleColor, for: .normal)

        sender.backgroundColor = selectedColor
        sender.setTitleColor(UIColor.white, for: .normal)
       
    }
    
    @IBAction func sendButton(_ sender: Any) {
        //if user asked quetion (numberofTimeUsage) times block whole app.
        if !Manager.isPro {
            guard Manager.queryHitValue < numberofTimeUsage else {
                openInappPurchase(context: self)
                return }
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
        
        if Manager.queryHitValue%2 == 0 {
            openInappPurchase(context: self)
        }
        
    }
    
}

extension ViewControllerGenerate: UITableViewDelegate,UITableViewDataSource {
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
extension ViewControllerGenerate {
    
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
            }
            
            
        }
    }
    
}


// Text Delegate
extension ViewControllerGenerate:UITextFieldDelegate {
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        if let text = textField.text, !text.isEmpty {
            let capitalizedText = text.prefix(1).uppercased() + text.dropFirst()
            textField.text = capitalizedText
        }
    }
    
}
