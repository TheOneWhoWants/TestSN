//
//  MoreDetailVC.swift
//  TestSN
//
//  Created by Matthew  on 03.05.2022.
//

import UIKit

class MoreDetailVC: UIViewController {
    
    @IBOutlet var postImageView: UIImageView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var textLabel: UILabel!
    @IBOutlet var likesCountLabel: UILabel!
    @IBOutlet var dateLabel: UILabel!
    
    var json: Posts?
    var postId: Int!

    override func viewDidLoad() {
        super.viewDidLoad()
        getJSON {
            
        }
    }
    
    func getJSON(completed: @escaping () -> ()) {
        guard let postId = postId else {return}
        let url = URL(string: "https://raw.githubusercontent.com/anton-natife/jsons/master/api/posts/\(postId).json")
        URLSession.shared.dataTask(with: url!) { data, response, error in
            if error == nil {
                let decoder = JSONDecoder()
                do {
                    self.json = try decoder.decode(Posts.self, from: data!)
                    DispatchQueue.main.async {
                        completed()
                    }
                } catch {
                    print(error)
                }
            }
        }.resume()
    }
}
