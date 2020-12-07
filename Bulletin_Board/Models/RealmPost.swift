//
//  RealmPost.swift
//  Bulletin_Board
//
//  Created by Tobias Classon on 2020-12-07.
//  Copyright © 2020 Tobias Classon. All rights reserved.
//

import Foundation
import RealmSwift

public class RealmPost: Object {
    
    @objc dynamic var title = ""
    @objc dynamic var content = ""
    @objc dynamic var id: Int16 = 0
    
}
