//
//  FirebaseUserRepository.swift
//  shopping_reminder
//
//  Created by Koichi Kishimoto on 2023/05/04.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

class FirebaseUserRepository {
    let db = Firestore.firestore()
    let currentUser: User? = AuthModel.shared.getCurrentUser()
    func addFirebaseUser(user: User) {
        if (currentUser?.uid == nil) {
            print("current user's uid is nil")
        } else {
            let userRef = db.collection("users").document(currentUser!.uid)
            print("current user uid: \(currentUser!.uid)")
            do {
                let firebaseUser = FirebaseUser(
                    id: currentUser!.uid,
                    email: currentUser!.email ?? "",
                    items: [],
                    categories: [
                        Category(name: "Groceries", color: CategoryColor.green),
                        Category(name: "Clothing", color: CategoryColor.blue),
                        Category(name: "Electronics", color: CategoryColor.orange),
                    ]
                )
                let encoder = JSONEncoder()
                let data = try encoder.encode(firebaseUser)
                let dict = try JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
//                userRef.addDocument(data: dict) { error in
//                    if let error = error {
//                        print("--Error adding document: \(error)--")
//                    } else {
//                        print("--Document added successfully--")
//                    }
//                }
                userRef.setData(dict) { error in
                    if let error = error {
                        print("--Error adding document: \(error)--")
                    } else {
                        print("--Document added successfully--")
                    }
                }
            }
            catch {
                print("--Error when trying to encode book: \(error)--")
            }
        }
    }
    
    func deleteFirebaseUser(userUid: String) {
        let userRef = db.collection("users").document(userUid)
        userRef.delete()
    }
}
