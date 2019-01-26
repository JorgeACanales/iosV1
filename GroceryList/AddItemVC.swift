
import UIKit
import Alamofire
import SwiftyJSON



class AddItemVC:  UIViewController{
    
    @IBOutlet weak var txtProduct: UITextField!
    
    
    @IBOutlet weak var txtBranch: UITextField!
    
    
    @IBOutlet weak var txtPresentation: UITextField!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        if (Sessions.opItem == "Edit Item"){
            getDataItem()
            
        }
        
        
        
        
    }
    
    @IBAction func back(_ sender: UIButton) {
        let mainStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let vc : UIViewController = mainStoryboard.instantiateViewController(withIdentifier: "ViewController") as UIViewController
        self.present(vc, animated: true, completion: nil)
        
    }
    
    func getDataItem(){
        self.txtProduct.text = Sessions.selectedProduct
        self.txtBranch.text = Sessions.selectedBranch
        self.txtPresentation.text = Sessions.selectedPresentation
        
    }
    
    
    @IBAction func btnAddItem(_ sender: UIButton) {
        
        if(Sessions.opItem == "Add Item"){
            addItem()
            
        }
        if (Sessions.opItem == "Edit Item") {
            editItem()
        }
       
        
    }
    
    func addItem(){
        let ava : Int = 1
        var myava = String(ava)
        
        let urlString = "http://192.168.1.79/GroceryList/app/v1/addItem.php"
        let headers = [
            "Content-type": "application/x-www-form-urlencoded"
            
        ]
        
        let params : [String : String] = ["product" : self.txtProduct.text!,
                                          "branch" : self.txtBranch.text!,
                                          "presentation" : self.txtPresentation.text!,
                                          "available" : myava]
        
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
    func editItem(){
        let ava : Int = Sessions.selectedIDProduct
        var myava = String(ava)
        let urlString = "http://192.168.1.79/GroceryList/app/v1/editItem.php"
        let headers = [
            "Content-type": "application/x-www-form-urlencoded"
            
        ]
        
        let params : [String : String] = ["product" : self.txtProduct.text!,
                                          "branch" : self.txtBranch.text!,
                                          "presentation" : self.txtPresentation.text!,
                                          "idProducto" : myava]
        
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
    
    
    
    
}




