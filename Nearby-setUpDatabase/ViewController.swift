//
//  ViewController.swift
//  Nearby-setUpDatabase
//
//  Created by 塗木冴 on 2019/03/07.
//  Copyright © 2019 SaeNuruki. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var inputTextField: UITextField!
    @IBOutlet weak var outputTextView: UITextView!

    override func viewDidLoad() {
        super.viewDidLoad()
        inputTextField.keyboardType = .URL
        outputTextView.isEditable = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBAction func tapButton(_ sender: Any) {

        let urlString = inputTextField.text ?? ""
        let result = predict(by: getImage(by: urlString))
        outputTextView.text = String(describing: result)
    }

}

extension ViewController {

    func getImage(by urlString: String) -> UIImage {
        let url = URL(string: urlString)
        do {
            let data = try Data(contentsOf: url!)
            return UIImage(data: data)!
        } catch let err {
            print("Error : \(err.localizedDescription)")
        }
        return UIImage()
    }

    func predict(by image: UIImage) -> [String : Double] {

        let model = GoogLeNetPlaces()
        guard let pixelBuffer = image.pixelBuffer(width: 224, height: 224) else {fatalError()}
        let input = GoogLeNetPlacesInput(sceneImage: pixelBuffer)
        let output = try! model.prediction(input: input)
        return output.sceneLabelProbs
    }
}

extension ViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField:UITextField) -> Bool {
        print("キーボードを閉じる前")
        // キーボードを閉じる処理
        self.view.endEditing(true)
        print("キーボードを閉じたあと")
        return true
    }
}
