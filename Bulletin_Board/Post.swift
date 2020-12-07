//
//  Post.swift
//  Bulletin_Board
//
//  Created by Tobias Classon on 2020-12-04.
//  Copyright © 2020 Tobias Classon. All rights reserved.
//

import Foundation
import RealmSwift

class Post: Object {
    @objc dynamic var title = ""
    @objc dynamic var content = ""
}
