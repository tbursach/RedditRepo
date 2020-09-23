//
//  PostListTableViewController.swift
//  Reddit
//
//  Created by Trevor Bursach on 9/23/20.
//

import UIKit

class PostListTableViewController: UITableViewController {
    
    //MARK: - Properties
    
    var posts: [Post] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchPosts()
    }

    //MARK: - Helpers
    
    func fetchPosts() {
        PostController.fetchPosts { (result) in
            DispatchQueue.main.async {
            switch result {
            case .success(let posts):
                self.posts = posts
                    self.tableView.reloadData()
            case .failure(let error):
                self.presentErrorToUser(localizedError: error)
                print(error.localizedDescription)
                }
            }
        }
    }
    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "postCell", for: indexPath) as? PostTableViewCell else { return UITableViewCell() }
        
        let post = posts[indexPath.row]
        cell.post = post
        cell.delegate = self

        return cell
    }
    
   } // END OF CLASS

//MARK: - Extension
extension PostListTableViewController: PresentErrorToUserDelegate {
    func presentError(error: LocalizedError) {
        self.presentErrorToUser(localizedError: error)
    }
}
