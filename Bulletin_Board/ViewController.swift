//
//  ViewController.swift
//  Bulletin_Board
//
//  Created by Tobias Classon on 2020-12-04.
//  Copyright © 2020 Tobias Classon. All rights reserved.
//

import UIKit
import RealmSwift
import CoreData

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
   
    @IBOutlet var postsTableView: UITableView!
    
    // horrible way to handle posts ID but it works for the lab i guess :(
    var idCounter: Int16 = 1
    
    let realm = try! Realm()
    
    let context = (UIApplication.shared.delegate as!
        AppDelegate).persistentContainer.viewContext
    
    var posts: [Post]?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        postsTableView.delegate = self
        postsTableView.dataSource = self
        let nib = UINib(nibName: "PostTableViewCell", bundle: nil)
        postsTableView.register(nib, forCellReuseIdentifier: "PostTableViewCell")
        
        fetchPosts()
        
        
        
    }
    
    // fetch from Core Data
    func fetchPosts() {
        
        do {
            self.posts = try context.fetch(Post.fetchRequest())
            
            DispatchQueue.main.async {
                self.postsTableView.reloadData()
            }
        }
        catch {
            
        }
        
//        print("core data", posts)
//
//        let realmPosts = realm.objects(RealmPost.self)
//        print("realm", realmPosts)
        
    }
    
    // Save Core Data
    func savePost() {
        
        // Save data
        do {
            try self.context.save()
        }
        catch {
            
        }
        
        // Re-fetch data
        self.fetchPosts()
    }

    // Remove from Core Data and re-fetch
    func removePost(postToRemove: Post) {
        
        // Remove Post
        do {
            try self.context.delete(postToRemove)
        }
        catch {
            
        }
        
        // Save data
        do {
            try self.context.save()
        }
        catch {
            
        }
        
        // Re-fetch data
        self.fetchPosts()
        
    }
    
    @IBAction func addButtonPressed(_ sender: Any) {
        print("core data", posts)
        
        let realmPosts = realm.objects(RealmPost.self)
        print("realm", realmPosts)
        
        let alert = UIAlertController(title: "Add Post", message: nil, preferredStyle: .alert)
        alert.addTextField(configurationHandler: {
            textField in
            textField.placeholder = "Write Title"
        })
        alert.addTextField(configurationHandler: {
            textField in
            textField.placeholder = "Write Content"
        })
        
        let addAction = UIAlertAction(title: "Add", style: .default) { _ in
            
            let titleInput = (alert.textFields![0] as UITextField).text
            let contentInput = (alert.textFields![1] as UITextField).text
            
            // add to core data(cache)
            let newPost = Post(context: self.context)
            
            newPost.title = titleInput
            newPost.content = ""
            newPost.id = self.idCounter
            
            
            self.savePost()
            
            // add to db (realm)
            let realmPost = RealmPost()
            realmPost.title = titleInput!
            realmPost.content = contentInput!
            realmPost.id = self.idCounter
            
            self.realm.beginWrite()
            self.realm.add(realmPost)
            try! self.realm.commitWrite()
            
            // increment id counter
            self.idCounter += 1
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addAction(cancelAction)
        alert.addAction(addAction)
        present(alert, animated:  true)
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let posts = posts else {return 0}
        
        return posts.count
    }
       
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = postsTableView.dequeueReusableCell(withIdentifier: "PostTableViewCell", for: indexPath) as! PostTableViewCell
            
        guard let posts = posts else { return cell }
        
        cell.titleLabel.text = posts[indexPath.row].title
            
            
        return cell
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            postsTableView.beginUpdates()
            
            // Remove from Core Data
            removePost(postToRemove: posts![indexPath.row])
            
            // Remove from db
            try! realm.write {
                let selectedPost = posts![indexPath.row]
                let realmPost = realm.objects(RealmPost.self).filter("id == " + String(selectedPost.id))
                realm.delete(realmPost)
            }
            
            postsTableView.deleteRows(at: [indexPath], with: .fade)
            
            postsTableView.endUpdates()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let posts = posts else {return}
        let selectedPost = posts[indexPath.row]
        
        if (selectedPost.content == "") {
            // update core data from db
            var newRealmPost = realm.objects(RealmPost.self).filter("id == " + String(selectedPost.id))
            
            // add context to cache
            selectedPost.content = newRealmPost[0].content
            savePost()
        }
        
        let alert = UIAlertController(title: selectedPost.title, message: selectedPost.content, preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        let editAction = UIAlertAction(title: "Edit", style: .default) { _ in
            let alert = UIAlertController(title: selectedPost.title, message: nil, preferredStyle: .alert)
            alert.addTextField(configurationHandler: {
                textField in
                textField.text = selectedPost.content
            })
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            let saveAction = UIAlertAction(title: "Save", style: .default, handler: {_ in
                // update coreData
                selectedPost.content = (alert.textFields![0] as UITextField).text
                self.savePost()
                
                // update object in db
                try! self.realm.write {
                    var realmPost = self.realm.objects(RealmPost.self).filter("id == " + String(selectedPost.id))
                    realmPost[0].content = (alert.textFields![0] as UITextField).text!
                }
                
                
            })
            
            alert.addAction(cancelAction)
            alert.addAction(saveAction)
            self.present(alert, animated: true)
            
        }
        
        
        alert.addAction(cancelAction)
        alert.addAction(editAction)
        present(alert, animated: true)
    }
}
