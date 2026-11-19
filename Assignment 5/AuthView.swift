//
//  AuthView.swift
//  Assignment 5
//
//  Created by Danny Muñoz on 11/19/26.
//

import SwiftUI

struct AuthView: View {

    @EnvironmentObject var auth : AuthViewModel
    @State var email = ""
    @State var password = ""
    @State var isSignUp = false

    var body: some View {
        VStack(spacing: 16) {
            Text(isSignUp ? "Create Account" : "Log In")
                .font(.largeTitle)
                .fontWeight(.bold)

            TextField("Email", text: $email)
                .textInputAutocapitalization(.never)
                .keyboardType(.emailAddress)
                .autocorrectionDisabled()
                .textFieldStyle(.roundedBorder)

            SecureField("Password", text: $password)
                .textFieldStyle(.roundedBorder)

            if !auth.errorMessage.isEmpty {
                Text(auth.errorMessage)
                    .foregroundStyle(.red)
                    .font(.callout)
            }

            Button(isSignUp ? "Sign Up" : "Log In") {
                Task {
                    if isSignUp {
                        await auth.signUp(email: email, password: password)
                    } else {
                        await auth.login(email: email, password: password)
                    }
                }
            }
            .buttonStyle(.borderedProminent)

            Button(isSignUp ? "Already have an account? Log in" : "Need an account? Sign up") {
                isSignUp.toggle()
                auth.errorMessage = ""
            }
            .font(.footnote)
        }
        .padding()
    }
}

#Preview {
    AuthView()
        .environmentObject(AuthViewModel())
}
