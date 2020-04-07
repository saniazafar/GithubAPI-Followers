//
//  FollowerViewModel.swift
//  GithubAPI
//
//  Created by sania zafar on 06/04/2020.
//  Copyright © 2020 sania zafar. All rights reserved.
//

import Foundation

class FollowerViewModel: NSObject {
    
    var apiConnector = ApiConnector()
    weak var delegate: FollowersViewControllerDelegate?
    
    override init() {
        super.init()
    }
    
    func fetchFollowers(for userName: String, pageNo: Int) {
        apiConnector.fetchFollowers(for: userName, pageNo: pageNo, success: { [weak self] (response, nextPage) in
            if let responseArray = response as? [[String: Any]] {
                let followersArray = CodableParser.parseResponse(responseArray, type: [Follower].self)
                self?.delegate?.updateDataSourceAndReload(data: followersArray, nextPage: pageNo)
            } else {
                self?.delegate?.updateDataSourceAndReload(data: [], nextPage: nextPage)
            }
        }) { (error) in
            //handle error
        }
    }
    
}
