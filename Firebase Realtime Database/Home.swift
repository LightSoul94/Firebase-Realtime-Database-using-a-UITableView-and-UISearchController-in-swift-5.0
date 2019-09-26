//
//  Home.swift
//  Firebase Realtime Database
//
//  Created by Gianluca Caliendo on 25/09/2019.
//  Copyright © 2019 Gianluca Caliendo. All rights reserved.
//

import UIKit
import FirebaseDatabase
import Alamofire
//import SVProgressHUD

class Home: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {

    
    //Interface Builders
    @IBOutlet weak var searchContainerView: UIView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var Table: UITableView!
    
       
        //UISearchController variables
        var searchController: UISearchController!
        var casaArray = [Casa]()
        var currentCasaArray = [Casa]() //update table
        var searching = false
       
        //Table variables
        var populator: NSMutableArray = []

        //Database variables
        var thumbnail = [String]()
        var address = [String]()
        var detail = [String]()
        var rooms = [Int]()
        var price = [Double]()
    
    override func viewWillAppear(_ animated: Bool) {
        downloadDataFromFirebase()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        configureSearchController()
        setUpSearchBar()
        alterLayout()
    }

    
    //MARK: - Search Bar
    func configureSearchController() {
        searchController = UISearchController(searchResultsController: nil)
         searchController.obscuresBackgroundDuringPresentation = false
         searchContainerView.addSubview(searchController.searchBar)
         searchController.searchBar.delegate = self
//         searchController.searchBar.barTintColor = UIColor(red:0.04, green:0.09, blue:0.11, alpha:1.0)
         
//         UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).backgroundColor = UIColor(red:0.10, green:0.15, blue:0.17, alpha:1.0)
         
//        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).textColor = UIColor.white
         
         
//         let attributes:[NSAttributedString.Key:Any] = [
//             NSAttributedString.Key.foregroundColor : UIColor(red:0.99, green:0.69, blue:0.20, alpha:1.0),
//         ]
//         UIBarButtonItem.appearance(whenContainedInInstancesOf: [UISearchBar.self]).setTitleTextAttributes(attributes, for: .normal)
    }
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        currentCasaArray = casaArray.filter({ Casa -> Bool in
            if searchText.isEmpty {
                searching = false
                return true
            }
            self.searching = true
            return Casa.address.lowercased().contains(searchText.lowercased())
            })
        Table.reloadData()
    }
    
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = nil
        searchBar.showsCancelButton = false
        // Remove focus from the search bar.
        searchBar.endEditing(true)
    }
    
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        //restore data
        currentCasaArray = casaArray
        Table.reloadData()
    }
    
    
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
            currentCasaArray = casaArray
            Table.reloadData()
    }
    
    
    //MARK: - Firebase Retrieving Data
    func downloadDataFromFirebase() {
//        SVProgressHUD.show()
        //richiama dati dal database
        let rootRef = Database.database().reference()
        let conditionalRef = rootRef.child("Rents")
        conditionalRef.observe(.value) {(snap: DataSnapshot) in
            // Get all the children from snapshot you got back from Firebase
            let snapshotChildren = snap.children
            // Loop over all children (code) in Firebase
            
            var i = 0
            
            while let child = snapshotChildren.nextObject() as? DataSnapshot {
                // Get code node key and save it to they array
                self.populator.add(child.key)
                if self.populator.contains("\(child.key)") {
                    let userRef = rootRef.child("Rents").child("\(child.key)")
                    
                    userRef.observeSingleEvent(of: .value, with: { snapshot in
                        let userDict = snapshot.value as! [String: Any]
                        
                            let address1 = userDict["Address"] as! String
                            self.address.append(address1)
                            
                            let detail1 = userDict["Detail"] as! String
                            self.detail.append(detail1)
                            
                            let rooms1 = userDict["numberOfRooms"] as! Int
                            self.rooms.append(rooms1)
                            
                            let rentPrice1 = userDict["Price"]  as! Double
                            self.price.append(rentPrice1)
                            
                            let rentimageURL1 = userDict["imageURL"]  as! String
                            self.thumbnail.append(rentimageURL1)
                        
                        
                            self.casaArray.append(Casa(address: self.address[i], detail: self.detail[i], image: self.thumbnail[i], price: self.price[i], rooms: self.rooms[i]))

                            i += 1
                        
                        self.currentCasaArray = self.casaArray
                        
                        self.Table.reloadData()
//                        SVProgressHUD.dismiss()
                    }) //end second observeSingleEvent
                    self.Table.reloadData()

                }
              else {
//                    SVProgressHUD.dismiss()
                    let alert = UIAlertController(title: "Errore", message: "Nessun annuncio trovato", preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: "ok", style: UIAlertAction.Style.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                }
                
            } //end searching object in Rents node
//            self.setUpCasa()
            self.Table.reloadData()
            
            } //end first observeSingleEvent
        
        //elimina i duplicati

    }
    
    
    //MARK: - TableView
    func configureTableView() {
        Table.delegate = self
        Table.dataSource = self
        Table.reloadData()
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return currentCasaArray.count
        }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) ->
        UITableViewCell {
            //        let row = indexPath.row
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as? TableViewCell else {
                return UITableViewCell()
            }
            
            
            
            cell.address.text = currentCasaArray[indexPath.row].address
            
            
            let formatter = NumberFormatter()
            formatter.locale = Locale(identifier: "it_IT") // Change this to another locale if you want to force a specific locale, otherwise this is redundant as the current locale is the default already
            formatter.numberStyle = .currency
            if let formattedprice = formatter.string(from: currentCasaArray[indexPath.row].price as NSNumber) {
                
                cell.descript.text = "n. : \(currentCasaArray[indexPath.row].rooms) - price:  \(formattedprice)"
            }
            
            
            
            
            Alamofire.request("\(currentCasaArray[indexPath.row].image)").response { response in
                guard let image = UIImage(data:response.data!) else {
                    // Handle error
            return
                    
                }
                            let imageData = image.pngData()
                            cell.thumbnail.contentMode = .scaleAspectFit
                            cell.thumbnail.image = UIImage(data : imageData!)
                        }
            
            return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case indexPath.row:
            
            if searching == true {
                self.dismiss(animated: true, completion: nil)
                searching = false
                performSegue(withIdentifier: "more_info", sender: nil)
            } else {
                performSegue(withIdentifier: "more_info", sender: nil)
            }
            default:
            break;
        }
    }
    
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 180
    }
    
    
        //MARK: - prepare
        override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            if segue.identifier == "more_info" {
                if let indexPath = Table.indexPathForSelectedRow {
                    let destinationController = segue.destination as! DetailViewController
                    destinationController.webSite = currentCasaArray[indexPath.row].detail
                }
            }
        }

    
    //MARK: - Configure Casa Class
        private func setUpSearchBar() {
            searchBar.delegate = self
        }
        
        
        func alterLayout() {
            Table.tableHeaderView = UIView()
            // search bar in section header
            Table.estimatedSectionHeaderHeight = 50
            // search bar in navigation bar
            navigationItem.leftBarButtonItem = UIBarButtonItem(customView: searchBar)
            searchBar.showsScopeBar = false // you can show/hide this dependant on your layout
            searchBar.placeholder = "Search"
        }
        

    //MARK: - Initialize Casa Class
    class Casa {
        var address: String
        var price: Double
        var image: String
        var detail: String
        var rooms: Int
        
        init(address: String, detail: String, image: String, price: Double, rooms: Int) {
            self.address = address
            self.detail = detail
            self.image = image
            self.price = price
            self.rooms = rooms
        }
    }

}
