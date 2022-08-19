//
//  MainTableViewCell.swift
//  TestSN
//
//  Created by Matthew  on 03.05.2022.
//

import UIKit

class MainTableViewCell: UITableViewCell {
    
    @IBOutlet var stackView: UIStackView!
    @IBOutlet var title: UILabel!
    @IBOutlet var previewText: UILabel!
    @IBOutlet var likesCount: UILabel!
    @IBOutlet var expandButton: UIButton!
    @IBOutlet var date: UILabel!
    
    let defaultNumberOfLines = 2
    
    func setData(data: PostData) {
        self.title.text = data.title
        self.previewText.text = data.preview_text
        self.likesCount.text = String("❤️ \(data.likes_count)")
        
        let currentTimeStamp = NSDate().timeIntervalSince1970
        let timeDifferance = currentTimeStamp - Double(data.timeshamp)
        let exampleDate = Date().addingTimeInterval(-timeDifferance)
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .full
        let relativeDate = formatter.localizedString(for: exampleDate, relativeTo: Date())
        self.date.text = relativeDate
        
        self.previewText.numberOfLines = self.defaultNumberOfLines
        self.title.numberOfLines = 1
    }

    @IBAction func expandButtonPressed(_ sender: UIButton) {
        let table = self.superview as! UITableView
        
        table.beginUpdates()
        if previewText.numberOfLines == defaultNumberOfLines && title.getAmountOfLines() > 1 {
            previewText.numberOfLines = 0
            title.numberOfLines = 0
            sender.setTitle("Collapse", for: .normal)
        }else if previewText.numberOfLines == defaultNumberOfLines && title.getAmountOfLines() <= 1 {
            previewText.numberOfLines = 0
            sender.setTitle("Collapse", for: .normal)
        }else {
            previewText.numberOfLines = defaultNumberOfLines
            title.numberOfLines = 1
            sender.setTitle("Expand", for: .normal)
        }
        table.endUpdates()
    }
    
}

extension UILabel {
    func getAmountOfLines() -> Int {
        guard let myText = self.text as NSString? else {return 0}
        let rect = CGSize(width: self.bounds.width, height: CGFloat.greatestFiniteMagnitude)
        let labelSize = myText.boundingRect(with: rect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: self.font as Any], context: nil)
        return Int(ceil(CGFloat(labelSize.height) / self.font.lineHeight))
    }
}
