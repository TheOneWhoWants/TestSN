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
    
    var json: MoreInfoJson?
    var postId: Int!

    override func viewDidLoad() {
        super.viewDidLoad()
        getJSON {
            guard let json = self.json else {return}

            self.titleLabel.text = json.post.title
            self.textLabel.text = json.post.text
            self.likesCountLabel.text = "❤️ \(json.post.likes_count.description)"
            self.postImageView.downloaded(from: json.post.postImage)
        
            let date = NSDate(timeIntervalSince1970: TimeInterval(json.post.timeshamp))
            let dayTimePeriodFormatter = DateFormatter()
            dayTimePeriodFormatter.dateFormat = "dd MMMM YYYY"
            let dateString = dayTimePeriodFormatter.string(from: date as Date)
            self.dateLabel.text = dateString
        }
    }
    
    func getJSON(completed: @escaping () -> ()) {
        guard let postId = postId else {return}
        let url = URL(string: "https://raw.githubusercontent.com/anton-natife/jsons/master/api/posts/\(postId).json")
        URLSession.shared.dataTask(with: url!) { data, response, error in
            if error == nil {
                let decoder = JSONDecoder()
                do {
                    self.json = try decoder.decode(MoreInfoJson.self, from: data!)
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

extension UIImageView {
    func downloaded(from url: URL, contentMode mode: ContentMode = .scaleAspectFit) {
        contentMode = mode
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async() { [weak self] in
                self?.image = image
            }
        }.resume()
    }
    func downloaded(from link: String, contentMode mode: ContentMode = .scaleAspectFit) {
        guard let url = URL(string: link) else { return }
        downloaded(from: url, contentMode: mode)
    }
}
