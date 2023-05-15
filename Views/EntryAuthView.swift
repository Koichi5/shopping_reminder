//
//  EntryAuthView.swift
//  shopping_reminder
//
//  Created by Koichi Kishimoto on 2023/05/04.
//

import SwiftUI
import FirebaseAuth

struct EntryAuthView: View {
    @State var name:String = ""
    @State var email: String = ""
    @State var password: String = ""
    @State var isRegisterSuccess: Bool = false
    @ObservedObject var authViewModel:AuthViewModel = AuthViewModel()
    var body: some View {
        NavigationView(content: {
            VStack {
                Text("name")
                TextField("name", text: $name).padding(.bottom).textFieldStyle(.roundedBorder)
                Text("email")
                TextField("email", text: $email).padding(.bottom).textFieldStyle(.roundedBorder)
                Text("password")
                SecureField("password", text: $password).padding(.bottom).textFieldStyle(.roundedBorder)
                Button(action: {
                    AuthViewModel().createUserWithEmailAndPassword(email: email, password: password)
                    isRegisterSuccess = true
                    //                    ShoppingItemRepository().addUserSnapshotListener()
                }, label: {
                    Text("新規登録")
                }).padding()
                GoogleSignInButton()
            }
            .sheet(isPresented: $isRegisterSuccess) {
                IntroView()
            }
            .navigationTitle(Text("新規登録"))
        }
        )
    }
}

struct EntryAuthView_Previews: PreviewProvider {
    static var previews: some View {
        EntryAuthView()
    }
}
