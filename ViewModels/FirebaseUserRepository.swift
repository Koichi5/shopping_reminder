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
        }
        else {
            let userRef = db.collection("users").document(currentUser!.uid)
            print("current user uid: \(currentUser!.uid)")
            do {
                let firebaseUser = FirebaseUser(
                    id: currentUser!.uid,
                    email: currentUser!.email ?? "",
                    items: [],
                    categories: [
                        Category(name: "日用品", color: CategoryColor.yellow, style: CategoryStyle(color: CategoryColor.yellow)),
                        Category(name: "食品", color: CategoryColor.red, style: CategoryStyle(color: CategoryColor.red)),
                        Category(name: "衣服", color: CategoryColor.orange, style: CategoryStyle(color: CategoryColor.orange)),
                        Category(name: "家具・家電", color: CategoryColor.blue, style: CategoryStyle(color: CategoryColor.blue)),
                        Category(name: "アウトドア用品", color: CategoryColor.green, style: CategoryStyle(color: CategoryColor.green)),
                        Category(name: "ペット用品", color: CategoryColor.purple, style: CategoryStyle(color: CategoryColor.purple)),
                        Category(name: "その他", color: CategoryColor.gray, style: CategoryStyle(color: CategoryColor.gray)),

                    ]
                )
                try userRef.setData(from: firebaseUser)
                
                for category in firebaseUser.categories {
                    Task {
                        try await CategoryRepository().addCategory(category: category)
                    }
                }
            }
            catch {
                print("--Error when trying to encode category: \(error)--")
            }
        }
    }
    
    func deleteFirebaseUser(userUid: String) {
        let userRef = db.collection("users").document(userUid)
        userRef.delete()
    }
}
