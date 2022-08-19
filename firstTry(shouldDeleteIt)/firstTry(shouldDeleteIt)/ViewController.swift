//
//  ViewController.swift
//  firstTry(shouldDeleteIt)
//
//  Created by Matthew  on 26.05.2022.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        getJSON {
            print(<#T##items: Any...##Any#>)
        }
        
    }

    func getJSON(completed: @escaping () -> ()) {
        let url = URL(string: "https://raw.githubusercontent.com/anton-natife/jsons/master/api/main.json")
        URLSession.shared.dataTask(with: url!) { data, response, error in
            if error == nil {
                let decoder = JSONDecoder()
                do {
                    self.json = try decoder.decode(Posts.self, from: data!)
                    guard let json = self.json else {return}
                    self.jsonData = json.posts
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

