//
//  ShoppingItemRepository.swift
//  shopping_reminder
//
//  Created by Koichi Kishimoto on 2023/05/06.
//

import Foundation
import SwiftUI
import FirebaseFirestore

class ShoppingItemRepository: ObservableObject {
    //    @ObservedObject private var categoryRepository = CategoryRepository()
    static var db = Firestore.firestore()
    var listenerRegistration: ListenerRegistration?
    @Published var shoppingItemList: [ShoppingItem] = []
    //    {
    //        didSet {
    //            self.objectWillChange.send()
    //        }
    //    }
    @Published var shoppingItemCategoryList: [String] = []
    //    {
    //        didSet{
    //            self.objectWillChange.send()
    //        }
    //    }
    
    @Published var shoppingItemNameList: [String] = []
    //    {
    //        didSet {
    //            self.objectWillChange.send()
    //        }
    //    }
    
    func addUserSnapshotListener() async throws -> Void {
        print("add user snapshot listener fired !")
        let currentUser = AuthModel().getCurrentUser()
        if currentUser == nil {
            print("current user is nil")
        } else {
            let userRef = Firestore.firestore().collection("users").document(currentUser!.uid)
            let itemsRef = userRef.collection("items")
            let currentListenerRegistration = itemsRef.addSnapshotListener(includeMetadataChanges: true) { (documentSnapshot, error) in
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
                            print("shoppingItemList: \(self.shoppingItemList)")
                            for shoppingItem in self.shoppingItemList {
                                if (!self.shoppingItemCategoryList.contains(shoppingItem.category.name)) {
                                    self.shoppingItemCategoryList.append(shoppingItem.category.name)
                                }
                            }
                            //                            for shoppingItem in self.shoppingItemList {
                            //                                if(!self.categoryRepository.categoryNameList.contains(shoppingItem.category.name)) {
                            //                                    self.categoryRepository.categoryNameList.append(shoppingItem.category.name)
                            //                                }
                            //                            }
                        } catch {
                            print(error)
                        }
                    }
                    if (diff.type == .modified){
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
                        
                        do {
                            self.shoppingItemList = try documentSnapshot.documents.compactMap {
                                try $0.data(as: ShoppingItem.self)
                            }
                            print("shoppingItemList: \(self.shoppingItemList)")
                            for shoppingItem in self.shoppingItemList {
                                if (!self.shoppingItemCategoryList.contains(shoppingItem.category.name)) {
                                    self.shoppingItemCategoryList.append(shoppingItem.category.name)
                                }
                            }
                            //                            for shoppingItem in self.shoppingItemList {
                            //                                if(!self.categoryRepository.categoryNameList.contains(shoppingItem.category.name)) {
                            //                                    self.categoryRepository.categoryNameList.append(shoppingItem.category.name)
                            //                                }
                            //                            }
                        } catch {
                            print(error)
                        }
                    }
                    if (diff.type == .removed){
                        print("ドキュメントが削除された場合")
                        do {
                            self.shoppingItemList = try documentSnapshot.documents.compactMap {
                                try $0.data(as: ShoppingItem.self)
                            }
                            self.shoppingItemCategoryList = []
                            print("shoppingItemList: \(self.shoppingItemList)")
                            for shoppingItem in self.shoppingItemList {
                                if (!self.shoppingItemCategoryList.contains(shoppingItem.category.name)) {
                                    self.shoppingItemCategoryList.append(shoppingItem.category.name)
                                }
                            }
                        } catch {
                            print(error)
                        }
                    }
                }
                print("リスナーをアタッチして、コールバックを受け取った。")
            }
            self.listenerRegistration = currentListenerRegistration
        }
    }
    
    func removeCurrentSnapshotListener() {
        if let listenerRegistration = self.listenerRegistration {
            listenerRegistration.remove()
            self.listenerRegistration = nil
            print("-- current snapshot listener removed --")
        }
    }
    
    func addShoppingItemWithDocumentId(shoppingItem: ShoppingItem) async throws -> String {
        //        var newDocReference = ""
        var docId = ""
        let currentUser = AuthModel().getCurrentUser()
        if currentUser == nil {
            print("current user is nil")
        } else {
            let userRef = Firestore.firestore().collection("users").document(currentUser!.uid)
            let itemsRef = userRef.collection("items")
            docId = itemsRef.document().documentID
            do {
                //                set data from shoppingItem and then update id
                try itemsRef.document(docId).setData(from: shoppingItem)
                try await itemsRef.document(docId).updateData([
                    "id": docId
                ])
                print("newDocReference:  \(docId)")
            }
            catch {
                print(error)
            }
        }
        print("newDocReference in addnshopping item with document id func: \(docId)")
        return docId
    }
    
    func fetchShoppingItemList() async throws -> [ShoppingItem] {
        var result: [ShoppingItem] = []
        print("add user snapshot listener fired !")
        let currentUser = AuthModel().getCurrentUser()
        if currentUser == nil {
            print("current user is nil")
        } else {
            let userRef = Firestore.firestore().collection("users").document(currentUser!.uid)
            let itemsRef = userRef.collection("items")
            do {
                let querySnapshot = try await itemsRef.getDocuments()
                let documents = querySnapshot.documents
                for document in documents {
                    result.append(try document.data(as: ShoppingItem.self))
                }
                return result
            } catch {
                print("-- error occured during fetching shopping item: \(error)")
            }
        }
        return result
    }
    
    func updateShoppingItem(shoppingItem: ShoppingItem, shoppingItemId: String) async throws -> Void {
        let currentUser = AuthModel().getCurrentUser()
        if currentUser == nil {
            print("current user is nil")
        } else {
            let userRef = Firestore.firestore().collection("users").document(currentUser!.uid)
            let itemRef = userRef.collection("items").document(shoppingItemId)
            do {
                try await itemRef.updateData([
                    //                    "id": shoppingItem.id,
                    "name": shoppingItem.name,
//                    "category": [
//                        "color": shoppingItem.category.color.colorNum,
//                        "items": [],
//                        "name": shoppingItem.category.name
//                    ],
                    //                    "added_at": shoppingItem.addedAt,
                    //                    "priority": shoppingItem.priority,
                    "is_url_setting_on": shoppingItem.isUrlSettingOn,
                    "custom_url": shoppingItem.customURL,
                    "is_alerm_setting_on": shoppingItem.isAlermSettingOn,
                    "is_alerm_repeat_on": shoppingItem.isAlermRepeatOn,
                    "alerm_cycle_seconds": shoppingItem.alermCycleSeconds,
                    "alerm_cycle_string": shoppingItem.alermCycleString,
                    "memo": shoppingItem.memo,
                    "is_detail_setting_on": shoppingItem.isDetailSettingOn
                ])
            } catch {
                print(error)
            }
        }
    }
    
    func updateShoppingItemId(shoppingItemId: String, oldShoppingItemId: String) async throws -> Void {
        let currentUser = AuthModel().getCurrentUser()
        if currentUser == nil {
            print("current user is nil")
        } else {
            let userRef = Firestore.firestore().collection("users").document(currentUser!.uid)
            let itemRef = userRef.collection("items").document(oldShoppingItemId)
            do {
                try await itemRef.updateData([
                    "id": shoppingItemId,
                ])
            } catch {
                print(error)
            }
        }
    }
    
    func deleteShoppingItem(shoppingItem: ShoppingItem) async throws -> Void {
        let currentUser = AuthModel().getCurrentUser()
        if currentUser == nil {
            print("current user is nil")
        } else {
            print("delete shopping item fired")
            let userRef = Firestore.firestore().collection("users").document(currentUser!.uid)
            let itemRef = userRef.collection("items").document(shoppingItem.id ?? "")
            do {
                try await itemRef.delete()
                
            } catch {
                print(error)
            }
        }
    }
}
