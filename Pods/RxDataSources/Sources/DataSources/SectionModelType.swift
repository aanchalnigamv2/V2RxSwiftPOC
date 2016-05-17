//
//  SectionModelType.swift
//  RxDataSources
//
//  Created by Krunoslav Zaher on 6/28/15.
//  Copyright © 2015 Krunoslav Zaher. All rights reserved.
//

import Foundation

public protocol SectionModelType {
    typealias Item

    var items: [Item] { get }
}