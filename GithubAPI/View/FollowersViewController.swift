//
//  FollowersViewController.swift
//  GithubAPI
//
//  Created by sania zafar on 06/04/2020.
//  Copyright © 2020 sania zafar. All rights reserved.
//

import UIKit

protocol FollowersViewControllerDelegate: NSObject {
    
    func updateDataSourceAndReload(data: [Any]?, nextPage: Int)
    
}

class FollowersViewController: UIViewController, FollowersViewControllerDelegate {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var blurView: UIView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var noFollowersView: UIView!
    var userName: String?
    var viewModel = FollowerViewModel()
    var pageNo = 1
    var nextPageLoading = false
    var dataSource = [Any]()
    
    lazy var layout: CustomFlowLayout = {
        let customLayout = CustomFlowLayout()
        customLayout.minimumLineSpacing = 10
        customLayout.minimumInteritemSpacing = 10
        customLayout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        
        return customLayout
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        loadFollowers()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = false
    }
    
    private func setupUI() {
        collectionView.register(UINib(nibName: "FollowerCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "FollowerCell")
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.collectionViewLayout = layout
        viewModel.delegate = self
        blurView.isHidden = true
        noFollowersView.isHidden = true
        self.title = "Followers"
    }
    
    private func loadFollowers() {
        guard let user = userName, !user.isEmpty else {
            
            return
        }
        viewModel.fetchFollowers(for: user, pageNo: pageNo)
    }
    
    private func loadNextPage() {
        guard pageNo != -1 else {
            return
        }
        nextPageLoading = true
        blurView.isHidden = false
        activityIndicator.startAnimating()
        collectionView.isUserInteractionEnabled = false
        loadFollowers()
    }
    
    
    // MARK: - FollowersViewControllerDelegate
    
    func updateDataSourceAndReload(data: [Any]?, nextPage: Int) {
        pageNo = nextPage
        guard let followersData = data, followersData.count > 0 else {
            DispatchQueue.main.async { self.noFollowersView.isHidden = false }
            
            return
        }
        if dataSource.isEmpty {
            dataSource = followersData
        } else {
            if nextPageLoading {
                nextPageLoading = false
                dataSource.append(contentsOf: followersData)
            } else {
                dataSource.removeAll()
                dataSource.append(contentsOf: followersData)
            }
        }
        
        DispatchQueue.main.async {
            self.blurView.isHidden = true
            self.activityIndicator.stopAnimating()
            self.collectionView.isUserInteractionEnabled = true
            self.collectionView.reloadData()
        }
    }
    
}

extension FollowersViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return self.dataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell = UICollectionViewCell()
        if let followerCell = collectionView.dequeueReusableCell(withReuseIdentifier: "FollowerCell", for: indexPath) as? FollowerCollectionViewCell,
            dataSource.count > 0,
            let follower = dataSource[indexPath.row] as? Follower {
            followerCell.configureCell(with: follower)
            cell = followerCell
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if dataSource.isEmpty || dataSource.count < indexPath.row {
            
            return
        }
        if let follower = dataSource[indexPath.row] as? Follower,
            let followerCell = cell as? FollowerCollectionViewCell {
            followerCell.configureCell(with: follower)
            if indexPath.row == dataSource.count - 4 {
                loadNextPage()
            }
        }
    }
    
}
