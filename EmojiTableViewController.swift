//
//  EmojiTableViewController.swift
//  EmojisDictionary
//
//  Created by Andres Gutierrez on 1/11/18.
//  Copyright © 2018 Andres Gutierrez. All rights reserved.
//


import UIKit

class EmojiTableViewController: UITableViewController {
    
    @IBOutlet weak var navEditButton: UIBarButtonItem!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let loadedEmojiFile = Emoji.loadFromFile()
        if loadedEmojiFile.count > 0 {
            print("file loaded")
        } else {
            print("samples loaded")
            emojis = Emoji.loadSampleEmojis()
        }
        
        emojiCategorization(source: emojis)
        print("ETVC viewDidLoad")
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func navEditButtonTapped(_ sender: UIBarButtonItem) {
        let tableViewEditingMode = tableView.isEditing
        tableView.setEditing(!tableViewEditingMode, animated: true)
        
        if tableView.isEditing == true {
            navEditButton.title = "Done"
        } else { navEditButton.title = "Edit" }
    }
    
    
    // MARK: - Table view data source
    
    // Data Source and Categorization
    var emojis: [Emoji] = []
    var emojisCategorized: [[Emoji]] = [[],[],[],[],[],[],[]]
    
    
    func emojiCategorization(source: [Emoji]) {
        emojisCategorized[0].removeAll()
        emojisCategorized[1].removeAll()
        emojisCategorized[2].removeAll()
        emojisCategorized[3].removeAll()
        emojisCategorized[4].removeAll()
        emojisCategorized[5].removeAll()
        emojisCategorized[6].removeAll()
        
        for index in source {
            switch index.category{
            case emojiCategory.Smileys:
                emojisCategorized[0].append(index)
            case emojiCategory.People:
                emojisCategorized[1].append(index)
            case emojiCategory.Animals:
                emojisCategorized[2].append(index)
            case emojiCategory.Nature:
                emojisCategorized[3].append(index)
            case emojiCategory.Food:
                emojisCategorized[4].append(index)
            case emojiCategory.Objects:
                emojisCategorized[5].append(index)
            case emojiCategory.Symbols:
                emojisCategorized[6].append(index)
            }
        }
    }
    
    // Section Configuration
    override func numberOfSections(in tableView: UITableView) -> Int {
        return emojisCategorized.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return emojiCategory.Smileys.rawValue
        case 1:
            return emojiCategory.People.rawValue
        case 2:
            return emojiCategory.Animals.rawValue
        case 3:
            return emojiCategory.Nature.rawValue
        case 4:
            return emojiCategory.Food.rawValue
        case 5:
            return emojiCategory.Objects.rawValue
        case 6:
            return emojiCategory.Symbols.rawValue
        default:
            return "nope"
        }
    }
    
    // Cells
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return emojisCategorized[0].count
        case 1:
            return emojisCategorized[1].count
        case 2:
            return emojisCategorized[2].count
        case 3:
            return emojisCategorized[3].count
        case 4:
            return emojisCategorized[4].count
        case 5:
            return emojisCategorized[5].count
        case 6:
            return emojisCategorized[5].count
        default:
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EmojiCell", for: indexPath) as! EmojiTableViewCell
        let emoji = emojisCategorized[indexPath.section][indexPath.row]
        
        cell.update(with: emoji)
        cell.showsReorderControl = true
        
        return cell
    }
    
    
    // Editing Cell Contents
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
        let selectedEmoji = emojisCategorized[fromIndexPath.section].remove(at: fromIndexPath.row)
        if fromIndexPath.section == to.section {
            emojisCategorized[fromIndexPath.section].insert(selectedEmoji, at: to.row)
            tableView.reloadData()
        } else {
            emojisCategorized[fromIndexPath.section].insert(selectedEmoji, at: fromIndexPath.row)
            tableView.reloadData()
        }
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            emojisCategorized[indexPath.section].remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    
    // MARK: Navigation
    
    // Prepare for segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "EditEmoji" {
            let indexPath = tableView.indexPathForSelectedRow!
            let emoji = emojisCategorized[indexPath.section][indexPath.row]
            let addEditEmojiNav = segue.destination as! AddEditTableViewController
            addEditEmojiNav.emoji = emoji
        }
    }
    
    @IBAction func unwindToEmojiTableView(segue: UIStoryboardSegue) {
        guard segue.identifier == "saveUnwind" else { return }
        let sourceViewController = segue.source as! AddEditTableViewController
        
        if let emoji = sourceViewController.emoji {
            if let selectedIndexPath = tableView.indexPathForSelectedRow {
                emojisCategorized[selectedIndexPath.section][selectedIndexPath.row] = emoji
                print("unwind 1")
                tableView.reloadRows(at: [selectedIndexPath], with: .none)
            } else {
                print("emojis count 1: \(emojis.count)")
                emojis.append(emoji)
                print("emojis count 2: \(emojis.count)")
                emojiCategorization(source: emojis)
                print("unwind2")
                tableView.reloadData()
            }
        }
    }
    
}

