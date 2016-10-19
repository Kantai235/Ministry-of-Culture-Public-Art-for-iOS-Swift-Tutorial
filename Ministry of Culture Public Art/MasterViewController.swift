//
//  MasterViewController.swift
//  Ministry of Culture Public Art
//
//  Created by 乾太 on 2016/10/14.
//  Copyright © 2016年 乾太. All rights reserved.
//

import UIKit

class MasterViewController: UITableViewController {
    
    // http://data.gov.tw/node/6219
    
    var detailViewController: DetailViewController? = nil
    var objects = [Any]()
    var _jsonPost: [Post?] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.navigationItem.leftBarButtonItem = self.editButtonItem
        
        SwiftLoading.shared.showOverlay(view: self.navigationController?.view)
        
        let _mainHttpPath = "http://cloud.culture.tw/frontsite/trans/emapOpenDataAction.do?method=exportEmapJson&typeId=F"
        let request = NSURLRequest(url: NSURL(string: _mainHttpPath)! as URL)
        let urlSession = URLSession.shared
        NSLog("[DEBUG] 準備開始 sharedSession")
        let task = urlSession.dataTask(
            with: request as URLRequest,
            completionHandler: {
                (data, responsem, error) -> Void in
                let httpResponse = responsem as? HTTPURLResponse
                if error != nil {
                    NSLog("[WARN] 遇到了錯誤，在 urlSession 當中")
                    print(error!.localizedDescription)
                } else {
                    if httpResponse!.statusCode != 404 {
                        // NSLog("[DEBUG] 準備開始解析 Json 的結構。 data=\(NSString(data: data!, encoding: String.Encoding.utf8.rawValue))")
                        self.parseJsonData(data: data! as NSData)
                        NSLog("[DEBUG] 解析完畢，準備把 TableView 的資料 reloadData")
                        self.tableView.reloadData()
                    } else {
                        NSLog("[DEBUG] urlSession data is 404.")
                    }
                }
                SwiftLoading.shared.hideOverlayView()
            }
        )
        task.resume()
        
        let addButton = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(insertNewObject(_:)))
        self.navigationItem.rightBarButtonItem = addButton
        if let split = self.splitViewController {
            let controllers = split.viewControllers
            self.detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? DetailViewController
        }
    }
    
    func parseJsonData(data: NSData) -> Void {
        
        var _jsonResult: NSArray! = nil
        do {
            _jsonResult = try JSONSerialization.jsonObject(
                with: data as Data,
                options: []
            ) as? NSArray
        } catch
            let error as NSError {
                print("Error: \(error.localizedDescription)"
            );
        }
        
        for _post in _jsonResult {
            let post = Post()
            post.name = (_post as AnyObject).value(forKey: "name") as? String
            post.representImage = (_post as AnyObject).value(forKey: "representImage") as? String
            post.intro = (_post as AnyObject).value(forKey: "intro") as? String
            post.areaCode = (_post as AnyObject).value(forKey: "areaCode") as? Int
            post.address = (_post as AnyObject).value(forKey: "address") as? String
            post.longitude = (_post as AnyObject).value(forKey: "longitude") as? String
            post.latitude = (_post as AnyObject).value(forKey: "latitude") as? String
            post.srcWebsite = (_post as AnyObject).value(forKey: "srcWebsite") as? String
            post.buildingYearName = (_post as AnyObject).value(forKey: "buildingYearName") as? String
            post.author = (_post as AnyObject).value(forKey: "author") as? String
            post.size = (_post as AnyObject).value(forKey: "size") as? String
            post.material = (_post as AnyObject).value(forKey: "material") as? String
            post.mainTypeName = (_post as AnyObject).value(forKey: "mainTypeName") as? String
            post.cityName = (_post as AnyObject).value(forKey: "cityName") as? String
            post.groupTypeName = (_post as AnyObject).value(forKey: "groupTypeName") as? String
            post.mainTypePK = (_post as AnyObject).value(forKey: "mainTypePK") as? String
            post.version = (_post as AnyObject).value(forKey: "version") as? String
            post.hitRate = (_post as AnyObject).value(forKey: "hitRate") as? Int
            _jsonPost.append(post)
        }
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.clearsSelectionOnViewWillAppear = self.splitViewController!.isCollapsed
        super.viewWillAppear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func insertNewObject(_ sender: Any) {
        objects.insert(NSDate(), at: 0)
        let indexPath = IndexPath(row: 0, section: 0)
        self.tableView.insertRows(at: [indexPath], with: .automatic)
    }
    
    // MARK: - Segues
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            if let indexPath = self.tableView.indexPathForSelectedRow {
//                let object = objects[indexPath.row] as! NSDate
                let controller = (segue.destination as! UINavigationController).topViewController as! DetailViewController
//                controller.detailItem = object
                controller.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem
                controller.navigationItem.leftItemsSupplementBackButton = true
            }
        }
    }
    
    // MARK: - Table View
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self._jsonPost.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! Cell
//        let object = objects[indexPath.row] as! NSDate
//        cell.textLabel!.text = object.description
        return cell
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            objects.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
        }
    }
    
}

