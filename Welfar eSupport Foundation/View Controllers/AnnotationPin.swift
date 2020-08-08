//
//  AnnotationPin.swift
//  Welfar eSupport Foundation
//
//  Created by administrator on 7/19/20.
//  Copyright © 2020 Rushil. All rights reserved.
//

import MapKit
class AnnotationPin: NSObject, MKAnnotation{
    var title: String?
    var subtitle: String?
    var coordinate: CLLocationCoordinate2D
    
    init(title: String, subtitle: String, coordinate: CLLocationCoordinate2D){
        self.title = title
        self.subtitle = subtitle
        self.coordinate = coordinate
    }
}
