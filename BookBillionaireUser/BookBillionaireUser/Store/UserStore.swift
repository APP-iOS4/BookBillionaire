//
//  UserStore.swift
//  BookBillionaireUser
//
//  Created by 최준영 on 4/3/24.
//

import SwiftUI
import Foundation
import BookBillionaireCore


class UserStore {

    var users: [User] = []

    init() {
        users = [
            User(id: "985ZXtyszUYU9RCKYOaPZYALMyn1", nickName: "유승재재", address: "주소 정보 없음", image: nil, myBooks: Optional([]), rentalBooks: Optional([])),
            User(id: "Eyhr4YQGsATlRDUcc9rYl9PZYk52", nickName: "우성종", address: "주소 정보 없음", image: nil, myBooks: Optional([]), rentalBooks: Optional([])),
            User(id: "f2tWX84q9Igvg2hpQogOhtvffkO2", nickName: "최준영", address: "주소 정보 없음", image: nil, myBooks: Optional([]), rentalBooks: Optional([])),
            User(id: "k1AHir0kSjNbssbXjbj4QziEDbg1", nickName: "홍승표", address: "주소 정보 없음", image: nil, myBooks: Optional([]), rentalBooks: Optional([])),
            User(id: "tBxmiAPEbZXYJIeQjTRmrc2z5zd2", nickName: "유승재", address: "주소 정보 없음", image: nil, myBooks: Optional([]), rentalBooks: Optional([]))
        ]
    }
    
}
