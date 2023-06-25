//
//  CategoryRepository.swift
//  shopping_reminder
//
//  Created by Koichi Kishimoto on 2023/05/05.
//

import Foundation
import SwiftUI
import Firebase
import FirebaseFirestoreSwift

class CategoryRepository: ObservableObject {
    @ObservedObject private var shoppingItemRepository = ShoppingItemRepository()
    static var db = Firestore.firestore()
    var categories: [Category] = []
    
    @Published var categoryList = [Category](){
        didSet {
            self.objectWillChange.send()
        }
    }
    
    @Published var categoryNameList = [String]() {
        didSet {
            self.objectWillChange.send()
        }
    }
    
    func addCategoryListener() async throws -> Void {
        print("-- add CATEGORY listener fired --")
        let currentUser = AuthModel().getCurrentUser()
        if currentUser == nil {
            print("current user is nil")
        } else {
            let userRef = Firestore.firestore().collection("users").document(currentUser!.uid)
            let categoriesRef = userRef.collection("categories").order(by: "color")
            let listener = categoriesRef.addSnapshotListener(includeMetadataChanges: true) { (documentSnapshot, error) in
                // ドキュメントスナップショットの取得に失敗した場合はエラー内容を表示
                guard let documentSnapshot = documentSnapshot else {
                    print("Error fetching document: \(error!)")
                    return
                }
                // 対象ドキュメントの変更内容
                documentSnapshot.documentChanges.forEach{ diff in
                    if (diff.type == .added){
                        print("ドキュメントが追加された場合")
                        print("documentSnapshot.documents: \(documentSnapshot.documents)")
                        do {
                            self.categoryList = try documentSnapshot.documents.compactMap {
                                try $0.data(as: Category.self)
                            }
                            self.categoryNameList = try documentSnapshot.documents.compactMap {
                                try $0.data(as: Category.self).name
                            }
                        } catch {
                            print(error)
                        }
                    }
                    if (diff.type == .modified){
                        categoriesRef.getDocuments { (snap, error) in
                            if let error = error {
                                fatalError("\(error)")
                            }
                            guard let data = snap?.documents else {
                                print("データがなかった？")
                                return
                            }
                            print(data)
                        }
                        print("ドキュメントが変更された場合")
                        do {
                            self.categoryList = try documentSnapshot.documents.compactMap {
                                try $0.data(as: Category.self)
                            }
                            self.categoryNameList = try documentSnapshot.documents.compactMap {
                                try $0.data(as: Category.self).name
                            }
                        } catch {
                            print(error)
                        }
                    }
                    if (diff.type == .removed){
                        print("ドキュメントが削除された場合")
                        do {
                            self.categoryList = try documentSnapshot.documents.compactMap {
                                try $0.data(as: Category.self)
                            }
                            self.categoryNameList = try documentSnapshot.documents.compactMap {
                                try $0.data(as: Category.self).name
                            }
                        } catch {
                            print(error)
                        }
                    }
                }
                print("リスナーをアタッチして、コールバックを受け取った。")
            }
        }
    }
    
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
