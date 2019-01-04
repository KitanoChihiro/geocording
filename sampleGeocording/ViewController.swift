//
//  ViewController.swift
//  sampleGeocording
//
//  Created by 北野千裕 on 2018/12/20.
//  Copyright © 2018年 Chihiro Kitano. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController {

    @IBOutlet weak var map: MKMapView!
    @IBOutlet weak var geocodeLabel: UILabel!
    
    @IBOutlet weak var geoLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // ジオコーディング
        let address = "オペラハウス"
        CLGeocoder().geocodeAddressString(address) { placemarks, error in
            
            for i in placemarks!{
                print("緯度:", i.location?.coordinate.latitude)
                print("経度:", i.location?.coordinate.longitude)
            }
            
            
            if let lat = placemarks?.first?.location?.coordinate.latitude {
                print("緯度 : \(lat)")
            }
            if let lng = placemarks?.first?.location?.coordinate.longitude {
                print("経度 : \(lng)")
            }
        }
        
        // 地図のタップイベントを拾う
        // 地図のどこをタップされたかを緯度・経度で取得
        // 逆ジオコーディング
        let gesture = UITapGestureRecognizer(target: self, action: #selector(mapDidTap(_:)))
        map.addGestureRecognizer(gesture)
        map.setRegion(defaultRegion, animated: false)
        
    }
    
    // mapがタッチされたら
    @objc private func mapDidTap(_ gesture: UITapGestureRecognizer) {
        let coordinate = map.convert(gesture.location(in: map), toCoordinateFrom: map)
        let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        CLGeocoder().reverseGeocodeLocation(location) { placemarks, error in
            guard
                let placemark = placemarks?.first, error == nil,
                let administrativeArea = placemark.administrativeArea, // 都道府県
                let locality = placemark.locality, // 市区町村
                let thoroughfare = placemark.thoroughfare, // 地名(丁目)
                let subThoroughfare = placemark.subThoroughfare, // 番地
                let postalCode = placemark.postalCode, // 郵便番号
                let location = placemark.location // 緯度経度情報
                else {
                    self.geocodeLabel.text = ""
                    return
            }
            
            self.geocodeLabel.text = """
            〒\(postalCode)\(administrativeArea)\(locality)\(thoroughfare)\(subThoroughfare)
            \(location.coordinate.latitude), \(location.coordinate.longitude)
            """
        }
    }
    
    
//    private var defaultRegion: MKCoordinateRegion {
//        let coordinate = CLLocationCoordinate2D( // 大阪駅
//            latitude: 34.7024854,
//            longitude: 135.4937619
//        )
//        let span = MKCoordinateSpan (
//            latitudeDelta: 0.01,
//            longitudeDelta: 0.01
//        )
//        return MKCoordinateRegion(center: coordinate, span: span)
//    }


}

