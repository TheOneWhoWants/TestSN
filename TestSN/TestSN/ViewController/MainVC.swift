//
//  MainVC.swift
//  TestSN
//
//  Created by Matthew  on 03.05.2022.
//

import UIKit

class MainVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet var sortMenu: UIStackView!
    @IBOutlet var tableViewLeadingConstraint: NSLayoutConstraint!
    @IBOutlet var tableViewTrailingConstraint: NSLayoutConstraint!
    @IBOutlet var sortByLabel: UILabel!
    @IBOutlet var sortByDateButton: UIButton!
    @IBOutlet var sortByRatingButton: UIButton!
    
    var json: Posts?
    var jsonData: [PostData] = []
    var sortItemsViewIsHidden = true
    var sortedByDateValue = false
    var sortedByRatingValue = false
   
    override func viewDidLoad() {
        super.viewDidLoad()
        getJSON {
            self.tableView.reloadData()
        }
        self.tableView.reloadData()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.rowHeight = UITableView.automaticDimension

        NSLayoutConstraint.activate([
            self.sortByLabel.widthAnchor.constraint(equalToConstant: 0.25 * self.view.frame.width),
            self.sortByDateButton.widthAnchor.constraint(equalToConstant: 0.25 * self.view.frame.width),
            self.sortByRatingButton.widthAnchor.constraint(equalToConstant: 0.25 * self.view.frame.width)
        ])

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
    
    @IBAction func sortByDatePressed(_ sender: UIButton) {
        if sortedByDateValue == false {
            jsonData = jsonData.sorted(by: {$0.timeshamp > $1.timeshamp})
        }
        sortedByRatingValue = false
        sortedByDateValue = true
        filterButtonPressed(sender)
        tableView.reloadData()
    }
    
    @IBAction func sortByRatingPressed(_ sender: UIButton) {
        if sortedByRatingValue == false {
            jsonData = jsonData.sorted(by: {$0.likes_count > $1.likes_count})
        }
        sortedByRatingValue = true
        sortedByDateValue = false
        filterButtonPressed(sender)
        tableView.reloadData()
    }
    
    @IBAction func filterButtonPressed(_ sender: UIButton) {
        UIView.animate(withDuration: 0.5, animations: {
            self.navigationItem.rightBarButtonItem?.customView?.transform = self.navigationItem.rightBarButtonItem?.customView?.transform == .identity ? CGAffineTransform(rotationAngle: 180 * Double.pi / 180 ) : .identity}) { (true) in }
        
        if sortItemsViewIsHidden == true {
            tableViewLeadingConstraint.constant = -(0.25 * self.view.frame.width)
            tableViewTrailingConstraint.constant = 0.25 * self.view.frame.width
            sortItemsViewIsHidden = false
        } else {
            tableViewLeadingConstraint.constant = 0
            tableViewTrailingConstraint.constant = 0
            sortItemsViewIsHidden = true
        }
        
        UIView.animate(withDuration: 0.2, delay: 0.0, options: .curveEaseIn) {
            self.view.layoutIfNeeded()
        } completion: { (true) in }

    }
    
    
}

extension MainVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return jsonData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellData = jsonData[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "mainCell", for: indexPath) as! MainTableViewCell
        cell.setData(data: cellData)
        
        //saving the number of title and previewText lines that depend on the button's title text
        if cell.expandButton.titleLabel?.text == "Collapse"{
            cell.previewText.numberOfLines = 0
            cell.expandButton.isHidden = false
            if cell.previewText.getAmountOfLines() > 2 || cell.title.getAmountOfLines() > 1 {
                cell.title.numberOfLines = 0
            }
        } else if cell.expandButton.titleLabel?.text == "Expand" {
            cell.previewText.numberOfLines = cell.defaultNumberOfLines
            cell.expandButton.isHidden = true
            if cell.previewText.getAmountOfLines() > 2 || cell.title.getAmountOfLines() > 1 {
                cell.expandButton.isHidden = false
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let indexPath = tableView.indexPathForSelectedRow
        let currentCell = tableView.cellForRow(at: indexPath!)
        currentCell?.setSelected(false, animated: false)
        let destination = storyboard?.instantiateViewController(withIdentifier: "MoreDetailVC") as? MoreDetailVC
        destination?.postId = jsonData[indexPath!.row].postId
        navigationController?.pushViewController(destination!, animated: true)
    }
}

