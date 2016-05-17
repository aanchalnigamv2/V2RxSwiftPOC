//
//  CityViewController.swift
//  V2RxSwiftPOC
//
//  Created by Nitesh Meshram on 5/17/16.
//  Copyright © 2016 aanchal. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources
import NSObject_Rx



class CityViewController: UIViewController {

    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    let dataSource = RxTableViewSectionedReloadDataSource<DefaultSection>()
    var shownCitiesSection: DefaultSection!
    var allCities = [String]()
    var sections = PublishSubject<[DefaultSection]>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()

        // Do any additional setup after loading the view.
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
    
    func setup() {
        allCities = ["New York", "London", "Oslo", "Warsaw", "Berlin", "Praga"]
        shownCitiesSection = DefaultSection(header: "Cities", items: allCities.toItems(), updated: NSDate())
        sections.onNext([shownCitiesSection])
        dataSource.configureCell = { (tableView, indexPath, index) in
            let cell = tableView.dequeueReusableCellWithIdentifier("cityPrototypeCell", forIndexPath: indexPath)
            cell.textLabel?.text = self.shownCitiesSection.items[indexPath.row].title
            return cell
        }
        
        sections
            .asObservable()
            .bindTo(tableView.rx_itemsWithDataSource(dataSource))
            .addDisposableTo(rx_disposeBag) // Instead of creating the bag again and again, use the extension NSObject_rx
        searchBar
            .rx_text
            .throttle(0.5, scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .subscribeNext { [unowned self] (query) in
                let items: [String]
                if query.characters.count > 0 {
                    items = self.allCities.filter { $0.hasPrefix(query) }
                } else {
                    items = self.allCities
                }
                self.shownCitiesSection = DefaultSection(
                    original: self.shownCitiesSection,
                    items: items.toItems()
                )
                
                self.sections.onNext([self.shownCitiesSection])
            }
            .addDisposableTo(rx_disposeBag)
    }

}

extension CollectionType where Self.Generator.Element == String {
    func toItems() -> [DefaultItem] {
        return self.map { DefaultItem(title: $0, dateChanged: NSDate()) }
    }
}
