//
//  ShoppingItemRepository.swift
//  shopping_reminder
//
//  Created by Koichi Kishimoto on 2023/05/06.
//

import Foundation
import FirebaseFirestore

class ShoppingItemRepository: ObservableObject {
    static var db = Firestore.firestore()
    @Published var shoppingItemList = [ShoppingItem](){
        didSet {
            self.objectWillChange.send()
        }
    }
    
    func addUserSnapshotListener(){
//        var shoppingItemList: [ShoppingItem] = []
        let currentUser = AuthModel().getCurrentUser()
        if currentUser == nil {
            print("current user is nil")
        } else {
            let userRef = Firestore.firestore().collection("users").document(currentUser!.uid)
            let itemsRef = userRef.collection("items")
            itemsRef.addSnapshotListener { (documentSnapshot, error) in
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
                            self.shoppingItemList = try documentSnapshot.documents.compactMap {
                                try $0.data(as: ShoppingItem.self)
                            }
//                            self.shoppingItemList =  documentSnapshot.documents.map { (document) -> ShoppingItem in
//                                let data = document.data()
//                                print("data[name]: \(data["name"])")
//                                let name = data["name"] as? String ?? ""
//                                let category = data["category"] as? Category ?? Category(name: "", color: CategoryColor.black)
//                                print("category data: \(data["category"])")
//                                print("category: \(category)")
//                                let addea_at = (data["added_at"] as? Timestamp)?.dateValue() ?? Date()
//                                let custom_url = data["custom_url"] as? String ?? ""
//                                let expiration_date = (data["expiration_date"] as? Timestamp)?.dateValue() ?? Date()
////                                self.shoppingItemList.append(ShoppingItem(
////                                    name: name,
////                                    category: category,
////                                    addedAt: addea_at,
////                                    expirationDate: expiration_date,
////                                    customURL: custom_url
////                                ))
//                                print("shoppingItemList in func: \(self.shoppingItemList)")
//                                return ShoppingItem(
//                                    name: name,
//                                    category: category,
//                                    addedAt: addea_at,
//                                    expirationDate: expiration_date,
//                                    customURL: custom_url
//                                )
//                            }
                        } catch {
                            print(error)
                        }
                    }
                    if (diff.type == .modified){
                        // 更新された値を取得
                        itemsRef.getDocuments { (snap, error) in
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
                    }
                    if (diff.type == .removed){
                        print("ドキュメントが削除された場合")
                    }
                }
                print("リスナーをアタッチして、コールバックを受け取った。")
            }
        }
    }
    
    func addShoppingItem(shoppingItem: ShoppingItem) async throws -> Void {
        let currentUser = AuthModel().getCurrentUser()
        if currentUser == nil {
            print("current user is nil")
        } else {
            //            let encoder = JSONEncoder()
            //            let encodedShoppingItem = try encoder.encode(shoppingItem)
            let userRef = Firestore.firestore().collection("users").document(currentUser!.uid)
            let itemsRef = userRef.collection("items")
            do {
                let newDocReference = try itemsRef.addDocument(from: shoppingItem)
                print("Item stored with new document reference: \(newDocReference)")
            }
            catch {
                print(error)
            }
        }
    }
    
    func deleteShoppingItem(shoppingItem: ShoppingItem) async throws -> Void {
        let currentUser = AuthModel().getCurrentUser()
        if currentUser == nil {
            print("current user is nil")
        } else {
            let userRef = Firestore.firestore().collection("users").document(currentUser!.uid)
            let itemsRef = userRef.collection("items")
            let itemRef = itemsRef.document(shoppingItem.id.uuidString)
            do {
                try await itemRef.delete()
            } catch {
                print(error)
            }
        }
    }
    
//    func fetchRealtimeShoppingItem() async throws -> [ShoppingItem]? {
//        print("---fetch realtime shopping item run---")
//        var result = [ShoppingItem]()
//        let currentUser = AuthModel().getCurrentUser()
//        if currentUser == nil {
//            print("current user is nil")
//        } else {
//            Firestore.firestore().collection("users").document(currentUser!.uid).collection("items").addSnapshotListener { (querySnapshot, error) in
//                // ドキュメントスナップショットの取得に失敗した場合はエラー内容を表示
//                guard let documents = querySnapshot?.documents else {
//                    print("No documents")
//                    return
//                }
//
//                result = documents.map { (queryDocumentSnapshot) -> ShoppingItem in
//                    let data = queryDocumentSnapshot.data()
//                    let name = data["name"] as? String ?? ""
//                    let category = data["category"] as? Category ?? Category(name: "", color: CategoryColor.black)
//                    let addea_at = (data["added_at"] as? Timestamp)?.dateValue() ?? Date()
//                    let custom_url = data["custom_url"] as? String ?? ""
//                    let expiration_date = (data["expiration_date"] as? Timestamp)?.dateValue() ?? Date()
//                    result.append(ShoppingItem(
//                        name: name,
//                        category: category,
//                        addedAt: addea_at,
//                        expirationDate: expiration_date,
//                        customURL: custom_url
//                    ))
//                    return ShoppingItem(
//                        name: name,
//                        category: category,
//                        addedAt: addea_at,
//                        expirationDate: expiration_date,
//                        customURL: custom_url
//                    )
//                }
//            }
//        }
//        return result
//    }
//
//    func fetchShoppingItems() async throws -> [ShoppingItem]? {
//        var result: [ShoppingItem] = []
//        let currentUser = AuthModel().getCurrentUser()
//        if currentUser == nil {
//            print("current user is nil")
//        } else {
//            let userRef = Firestore.firestore().collection("users").document(currentUser!.uid)
//            let shoppingItemsRef = userRef.collection("items")
//            do {
//                let dateFormatter = DateFormatter()
//                dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss Z"
//                let querySnapshot = try await shoppingItemsRef.getDocuments()
//                let documents = querySnapshot.documents
//                if (documents.isEmpty) {
//                    return nil
//                }
//                for document in documents {
//                    var data = document.data()
//                    // Convert Firestore Timestamps to Dates
//                    if let addedAtTimestamp = data["added_at"] as? Timestamp {
//                        data["added_at"] = dateFormatter.string(from: addedAtTimestamp.dateValue())
//                    }
//                    if let expirationDateTimestamp = data["expiration_date"] as? Timestamp {
//                        data["expiration_date"] = dateFormatter.string(from: expirationDateTimestamp.dateValue())
//                    }
//                    let jsonData = try JSONSerialization.data(withJSONObject: data, options: [])
//                    let decodedData = try JSONDecoder().decode(ShoppingItem.self, from: jsonData)
//                    result.append(decodedData)
//                }
//                return result
//            } catch {
//                print(error)
//            }
//        }
//        return result
//    }
    
    
    //    func fetchShoppingItems() async throws -> [ShoppingItem]? {
    //        var result: [ShoppingItem] = []
    //        let currentUser = AuthModel().getCurrentUser()
    //        if currentUser == nil {
    //            print("current user is nil")
    //        } else {
    //            let userRef = Firestore.firestore().collection("users").document(currentUser!.uid)
    //            let shoppingItemsRef = userRef.collection("items")
    //            do {
    //                let querySnapshot = try await shoppingItemsRef.getDocuments()
    //                let documents = querySnapshot.documents
    ////                var result = [Category]()
    //                print(documents)
    //                if (documents.isEmpty) {
    //                    return nil
    //                }
    //                for document in documents {
    //                    let jsonData = try JSONSerialization.data(withJSONObject: document.data(), options: [])
    //                    let decodedData = try JSONDecoder().decode(ShoppingItem.self, from: jsonData)
    //                    result.append(decodedData)
    //                }
    //                return result
    //            } catch {
    //                print(error)
    //            }
    //        }
    //        return result
    //    }
    
    //    func fetchCategories() async throws -> [Category]? {
    //        let currentUser = AuthModel().getCurrentUser()
    //        if currentUser == nil {
    //            print("current user is nil")
    //        } else {
    //            let document = try await Firestore.firestore().collection("users").document(currentUser!.uid).getDocument()
    //            guard let data = document.data(),
    //                  let categoriesArray = data["categories"] as? [[String: Any]]
    //            else {
    //                print("Failed to read category data")
    //                return nil
    //            }
    //            do {
    //                let categoriesData = try JSONSerialization.data(withJSONObject: categoriesArray, options: [])
    //                let decoder = JSONDecoder()
    //                categories = try decoder.decode([Category].self, from: categoriesData)
    //                print("categories: \(categories)")
    //                return categories
    //            } catch {
    ////                return [Category(name: "", color: CategoryColor.black)]
    //            }
    //        }
    //        return categories
    //    }
}
