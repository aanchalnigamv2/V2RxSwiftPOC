//
//  ViewController.swift
//  V2RxSwiftPOC
//
//  Created by aanchal on 09/05/16.
//  Copyright © 2016 aanchal. All rights reserved.
//

import UIKit
import Foundation
import RxCocoa
import RxSwift
import Alamofire



class ViewController: UIViewController, UIAlertViewDelegate {

    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var showCities: UILabel!
  
    let disposeBag = DisposeBag()
    var viewModel = WeatherViewModel()
    var boundToViewModel = false
    var array = [AnyObject]()
    
    var myArray : Variable<NSArray>!
    
    var arrayObj: ObservableArray<String> = ["foo", "bar", "buzz"]
    
    var testArray1 : [String] = ["A", "B", "C"]
    var testArray2 = PublishSubject<[String]>()
    
    func bindSourceToLabel(source: PublishSubject<String?>, label: UILabel) {
        source
            .subscribeNext { text in
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    label.text = text
                })
            }
            .addDisposableTo(disposeBag)
    }
    
    var alertController: UIAlertController? {
        didSet {
            if let alertController = alertController {
                alertController.addAction(UIAlertAction(title: "Ok", style: .Default, handler: nil))
                presentViewController(alertController, animated: true, completion: nil)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        myArray = Variable(testArray1)
//        
//        myArray.asObservable()
//            .subscribeNext { value in
//            print(value)
//        }
        
        
//        arrayObj.rx_elements().subscribe() {
//            print($0)
//        }
        
        arrayObj.rx_elements().subscribeNext {
            print($0)
        
        
        }
        
//        arrayObj.append("coffee")
//        arrayObj[2] = "milk"
//        arrayObj.removeAll()
        
        arrayObj.append("Test")
        
        cityTextField.rx_text
            .debounce(0.3, scheduler: MainScheduler.instance)
            
            .subscribeNext { searchText in
                self.viewModel.searchText = searchText
            }
            .addDisposableTo(disposeBag)
        
        
        bindSourceToLabel(viewModel.cityName, label: cityNameLabel)
        bindSourceToLabel(viewModel.degrees, label: tempLabel)
        bindSourceToLabel(viewModel.weatherDescription, label: descriptionLabel)
        
        
        
        viewModel.observableLanguageArray.subscribeNext { data in
            self.array = data
            print(self.array)
          
          for i in 0  ..< self.array.count  {
            self.showCities.text = self.showCities.text! + "\(self.array[i])"
          }
          
          
//            self.showCities.text = "\(self.array)"
        }
        .addDisposableTo(disposeBag)
      
        viewModel.errorAlertController.subscribeNext { alertController in
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.alertController = alertController
            })
        }
        .addDisposableTo(disposeBag)
        
        testArray1.append("D")
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        testArray2.on(.Next(Array(testArray1)))

        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
  @IBAction func addCity(sender: AnyObject) {
    
//    myArray.value = ["b"]

    arrayObj.append("coffee")
    
//    if let newCity = cityTextField.text {
//      Weather().languageArray.addObject(newCity)
//    }
    
    
  }
    

}

