//
//  MainVC.swift
//  TestSN
//
//  Created by Matthew  on 03.05.2022.
//

import UIKit

class MainVC: UIViewController {
    
    @IBOutlet var tableView: UITableView!
    
    var json: Posts?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getJSON {
            self.tableView.reloadData()
        }
        tableView.reloadData()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        tableView.rowHeight = UITableView.automaticDimension
    }
    
    func getJSON(completed: @escaping () -> ()) {
        let url = URL(string: "https://raw.githubusercontent.com/anton-natife/jsons/master/api/main.json")
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

extension MainVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return json?.posts.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let json = json else {return UITableViewCell(style: .default, reuseIdentifier: nil)}
        let cellData = json.posts[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "mainCell", for: indexPath) as! MainTableViewCell
        cell.setData(data: cellData)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let indexPath = tableView.indexPathForSelectedRow
        let currentCell = tableView.cellForRow(at: indexPath!)
        currentCell?.setSelected(false, animated: false)
        let destination = storyboard?.instantiateViewController(withIdentifier: "MoreDetailVC") as? MoreDetailVC
        destination?.postId = json?.posts[indexPath!.row].postId
        navigationController?.pushViewController(destination!, animated: true)
    }
}
