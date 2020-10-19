//
//  ViewController.swift
//  MoyaTest
//
//  Created by Kairzhan Kural on 10/19/20.
//  Copyright © 2020 Kairzhan Kural. All rights reserved.
//

import UIKit
import Moya

class ViewController: UITableViewController {
    
    var users = [User]()
    let userProvider = MoyaProvider<Service>()
    
    let cellId = "celllllid"

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupUI()
        
        userProvider.request(.getUsers) { (result) in
            switch result {
            case .failure(let err):
                print(err)
            case .success(let response):
                let users = try! JSONDecoder().decode([User].self, from: response.data)
                self.users = users
                self.tableView.reloadData()
            }
        }
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
    }
    
    private func setupUI() {
        navigationItem.title = "Users"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add", style: .plain, target: self, action: #selector(handleAdd))
    }
    
    @objc private func handleAdd() {
        let kair = User(id: 44, name: "Kairzhan")
        userProvider.request(.createUser(name: kair.name)) { (result) in
            switch result {
            case .failure(let err):
                print(err)
            case .success(let response):
                let newUser = try! JSONDecoder().decode(User.self, from: response.data)
                print(newUser)
                self.users.insert(newUser, at: 0)
                self.tableView.reloadData()
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        users.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        let user = users[indexPath.row]
        cell.textLabel?.text = user.name
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let user = users[indexPath.row]
        userProvider.request(.updateUser(id: user.id, name: "Changed name:" + user.name)) { (result) in
            switch result {
            case .failure(let err):
                print(err)
            case .success(let response):
                let updatedUser = try! JSONDecoder().decode(User.self, from: response.data)
                print(updatedUser)
                self.users[indexPath.row] = updatedUser
                self.tableView.reloadData()
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let user = users[indexPath.row]
        print(user.id)
        let delete = UIContextualAction(style: .destructive, title: "Delete") { (_, _, _) in
            self.userProvider.request(.deleteUser(id: user.id)) { (result) in
                switch result {
                case .failure(let err):
                    print(err)
                case .success(let response):
                    print(response)
                    self.users.remove(at: indexPath.row)
                    self.tableView.deleteRows(at: [indexPath], with: .automatic)
                }
            }
        }

        let actions = UISwipeActionsConfiguration(actions: [delete])
        return actions
    }

}

