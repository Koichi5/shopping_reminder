//
//  CategoryRepository.swift
//  shopping_reminder
//
//  Created by Koichi Kishimoto on 2023/05/05.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift

class CategoryRepository {
    static var db = Firestore.firestore()
    var categories: [Category] = []
    
//    func addCategory(category: Category) async throws -> Void {
////        var docId = ""
//        let currentUser = AuthModel().getCurrentUser()
//        if currentUser == nil {
//            print("current user is nil")
//        } else {
//            let userRef = Firestore.firestore().collection("users").document(currentUser!.uid)
//            let categoriesRef = userRef.collection("categories")
////            docId = categoriesRef.document().documentID
//            do {
//                let newDocReference = try categoriesRef.addDocument(from: category)
//                print("Category stored with new document reference: \(newDocReference)")
////                try categoriesRef.document(docId).setData(from: category)
////                try await categoriesRef.document(docId).updateData([
////                    "id": docId
////                ])
//            }
//            catch {
//              print(error)
//            }
//        }
//    }
    
    func addCategory(category: Category) async throws -> Void {
        var docId = ""
        let currentUser = AuthModel().getCurrentUser()
        if currentUser == nil {
            print("current user is nil")
        } else {
            let userRef = Firestore.firestore().collection("users").document(currentUser!.uid)
            let categoriesRef = userRef.collection("categories")
            docId = categoriesRef.document().documentID
            do {
//                let newDocReference = try categoriesRef.addDocument(from: category)
//                print("Category stored with new document reference: \(newDocReference)")
                try categoriesRef.document(docId).setData(from: category)
                try await categoriesRef.document(docId).updateData([
                    "id": docId
                ])
            }
            catch {
              print(error)
            }
        }
    }
    
    func updateCategoryName(categoryId: String, categoryName: String) async throws -> Void {
        let currentUser = AuthModel().getCurrentUser()
        if currentUser == nil {
            print("current user is nil")
        } else {
            let userRef = Firestore.firestore().collection("users").document(currentUser!.uid)
            let categoriesRef = userRef.collection("categories").document(categoryId)
            do {
                try await categoriesRef.updateData([
                    "name": categoryName,
                ])
            } catch {
                print(error)
            }
        }
    }
    
    func updateCategoryColor(categoryId: String, categoryColorNum: Int) async throws -> Void {
        let currentUser = AuthModel().getCurrentUser()
        if currentUser == nil {
            print("current user is nil")
        } else {
            let userRef = Firestore.firestore().collection("users").document(currentUser!.uid)
            let categoriesRef = userRef.collection("categories").document(categoryId)
            do {
                try await categoriesRef.updateData([
                    "color": categoryColorNum
                ])
            } catch {
                print(error)
            }
        }
    }
    
    func fetchCategories() async throws -> [Category] {
        var result: [Category] = []
        let currentUser = AuthModel().getCurrentUser()
        if currentUser == nil {
            print("current user is nil")
        } else {
            let userRef = Firestore.firestore().collection("users").document(currentUser!.uid)
            let categoriesRef = userRef.collection("categories")
            do {
                let querySnapshot = try await categoriesRef.getDocuments()
                let documents = querySnapshot.documents
                for document in documents {
                    result.append(try document.data(as: Category.self))
//                    let jsonData = try JSONSerialization.data(withJSONObject: document.data(), options: [])
//                    let decodedData = try JSONDecoder().decode(Category.self, from: jsonData)
//                    result.append(decodedData)
                }
                return result
            } catch {
                print("-- error occured during fetching category: \(error)")
            }
        }
        return result
    }
    
//    func deleteCategory(category: Category) async throws -> Void {
//        let currentUser = AuthModel().getCurrentUser()
//        if currentUser == nil {
//            print("current user is nil")
//        } else {
//            print("delete shopping item fired")
//            let userRef = Firestore.firestore().collection("users").document(currentUser!.uid)
//            let categoriesRef = userRef.collection("categories").document(category.id ?? "")
//            do {
//                try await categoriesRef.delete()
//            } catch {
//                print(error)
//            }
//        }
//    }
}
