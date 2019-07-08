//
//  GoodsTVC.swift
//  Online store
//
//  Created by  Alexander on 05/07/2019.
//  Copyright © 2019  Alexander. All rights reserved.
//

import UIKit
import CoreData

class GoodsTVC: UITableViewController {
    
    lazy var context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    fileprivate let fetchRequest: NSFetchRequest<Good> = Good.fetchRequest()
    fileprivate var goodsArray: [Good] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        do {
            goodsArray = try context.fetch(fetchRequest)
        } catch {
            print(error.localizedDescription)
        }
        
        getDataFromFile()
        
    }

    fileprivate func getDataFromFile() {
        fetchRequest.predicate = NSPredicate(format: "name != nil")
        
        var records = 0
        
        do {
            let count = try context.count(for: fetchRequest)
            records = count
        } catch {
            print(error.localizedDescription)
        }
        
        guard records == 0 else { return }
        let pathToFile = Bundle.main.path(forResource: "Goods", ofType: "plist")
        let dataArray = NSArray(contentsOfFile: pathToFile!)!
        
        for dictionary in dataArray {
            let goodDictionary = dictionary as! NSDictionary
            let good = Good(context: context)
            
            good.name = (goodDictionary["name"] as! String)
            good.about = (goodDictionary["about"] as! String)
            good.cost = (goodDictionary["cost"] as! String)
            
            goodsArray.append(good)
            do {
                try context.save()
            } catch {
                print(error.localizedDescription)
            }
            
        }
        
    }
    @IBAction func addGood(_ sender: UIBarButtonItem) {
        let ac = UIAlertController(title: "Создать",
                                   message: "Введите данные о товаре",
                                   preferredStyle: .alert)
        let add = UIAlertAction(title: "Добавить", style: .default) { (alertAction) in
            
            let nameTextField = ac.textFields![0]
            let aboutTextField = ac.textFields![1]
            let costTextField = ac.textFields![2]
            
            After.delay(5, clousure: {
                DispatchQueue.main.async {
                    self.save(name: nameTextField.text,
                              about: aboutTextField.text,
                              cost: costTextField.text)
                    self.tableView.reloadData()
                }
                print("Товар добавлен с задержкой в 5 секунд")
            })
            
            
        }
        
        let cancel = UIAlertAction(title: "Закрыть", style: .default)
        
        ac.addTextField {
            textField in
            textField.placeholder = "Ввведите название"
        }
        ac.addTextField {
            textField in
            textField.placeholder = "Ввведите описание"
        }
        ac.addTextField {
            textField in
            textField.placeholder = "Ввведите стоимость"
            textField.keyboardType = .numberPad
        }
        
        ac.addAction(add)
        ac.addAction(cancel)
        present(ac, animated: true)
        
    }
    
    fileprivate func save(name: String?, about: String?, cost: String?) {
        let entity = NSEntityDescription.entity(forEntityName: "Good",
                                                in: context)
        
        let goodObject = NSManagedObject(entity: entity!, insertInto: context) as! Good
        goodObject.name = name
        goodObject.about = about
        goodObject.cost = cost
        
        do {
            try context.save()
            goodsArray.append(goodObject)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    @IBAction func unwindToGoodsList(_ unwindSegue: UIStoryboardSegue) {
        
    }
    
}

extension GoodsTVC {
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return goodsArray.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        cell.textLabel?.text = goodsArray[indexPath.row].name
        
        return cell
    }
    
    // MARK: - Table view delegate
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 88
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "to description" else { return }
        guard let destinationVC = segue.destination as? AboutGoodVC else { return }
        
        if let indexPath = tableView.indexPathForSelectedRow {
            let good = goodsArray[indexPath.row]
            destinationVC.name = good.name
            destinationVC.about = good.about
            destinationVC.cost = good.cost
        }
    }
}
