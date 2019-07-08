//
//  AboutGoodVC.swift
//  Online store
//
//  Created by  Alexander on 05/07/2019.
//  Copyright © 2019  Alexander. All rights reserved.
//

import UIKit
import MessageUI
import TPPDF

class AboutGoodVC: UIViewController {
    
    var name: String!
    var about: String!
    var cost: String!
    
    
    @IBOutlet weak var buyButton: UIButton!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var costLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameLabel.text = name
        descriptionTextView.text = about
        costLabel.text = cost
        
        buyButton.layer.cornerRadius = 10
        buyButton.layer.borderWidth = 1
        buyButton.layer.borderColor = #colorLiteral(red: 0, green: 0.5274878144, blue: 1, alpha: 1)
    }

    @IBAction func buy() {
        After.delay(3) {
            print("Товар куплен!")
        }
    }
    
    @IBAction func share(_ sender: UIBarButtonItem) {
       sendMail()
    }
    
    fileprivate func sendMail() {

        let fileData = NSData(contentsOf: PDF.createPDF(with: self.about, and: #imageLiteral(resourceName: "logo"))!)
        
        if MFMailComposeViewController.canSendMail() {
            let defaultEmail = "example@example.com"
            let subject = "Mail from App!"
            let messageBody = "PDF содержит логотип магазина и описание выбранного товара."
            
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients([defaultEmail])
            mail.setSubject(subject)
            mail.setMessageBody(messageBody, isHTML: false)
            if let data = fileData {
                mail.addAttachmentData(data as Data, mimeType: "application/pdf", fileName: "CreatedGood.pdf")
            }
        
            present(mail, animated: true)
        }
    }
}

extension AboutGoodVC: MFMailComposeViewControllerDelegate {
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        
        switch result {
        case MFMailComposeResult.saved:
            print(Message.saved)
        case MFMailComposeResult.cancelled:
            print(Message.cancelled)
        case MFMailComposeResult.sent:
            print(Message.sent)
        case MFMailComposeResult.failed:
            print(Message.failed)
        @unknown default:
            fatalError()
        }
        
        controller.dismiss(animated: true, completion: nil)
    }
}
