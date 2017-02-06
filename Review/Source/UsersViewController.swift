//
//  ViewController.swift
//  Review
//
//  Created by Jose Maria Puerta on 6/2/17.
//  Copyright © 2017 Jose Maria Puerta. All rights reserved.
//

import UIKit
import ReactiveCocoa

class UsersViewController : UIViewController, UserView {
    var userPresenter: UsersPresenter!
    @IBOutlet weak var usersTableView: UITableView!
    
    fileprivate let dateFormatter = DateFormatter()
    fileprivate weak var currentDateTextField: UITextField? = nil
    fileprivate var searchBar: UISearchBar!
    fileprivate var addButton: UIBarButtonItem!
    
    class func initFromStoryboard() -> UsersViewController {
        return UIStoryboard(name: "Users", bundle: nil)
            .instantiateViewController(withIdentifier: "UsersViewController") as! UsersViewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        automaticallyAdjustsScrollViewInsets = false
        
        dateFormatter.dateFormat = "dd-MM-yyyy"
        
        searchBar = UISearchBar()
        searchBar.sizeToFit()
        searchBar.delegate = self
        navigationItem.titleView = searchBar
        
        addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonTapped))
        navigationItem.rightBarButtonItem = addButton
        
        usersTableView.delegate = self
        usersTableView.dataSource = self
        
        
        userPresenter.reloadUsers()
    }
    
    func addButtonTapped(_ sender: Any) {
        let alert = createAlertController(title: NSLocalizedString("AddingNewUser", comment: ""),
                                          name: "",
                                          birthdate: "",
                                          saveAction: addUser)
        
        present(alert, animated: true, completion: nil)
    }
    
    func addUser(from alert: UIAlertController) {
        guard let userData = self.userData(from: alert) else {
            return
        }
        
        let user = AddingUser(name: userData.name, birthdate: userData.date)
        userPresenter.addUser(user)
    }
    
    func editUser(_ user: User, at indexPath: IndexPath, from alert: UIAlertController) {
        guard let userData = self.userData(from: alert) else {
            return
        }
        
        let updatedUser = User(id: user.id, name: userData.name, birthdate: userData.date)
        userPresenter.updateUser(updatedUser, at: indexPath)
    }
    
    // UserView protocol functions
    
    func reload() {
        usersTableView.reloadData()
    }
    
    func deleteUser(at indexPath: IndexPath) {
        usersTableView.deleteRows(at: [indexPath], with: .right)
    }
    
    func insertUser(at indexPath: IndexPath) {
        usersTableView.insertRows(at: [indexPath], with: .right)
    }
    
    func displayAlert(title: String) {
        let alert = UIAlertController(title: title, message: "", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("Ok", comment: ""),
                                      style: .default,
                                      handler: nil))
        
        present(alert, animated: true, completion: nil)
    }
    
    // Private functions
    
    fileprivate func userData(from alert: UIAlertController) -> (name: String, date: Date)? {
        guard let name = alert.textFields?[0].text,
            let birthdateString = alert.textFields?[1].text,
            let birthdate = dateFormatter.date(from: birthdateString) else {
                return nil
        }
        
        return (name, birthdate)
    }
    
    fileprivate func createAlertController(title: String, name: String, birthdate: String, saveAction: @escaping (UIAlertController) -> ()) -> UIAlertController {
        let alert = UIAlertController(title: title, message: "", preferredStyle: .alert)
        
        alert.addTextField(configurationHandler: { tf in
            tf.text = name
            tf.placeholder = NSLocalizedString("Name", comment: "")
        })
        
        alert.addTextField(configurationHandler: { tf in
            tf.delegate = self
            
            self.currentDateTextField = tf
            tf.text = birthdate
            tf.placeholder = NSLocalizedString("Birthdate", comment: "")
        })
        
        alert.addAction(UIAlertAction(title: NSLocalizedString("Save", comment: ""),
                                      style: .default,
                                      handler: { _ in
                                        saveAction(alert)
        }))
        
        alert.addAction(UIAlertAction(title: NSLocalizedString("Discard", comment: ""),
                                      style: .destructive,
                                      handler: nil))
        
        return alert
    }
}

extension UsersViewController : UITableViewDataSource, UITableViewDelegate {
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let user = userPresenter.user(at: indexPath)
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") ?? UITableViewCell(style: .subtitle, reuseIdentifier: "Cell")
        cell.textLabel?.text = user.name
        cell.detailTextLabel?.text = user.birthdate.description
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let user = userPresenter.user(at: indexPath)
        let birthdateString = dateFormatter.string(from: user.birthdate)
        let alert = createAlertController(title: NSLocalizedString("EditingUser", comment: ""),
                                          name: user.name,
                                          birthdate: birthdateString,
                                          saveAction: { alert in
                                            self.editUser(user, at: indexPath, from: alert)
                                            
        })
        
        present(alert, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userPresenter.usersCount
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            userPresenter.removeUser(at: indexPath)
        }
    }
}

extension UsersViewController : UITextFieldDelegate {
    
    func datePickerValueChanged(sender: UIDatePicker) {
        currentDateTextField?.text = dateFormatter.string(from: sender.date)
    }
    
    func textFieldDidBeginEditing(_ textView: UITextView) {
        let datePickerView = UIDatePicker()
        datePickerView.datePickerMode = .date
        textView.inputView = datePickerView
        
        datePickerView.addTarget(self, action: #selector(datePickerValueChanged), for: .valueChanged)
    }
}

extension UsersViewController : UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        userPresenter.filterUsers(by: searchText)
    }
}
