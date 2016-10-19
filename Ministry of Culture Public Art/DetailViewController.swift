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

    @IBOutlet weak var detailDescriptionLabel: UILabel!
    @IBOutlet weak var uimap: MKMapView!
    
    var location : CLLocationManager!; //座標管理元件
    
    func configureView() {
        // Update the user interface for the detail item.
//        if let detail = self.detailItem {
//            if let label = self.detailDescriptionLabel {
//                label.text = detail.description
//            }
//        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.configureView()
        
        // 建立一個 CLLocationManager
        location = CLLocationManager();
        
        // 設置委任對象
        location.delegate = self;
        
        // 距離篩選器 用來設置移動多遠距離才觸發委任方法更新位置
        location.distanceFilter = kCLLocationAccuracyNearestTenMeters
        
        // 取得自身定位位置的精確度
        location.desiredAccuracy = kCLLocationAccuracyThreeKilometers
        
        /* kCLLocationAccuracyBestForNavigation：精確度最高，適用於導航的定位。
         * kCLLocationAccuracyBest：精確度高。
         * kCLLocationAccuracyNearestTenMeters：精確度 10 公尺以內。
         * kCLLocationAccuracyHundredMeters：精確度 100 公尺以內。
         * kCLLocationAccuracyKilometer：精確度 1 公里以內。
         * kCLLocationAccuracyThreeKilometers：精確度 3 公里以內。
         */
        
        // 建立一個地點圖示 (圖示預設為紅色大頭針)
//        let objectAnnotation = MKPointAnnotation()
//        objectAnnotation.coordinate = CLLocation(latitude: 25.036798, longitude: 121.499962).coordinate
//        objectAnnotation.title = "艋舺公園"
//        objectAnnotation.subtitle = "艋舺公園位於龍山寺旁邊，原名為「萬華十二號公園」。"
//        uimap.addAnnotation(objectAnnotation)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // 首次使用 向使用者詢問定位自身位置權限
        if CLLocationManager.authorizationStatus() == .notDetermined {
            // 取得定位服務授權
            location.requestWhenInUseAuthorization()
            
            // 開始定位自身位置
            location.startUpdatingLocation()
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
            location.startUpdatingLocation()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        //因為ＧＰＳ功能很耗電,所以被敬執行時關閉定位功能
        location.stopUpdatingLocation();
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
        self.uimap = MKMapView(frame: CGRect(
            x: 0, y: 20,
            width: fullSize.width,
            height: fullSize.height - 20))
        
        // 地圖樣式
        self.uimap.mapType = .standard
        
        // 顯示自身定位位置
        self.uimap.showsUserLocation = true
        
        // 允許縮放地圖
        self.uimap.isZoomEnabled = true
        
        // 地圖預設顯示的範圍大小 (數字越小越精確)
        let latDelta = 0.05
        let longDelta = 0.05
        let currentLocationSpan:MKCoordinateSpan =
            MKCoordinateSpanMake(latDelta, longDelta)
        
        // 設置地圖顯示的範圍與中心點座標
        let center:CLLocation = CLLocation(
            latitude: 25.05, longitude: 121.515)
        let currentRegion:MKCoordinateRegion =
            MKCoordinateRegion(
                center: center.coordinate,
                span: currentLocationSpan)
        self.uimap.setRegion(currentRegion, animated: true)
        
        // 加入到畫面中
        self.view.addSubview(self.uimap)
    }

}

