//
//  CreateAuthenticationView.swift
//  swiftui_upgraded_eureka
//
//  Created by m1_air on 11/13/24.
//

import SwiftUI

struct NewAccountView: View {
    @State var authViewModel: AuthViewModel = AuthViewModel()
    @State var confirmPassword: String = ""
    @State var success: Bool = false
    @State var existingUser: Bool = false
    @State var error: String = ""
    @State var showAlert: Bool = false
    
    func isValidEmail() -> Bool {
        let emailRegex = "^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        if emailPredicate.evaluate(with: authViewModel.auth.email) {
            return true
        } else {
            error = "Must enter a valid email address."
            showAlert = true
            return false
        }
    }
    
    func passwordValidation() -> Bool {
        if authViewModel.auth.password.count >= 8 {
            if authViewModel.auth.password == confirmPassword {
                return true
            } else {
                error = "Passwords must match."
                showAlert = true
                return false
            }
        } else {
            error = "Password must be at least 8 characters long."
            showAlert = true
            return false
        }
    }
    
    var body: some View {
        NavigationStack{
            VStack{
                Spacer()
                Text("New Account").font(.system(size: 34))
                    .fontWeight(.ultraLight)
                Divider().padding()
                TextField("Username", text: $authViewModel.auth.displayName)
                    .tint(.black)
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
                    .padding()
                TextField("Email", text: $authViewModel.auth.email)
                    .tint(.black)
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
                    .padding()
                SecureField("Password", text: $authViewModel.auth.password)
                    .tint(.black)
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
                    .padding()
                
                SecureField("Confirm Password", text: $confirmPassword)
                    .tint(.black)
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
                    .padding()
                Button("Next", action: {
                    if isValidEmail() {
                        if passwordValidation() {
                            Task{
                                success = await authViewModel.createNewUser()
                            }
                        }
                    }
                    
                }).fontWeight(.ultraLight)
                    .foregroundColor(.black)
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color.white)
                            .shadow(color: .gray.opacity(0.4), radius: 4, x: 2, y: 2)
                    )
                    .navigationDestination(isPresented: $success, destination: {
//                        AvatarView(userViewModel: $userViewModel).navigationBarBackButtonHidden(true)
                    })
                    .alert("Error", isPresented: $showAlert) {
                                    Button("OK", role: .cancel) {
                                        authViewModel.auth.displayName = ""
                                        authViewModel.auth.email = ""
                                        authViewModel.auth.password = ""
                                        confirmPassword = ""
                                    }
                                } message: {
                                    Text(error)
                                }
                Spacer()
                HStack{
                    Text("Already have an account?")
                    Button("Login", action: {
                        existingUser = true
                    }).foregroundStyle(.black)
                        .fontWeight(.light)
                        .navigationDestination(isPresented: $existingUser, destination: {
                                                        LoginView().navigationBarBackButtonHidden(true)
                        })
                }
            }
        }
    }
}

#Preview {
    NewAccountView()
}
