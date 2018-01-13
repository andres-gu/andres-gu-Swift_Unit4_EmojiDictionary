//
//  AddEditTableViewController.swift
//  EmojisDictionary
//
//  Created by Andres Gutierrez on 1/11/18.
//  Copyright © 2018 Andres Gutierrez. All rights reserved.
//


import UIKit

class AddEditTableViewController: UITableViewController, UITextFieldDelegate {
    
    // Emoji object
    var emoji: Emoji?
    
    // Outlets
    @IBOutlet weak var symbolTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var descriptionTextField: UITextField!
    @IBOutlet weak var usageTextField: UITextField!
    @IBOutlet weak var categoryTextField: UITextField!
    @IBOutlet weak var navTitleLabel: UINavigationItem!
    
    let symbolTextLength = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        symbolTextField.delegate = self
        
        if let emoji = emoji {
            symbolTextField.text = emoji.symbol
            nameTextField.text = emoji.name
            descriptionTextField.text = emoji.description
            usageTextField.text = emoji.usage
            categoryTextField.text = emoji.category
            navTitleLabel.title = "Edit \(emoji.symbol)"
        }
        
        
        updateSaveButtonState()
        createCategoryPicker()
        createToolbar()
        
        
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let symbol = symbolTextField.text else { return true }
        let newLength = symbol.count + string.count - range.length
        return newLength <= 1
    }
    
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    func updateSaveButtonState() {
        let symbolText = symbolTextField.text ?? ""
        let nameText = nameTextField.text ?? ""
        let descriptionText = descriptionTextField.text ?? ""
        let usageText = usageTextField.text ?? ""
        let categoryText = categoryTextField.text ?? ""
        
        saveButton.isEnabled = !symbolText.isEmpty && !nameText.isEmpty && !descriptionText.isEmpty && !usageText.isEmpty && !categoryText.isEmpty && symbolText.count == 1
    }
    
    
    @IBAction func textEditingChanged(_ sender: UITextField) {
        updateSaveButtonState()
    }
    
    // Category Picker:
    let emojiCategories = [emojiCategory.Smileys.rawValue, emojiCategory.People.rawValue, emojiCategory.Animals.rawValue, emojiCategory
    .Nature.rawValue, emojiCategory.Food.rawValue, emojiCategory.Objects.rawValue, emojiCategory.Symbols.rawValue]
    var selectedCategory: String?
    
    func createCategoryPicker() {
        let categoryPicker = UIPickerView()
        categoryPicker.delegate = self
        
        categoryTextField.inputView = categoryPicker
    }
    
    // Create Toolbar:
    func createToolbar(){
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(AddEditTableViewController.dismissKeyboard))
        
        toolBar.setItems([doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        categoryTextField.inputAccessoryView = toolBar
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        guard segue.identifier == "saveUnwind" else { return }
        let symbol = symbolTextField.text ?? ""
        let name = nameTextField.text ?? ""
        let description = descriptionTextField.text ?? ""
        let usage = usageTextField.text ?? ""
        let category = categoryTextField.text ?? ""
        
        emoji = Emoji(symbol: symbol, name: name, description: description, usage: usage, category: category)
    }
}

extension AddEditTableViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return emojiCategories.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return emojiCategories[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedCategory = emojiCategories[row]
        categoryTextField.text = selectedCategory
    }
    
    
}
