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
    
    func addUserSnapshotListener() async throws -> Void{
//        var shoppingItemList: [ShoppingItem] = []
        print("add user snapshot listener fired !")
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
                            print("shoppingItemList: \(self.shoppingItemList)")
                        } catch {
                            print(error)
                        }
                    }
                    if (diff.type == .modified){
//                         更新された値を取得
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
    
    func addShoppingItemWithDocumentId(shoppingItem: ShoppingItem) async throws -> String {
//        var shoppingItemId = ""
        var newDocReference = ""
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
//                let newDocReference = try itemsRef.addDocument(from: shoppingItem)
//                let newDocReference = try itemRef.addDocument(from: shoppingItem)
//                let newDocReference: () = try itemRef.setData(shoppingItem)
//                shoppingItemId = newDocReference.documentID
//                try await itemsRef.document(shoppingItemId).updateData(["id": "\(shoppingItemId)"])
//                print("shoppingItemId in addShoppingItemWithDocumentId func: \(shoppingItemId)")
//                print("shopping item id in add shopping item with document id func : \(shoppingItemId)")
//                print("Item stored with new document reference: \(newDocReference)")
                print("newDocReference:  \(docId)")
            }
            catch {
                print(error)
            }
        }
        print("newDocReference in addnshopping item with document id func: \(docId)")
        return docId
    }
    
    func updateShoppingItem(shoppingItem: ShoppingItem) async throws -> Void {
        let currentUser = AuthModel().getCurrentUser()
        if currentUser == nil {
            print("current user is nil")
        } else {
            let userRef = Firestore.firestore().collection("users").document(currentUser!.uid)
            let itemRef = userRef.collection("items").document(shoppingItem.id ?? "")
            do {
                try await itemRef.updateData([
                    "id": shoppingItem.id,
                    "name": shoppingItem.name,
                    "category": shoppingItem.category,
                    "added_at": shoppingItem.addedAt,
                    "custom_url": shoppingItem.customURL,
                    "is_alerm_repeat_on": shoppingItem.isAlermRepeatOn,
                    "alerm_cycle_seconds": shoppingItem.alermCycleSeconds,
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
