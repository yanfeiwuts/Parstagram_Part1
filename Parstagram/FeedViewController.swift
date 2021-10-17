//
//  FeedViewController.swift
//  Parstagram
//
//  Created by Yanfei Wu on 10/12/21.
//

import UIKit
import AlamofireImage
import Parse

class FeedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!
    var posts = [PFObject]()
    var postLimit = 0
    let refreshControl =  UIRefreshControl()
    override func viewDidLoad() {
        super.viewDidLoad()
        postLimit = 20
        tableView.delegate = self
        tableView.dataSource = self
        loadImage()
        refreshControl.addTarget(self, action: #selector(loadImage), for: .valueChanged)
        tableView.refreshControl = refreshControl
    }
        
        
    @objc func loadImage(){
        let query = PFQuery(className: "Posts")
        query.includeKey("author")
        query.limit = 30
        query.findObjectsInBackground { (posts, error) in
            if posts != nil{
                self.posts.removeAll()
                self.posts = posts!
                self.posts.reverse()
                self.tableView.reloadData()
            }
            self.refreshControl.endRefreshing()
        }
    }

    func loadMoreImage(){
        postLimit += 1
        let query = PFQuery(className: "Posts")
        query.includeKey("author")
        query.limit = postLimit
        query.findObjectsInBackground { (posts, error) in
            if posts != nil{
                self.posts.removeAll()
                self.posts = posts!
                self.posts.reverse()
                self.tableView.reloadData()
            }
        }
    }
        
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row + 1 == postLimit{
            loadMoreImage()
        }
    }
        
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
        
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostTableViewCell") as! PostTableViewCell
        let post = posts[indexPath.row]
        let user = post["author"] as! PFUser
        cell.usernameLabel.text = user.username
        cell.captionLabel.text = post["caption"] as? String
        let imageFile = post["iamge"] as! PFFileObject
        let urlString = imageFile.url!
        let url = URL(string: urlString)!
        cell.photoView.af.setImage(withURL: url)
        return cell
        }

    @IBAction func logOut(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
}
