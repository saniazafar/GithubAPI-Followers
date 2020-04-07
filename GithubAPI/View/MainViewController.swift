//
//  MainViewController.swift
//  GithubAPI
//
//  Created by sania zafar on 06/04/2020.
//  Copyright © 2020 sania zafar. All rights reserved.
//

import UIKit

class MainViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var userNameTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userNameTextField.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }

    private func goToFollowersViewController() {
        DispatchQueue.main.async {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let viewController = storyboard.instantiateViewController(withIdentifier: "FollowersViewController") as! FollowersViewController
            viewController.userName = self.userNameTextField.text
            self.navigationController?.pushViewController(viewController, animated: true)
        }
    }
    
    
    // MARK: - UITextFieldDelegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let text = textField.text, !text.isEmpty {
            goToFollowersViewController()
        }
    }
    

}

