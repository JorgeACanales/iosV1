//
//  ViewController.swift
//  GroceryList
//
//  Created by Jorge Aguilar on 1/22/19.
//  Copyright © 2019 Jorge Aguilar Canales. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON


class customCell: UITableViewCell{
    
    @IBOutlet weak var lblProduct: UILabel!
    
    @IBOutlet weak var lblBranch: UILabel!
    
    @IBOutlet weak var lblPresentation: UILabel!
    
}

class ViewController:  UIViewController, UITableViewDataSource, UITableViewDelegate{

    
    @IBOutlet var tblJSON: UITableView!
    var arrRes = [[String:AnyObject]]()
    
    var valueidProduct: Int = 0
     var selectedItems: [String: Bool] = [:]
    
    var array = [Int]()
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
     
        gettingItems()
     
    }
    
    
    
    func gettingItems(){
        Alamofire.request("http://192.168.1.79/GroceryList/app/v1/getItems2.php").responseJSON { (responseData) -> Void in
            if((responseData.result.value) != nil) {
                let swiftyJsonVar = JSON(responseData.result.value!)
                print(swiftyJsonVar)
                if let resData = swiftyJsonVar["productos"].arrayObject {
                    self.arrRes = resData as! [[String:AnyObject]]
                    print("total: ", self.arrRes.count)
                    print("0")
                    var array = [AnyObject]()
                    var itemData = [AnyObject]()
                    
                    
                    
                    
                    //ArrayList<Item> itemData = new ArrayList<Item>();
                    
                    
                    itemData.append(resData as! [[String:AnyObject]] as AnyObject)
                    
                    
                    //itemData.addAll(Arrays.asList(resItems.getitems()));
                    
                    
                    /*
                    for (int i = 0; i < itemData.size(); i++) {
                        String lat = String.valueOf(itemData.get(i).getidProduct());
                        list.add(lat);
                    }*/
                    
                    
                }
                if self.arrRes.count > 0 {
                    self.tblJSON.reloadData()
                    print(">1")
                }
            }
        }
        self.displayAlertMessage(userMessage:"Getting Data!" as! String)
        
        
        
        
    }
    
    
    @IBAction func addItem(_ sender: UIButton) {
        Sessions.opItem = "Add Item"
        iragregarItem()
        
    }
    
    @IBAction func editItem(_ sender: UIButton) {
        
        Sessions.opItem = "Edit Item"
        iragregarItem()
        
    }
    
    @IBAction func deleteItem(_ sender: UIButton) {
        borrarItem(idItem: Sessions.selectedIDProduct)
        
        
    }
    
    
    
    func iragregarItem(){
        let mainStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let vc : UIViewController = mainStoryboard.instantiateViewController(withIdentifier: "AddItemVC") as UIViewController
        self.present(vc, animated: true, completion: nil)
        
        
    }
    func borrarItem(idItem:Int){
        let urlString = "http://192.168.1.79/GroceryList/app/v1/deleteItem.php"
        let headers = [
            "Content-type": "application/x-www-form-urlencoded"
            
        ]
        
        let params : [String : Int] = ["idProducto" : idItem]
        
        Alamofire.request(urlString, method: .post, parameters: params, encoding: URLEncoding.httpBody, headers: nil).responseJSON { (response) in
            
            switch response.result {
            case .success(let data):
                print("token::: " , response)
                print(response.response?.statusCode)
                print(response.result)
                let json = JSON(data)
                let estadoRespuest = json["responsecode"].stringValue
                let str = json["message"].stringValue
                let strError = json["error"].intValue
                
                print(strError)
                
                if(strError == 0){
                    
                    print("x:" + str)
                    self.displayAlertMessage(userMessage: str)
                }
                if(strError == 1){
                    self.displayAlertMessage(userMessage: str)
                    
                }
                
                break
            case .failure(let error):
                self.displayAlertMessage(userMessage: error as! String)
                
                print(error)
            }
        }
        
        
    }
    
    
    @IBAction func getData(_ sender: UIBarButtonItem) {
        gettingItems()
        
        
    }
    

    @IBAction func trashAll(_ sender: UIBarButtonItem) {
        let ids = array.map { $0 }
        //print("elemento: " , ids)
        
        for idItem in array {
            print("elemento: " , idItem)
            
            borrarItem(idItem: idItem)
            
        }
        
        /*
        StringBuilder builder = new StringBuilder();
        for (String value : list) {
            builder.append(value);
            Log.i("Value of element ",value);
            
            deleteItem(Integer.parseInt(value));
            
            
        }*/
        
        
    }
    
    func displayAlertMessage(userMessage:String)
    {
       // OperationQueue.main.addOperation {
            
            let myAlert = UIAlertController(title: "Grocery list", message:userMessage, preferredStyle: .alert);
            let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler:nil)
            myAlert.addAction(okAction);
            self.present(myAlert, animated: true, completion: nil)
       // }
        
    }//end display alert
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    

    func numberOfSections(in tableView: UITableView) -> Int {
        print("total 2:" , arrRes.count)
        return 1
      
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //let cell : UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "itemCell")!
        //var dict = arrRes[indexPath.row]
        //cell.textLabel?.text = dict["product"] as? String
        //cell.detailTextLabel?.text = dict["branch"] as? String
        
        var dict = arrRes[indexPath.row]
        
        let cell : customCell = tableView.dequeueReusableCell(withIdentifier: "itemCell")! as! customCell
            cell.lblProduct.text = dict["product"] as? String
        cell.lblBranch.text = dict["branch"] as? String
        cell.lblPresentation.text = dict["presentation"] as? String
        
        valueidProduct = (dict["idProduct"] as? Int)!
        print("DD", valueidProduct)
 
        array.append(valueidProduct)
        
        return cell
        
        
        
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrRes.count
    }
 
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedCell:UITableViewCell = tableView.cellForRow(at: indexPath)!
        selectedCell.contentView.backgroundColor =  UIColor(red: 32.0/255.0, green:
            145.0/255.0, blue: 151.0/255.0, alpha: 1.0)
        
        
       // print( arrRes[indexPath.row])
              var dict = arrRes[indexPath.row]
        print( (dict["idProduct"] as? Int)!)
        Sessions.selectedIDProduct = ((dict["idProduct"] as? Int)!)
        Sessions.selectedProduct = ((dict["product"] as? String)!)
        Sessions.selectedBranch = ((dict["branch"] as? String)!)
        Sessions.selectedPresentation =  ((dict["presentation"] as? String)!)
        
        
    }
    
    
    
    
    
    

}

