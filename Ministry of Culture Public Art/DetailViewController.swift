//
//  DetailViewController.swift
//  Ministry of Culture Public Art
//
//  Created by 乾太 on 2016/10/14.
//  Copyright © 2016年 乾太. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class DetailViewController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    // 1.創建 locationManager
    var locationManager = CLLocationManager()
    @IBOutlet weak var detailDescriptionLabel: UILabel!
    @IBOutlet weak var uimap: MKMapView!
    
    var annTitle: String = ""
    var annSubtitle: String = ""
    var annLatitude: Double = 120.0
    var annLongitude: Double = 120.0
    var annImageView: String = ""
    var annLabelText: String = ""
    
    // var location : CLLocationManager!; //座標管理元件
    
    func configureView() {
        locationManager.requestWhenInUseAuthorization()
        // 1. 還沒有詢問過用戶以獲得權限
        if CLLocationManager.authorizationStatus() == .notDetermined {
            locationManager.requestAlwaysAuthorization()
        }
        // 2. 用戶不同意
        else if CLLocationManager.authorizationStatus() == .denied {
//            showAlert("Location services were previously denied. Please enable location services for this app in Settings.")
        }
        // 3. 用戶已經同意
        else if CLLocationManager.authorizationStatus() == .authorizedAlways {
            locationManager.startUpdatingLocation()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.configureView()
        
        // 建立一個 CLLocationManager
        self.locationManager = CLLocationManager();
        
        // 設置委任對象
        self.locationManager.delegate = self;
        
        // 距離篩選器 用來設置移動多遠距離才觸發委任方法更新位置
        self.locationManager.distanceFilter = kCLLocationAccuracyNearestTenMeters
        
        // 取得自身定位位置的精確度
        self.locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers
        
        /* kCLLocationAccuracyBestForNavigation：精確度最高，適用於導航的定位。
         * kCLLocationAccuracyBest：精確度高。
         * kCLLocationAccuracyNearestTenMeters：精確度 10 公尺以內。
         * kCLLocationAccuracyHundredMeters：精確度 100 公尺以內。
         * kCLLocationAccuracyKilometer：精確度 1 公里以內。
         * kCLLocationAccuracyThreeKilometers：精確度 3 公里以內。
         */
        
//        // 地圖預設顯示的範圍大小 (數字越小越精確)
//        let latDelta = 0.1
//        let longDelta = 0.1
//        let currentLocationSpan:MKCoordinateSpan =
//            MKCoordinateSpanMake(latDelta, longDelta)
//        
//        // 設置地圖顯示的範圍與中心點座標
//        let center:CLLocation = CLLocation(
//            latitude: self.annLatitude, longitude: self.annLongitude)
//        let currentRegion:MKCoordinateRegion =
//            MKCoordinateRegion(
//                center: center.coordinate,
//                span: currentLocationSpan
//        )
//        self.uimap.setRegion(currentRegion, animated: true)

        // 建立一個地點圖示 (圖示預設為紅色大頭針)
        let objectAnnotation = MKPointAnnotation()
        objectAnnotation.coordinate = CLLocation(latitude: self.annLatitude, longitude: self.annLongitude).coordinate
        objectAnnotation.title = self.annTitle
        objectAnnotation.subtitle = self.annSubtitle
        uimap.addAnnotation(objectAnnotation)
        
        // 寫上文字、顯示圖片
        self.label.text = self.annLabelText
        if (self.annImageView != "") {
            self.loadImageFromUrl(url: (self.annImageView), view: self.imageView)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // 首次使用 向使用者詢問定位自身位置權限
        if CLLocationManager.authorizationStatus() == .notDetermined {
            // 取得定位服務授權
            self.locationManager.requestWhenInUseAuthorization()
            
            // 開始定位自身位置
            self.locationManager.startUpdatingLocation()
        }
            // 使用者已經拒絕定位自身位置權限
        else if CLLocationManager.authorizationStatus() == .denied {
            // 提示可至[設定]中開啟權限
            let alertController = UIAlertController(
                title: "定位權限已關閉",
                message: "如要變更權限，請至 設定 > 隱私權 > 定位服務 開啟",
                preferredStyle: .alert
            )
            
            let okAction = UIAlertAction(
                title: "確認",
                style: .default,
                handler:nil
            )
            
            alertController.addAction(okAction)
            
            self.present(
                alertController,
                animated: true,
                completion: nil
            )
        
        // 使用者已經同意定位自身位置權限
        } else if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            // 開始定位自身位置
            self.locationManager.startUpdatingLocation()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        //因為ＧＰＳ功能很耗電,所以背景執行時關閉定位功能
        self.locationManager.stopUpdatingLocation();
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        // 印出目前所在位置座標
        let currentLocation :CLLocation = locations[0] as CLLocation
        print("\(currentLocation.coordinate.latitude)")
        print(", \(currentLocation.coordinate.longitude)")
        
    }
    
    var detailItem: NSDate? {
        didSet {
            // Update the view.
            self.configureView()
        }
    }
    
    @IBAction func mapClick(_ sender: AnyObject) {
        // 取得螢幕的尺寸
        let fullSize = UIScreen.main.bounds.size
        
        // 建立一個 MKMapView
        self.uimap = MKMapView(
            frame: CGRect(
                x: 0,
                y: 20,
                width: fullSize.width,
                height: fullSize.height - 20
            )
        )
        
        // 地圖樣式
        self.uimap.mapType = .standard
        
        // 顯示自身定位位置
        self.uimap.showsUserLocation = true
        
        // 允許縮放地圖
        self.uimap.isZoomEnabled = true
        
        // 地圖預設顯示的範圍大小 (數字越小越精確)
        let latDelta = 0.01
        let longDelta = 0.01
        let currentLocationSpan:MKCoordinateSpan =
            MKCoordinateSpanMake(latDelta, longDelta)
        
        // 設置地圖顯示的範圍與中心點座標
        let center:CLLocation = CLLocation(
            latitude: self.annLatitude, longitude: self.annLongitude)
        let currentRegion:MKCoordinateRegion =
            MKCoordinateRegion(
                center: center.coordinate,
                span: currentLocationSpan
            )
        self.uimap.setRegion(currentRegion, animated: true)
        
        // 建立一個地點圖示 (圖示預設為紅色大頭針)
        let objectAnnotation = MKPointAnnotation()
        objectAnnotation.coordinate = CLLocation(latitude: self.annLatitude, longitude: self.annLongitude).coordinate
        objectAnnotation.title = self.annTitle
        objectAnnotation.subtitle = self.annSubtitle
        uimap.addAnnotation(objectAnnotation)
        
        // 加入到畫面中
        self.view.addSubview(self.uimap)
    }
    
    func loadImageFromUrl(url: String, view: UIImageView){
        // Create Url from string
        let url = NSURL(string: url)!
        // Download task:
        // - sharedSession = global NSURLCache, NSHTTPCookieStorage and NSURLCredentialStorage objects.
        let task = URLSession.shared.dataTask(with: url as URL) { (responseData, responseUrl, error) -> Void in
            // if responseData is not null...
            if let data = responseData{
                // execute in UI thread
                DispatchQueue.main.async(execute: { () -> Void in
                    view.image = UIImage(data: data)
                })
            }
        }
        // Run task
        task.resume()
    }

}

