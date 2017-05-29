//
//  ViewController.swift
//  What is the weather
//
//  Created by Jonathan Lam on 2017-05-29.
//  Copyright © 2017 Jonathan Lam. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet var cityTextField: UITextField!
    @IBOutlet var resultLabel: UILabel!
    @IBAction func getWeather(_ sender: Any) {

        if let url = URL(string: "http://www.weather-forecast.com/locations/" + cityTextField.text!.replacingOccurrences(of: " ", with: "-") + "/forecasts/latest") {
        
        let request = NSMutableURLRequest(url: url)
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) {
            Data, Response, Error in
            
            var message = ""
            
            if Error != nil {
                print(Error)
            } else {
                if let unwrappedData = Data {
                    let dataString = NSString(data: unwrappedData, encoding: String.Encoding.utf8.rawValue)
                    
                    var stringSeparator = "Weather Forecast Summary:</b><span class=\"read-more-small\"><span class=\"read-more-content\"> <span class=\"phrase\">"
                    
                    if let contentArray = dataString?.components(separatedBy: stringSeparator) {
                        if contentArray.count > 1 {
                            stringSeparator = "</span>"
                            
                            let newContentArray = contentArray[1].components(separatedBy: stringSeparator)
                            if newContentArray.count > 1 {
                                message = newContentArray[0].replacingOccurrences(of: "&deg;", with: "°")
                                print(message)
                            }
                            
                        }
                        //                        print(contentArray)
                    }
                    //                    print(dataString)
                }
            }
            
            if message == "" {
                message = "The weather there couldn't be found. Please try again."
            }
            DispatchQueue.main.sync(execute: {
                self.resultLabel.text = message
            })
        }
        
        task.resume()
        } else {
            resultLabel.text = "The weather there couldn't be found. Please try again."
        }
        self.view.endEditing(true)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    // this method should be called when the return button is pressed
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // shut down the keyboard for the text field that's being edited
        textField.resignFirstResponder()
        
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

