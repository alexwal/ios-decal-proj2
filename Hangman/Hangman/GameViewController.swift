//
//  GameViewController.swift
//  Hangman
//
// Author: Alex Walczak

import UIKit
import Foundation

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
}

class GameViewController: UIViewController, UITextFieldDelegate {

    @IBAction func startOverButtonPressed(_ sender: AnyObject) {
        blankGame()
    }
    
    @IBOutlet weak var remainingLettersLabel: UILabel!
    @IBOutlet weak var incorrectGuessesLabel: UILabel!
    @IBOutlet weak var textField: UITextField!
    var guessedLetters: [String] = []
    var incorrectGuesses: [String] = []
    var phrase: String = ""
    var mistakes = 1
    var won = false
    var lost = false
    @IBOutlet weak var hangmanImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.hideKeyboardWhenTappedAround()
        blankGame()
    }
    
    func blankGame() {
        let hangmanPhrases = HangmanPhrases() // Loads the model and and a data point from model.
        phrase = hangmanPhrases.getRandomPhrase()
        guessedLetters = []
        incorrectGuesses = []
        mistakes = 1
//        textField.text = ""
        won = false
        lost = false
        var guessedPhrase = ""
        for i in phrase.characters {
            if i != " " {
                guessedPhrase = guessedPhrase + "_ "
            } else {
                guessedPhrase = guessedPhrase + "  "
            }
        }
        remainingLettersLabel.text = guessedPhrase
        incorrectGuessesLabel.text = "Incorrect Guesses: "
        updateImage()
        print(phrase)
    }
    
    @IBAction func guessButtonPressed(_ sender: AnyObject) {
        // Check if current guess is correct.
        if won {
            displayAlert(string: "won")
            return
        } else if lost {
            displayAlert(string: "lost")
            return
        }
        if textField.text! == "Single letter..." {
            return
        }
        let guessedLetter = textField.text?.uppercased()
        // Check if input valid
        if guessedLetter! != "" && guessedLetter! != " " {
            if guessedLetters.contains(guessedLetter!) || (phrase.contains(guessedLetter!) == false) {
                incorrectGuesses.append(String(guessedLetter!))
                incorrectGuessesLabel.text?.append(guessedLetter! + ", ")
                mistakes += 1
            }
            guessedLetters.append(String(guessedLetter!))
            var newGuessedPhrase = ""
            for i in phrase.characters {
                if guessedLetters.contains(String(i)) {
                    newGuessedPhrase = newGuessedPhrase + String(i) + " "
                } else if String(i) != " " {
                    newGuessedPhrase = newGuessedPhrase + "_ "
                } else {
                    newGuessedPhrase = newGuessedPhrase + "  "
                }
            }
            remainingLettersLabel.text = newGuessedPhrase
            textField.text = ""
            updateImage()
        }
        // check if lost
        if mistakes >= 7 {
            lost = true
        }
        // check if won
        if mistakes < 7 {
            won = true
            for i in phrase.characters {
                if (i != " ") && (guessedLetters.contains(String(i)) == false) {
                    won = false // one letter still missing!
                }
            }
            if won {
                displayAlert(string: "won")
            }
        }
    }
    
    func updateImage() {
        // If a mistake has been made, the image next in the sequence will be shown.
        hangmanImage.image = UIImage(named: "hangman" + String(mistakes) + ".gif")
        if mistakes >= 7 {
            lost = true
            displayAlert(string: "lost")
        }
    }
    
    // Called when modifying the single text field in this View Controller.
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let currentCharacterCount = textField.text?.characters.count ?? 0
        if (range.length + range.location > currentCharacterCount){
            return false
        }
        let newLength = currentCharacterCount + string.characters.count - range.length
        return newLength <= 1
    }

    func displayAlert(string: String) {
        print(string)
        if string == "lost" {
            let alertController = UIAlertController(title: "You lost!", message: "The correct phrase was: " + phrase, preferredStyle: UIAlertControllerStyle.alert)
            let DestructiveAction = UIAlertAction(title: "Start Over", style: UIAlertActionStyle.destructive) { (result : UIAlertAction) -> Void in
                self.startOverButtonPressed(self)
            }
            let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) { (result : UIAlertAction) -> Void in
            }
            alertController.addAction(DestructiveAction)
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
        } else if string == "won" {
            let alertController = UIAlertController(title: "You won!", message: "Good work!", preferredStyle: UIAlertControllerStyle.alert)
            let DestructiveAction = UIAlertAction(title: "Start Over", style: UIAlertActionStyle.destructive) { (result : UIAlertAction) -> Void in
                self.startOverButtonPressed(self)
            }
            let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) { (result : UIAlertAction) -> Void in
            }
            alertController.addAction(DestructiveAction)
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
