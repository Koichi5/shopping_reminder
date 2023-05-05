//
//  CategoryRepository.swift
//  shopping_reminder
//
//  Created by Koichi Kishimoto on 2023/05/05.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift

final class CategoryRepository {
    static var db = Firestore.firestore()
    var categories: [Category] = []
    func fetchCategories() async throws -> [Category]? {
        let currentUser = AuthModel().getCurrentUser()
        if currentUser == nil {
            print("current user is nil")
        } else {
            let document = try await Firestore.firestore().collection("users").document(currentUser!.uid).getDocument()
            guard let data = document.data(),
                  let categoriesArray = data["categories"] as? [[String: Any]]
            else {
                print("Failed to read category data")
                return nil
            }
            do {
                let categoriesData = try JSONSerialization.data(withJSONObject: categoriesArray, options: [])
                let decoder = JSONDecoder()
                categories = try decoder.decode([Category].self, from: categoriesData)
                print("categories: \(categories)")
                return categories
            } catch {
//                return [Category(name: "", color: CategoryColor.black)]
            }
        }
        return categories
    }
}

//
//    static func fetchCategories() async throws -> Void {
//        let currentUser = AuthModel().getCurrentUser()
//        if currentUser == nil {
//            print("current user is nil")
//        } else {
//            let userRef = db.collection("users").document(currentUser!.uid)
//            let documentSnapshot = try await userRef.getDocument()
//            let data = documentSnapshot.data()
//            let categories = data?["categories"]
//
//            guard let categoriesArray = categories as? [Any] else {
//                return
//            }
//
//            var categoryList: [Category] = []
//            for categoryData in categoriesArray {
//                guard let categoryDict = categoryData as? [String: Any] else {
//                    continue
//                }
//                do {
//                    let decoder = JSONDecoder()
////                    let category = try Firestore.Decoder().decode(Category.self, from: categoryDict)
////                    categoryList.append(category)
//                }
//            }
//
//            print("documentSnapshot: \(documentSnapshot)")
//            print("data: \(String(describing: data))")
//            print("categories: \(String(describing: categories))")
//        }
//    }
//}
