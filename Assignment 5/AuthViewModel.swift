//
//  AuthViewModel.swift
//  Assignment 5
//
//  Created by Danny Muñoz on 11/19/26.
//

import Foundation
import FirebaseAuth
import Combine

class AuthViewModel : ObservableObject {
    @Published var user : User?
    @Published var errorMessage = ""

    private var handle : AuthStateDidChangeListenerHandle?

    init() {
        // fires on launch and on every login/logout so the session persists for the user
        handle = Auth.auth().addStateDidChangeListener { _, user in
            self.user = user
        }
    }

    @MainActor
    func signUp(email: String, password: String) async {
        do {
            try await Auth.auth().createUser(withEmail: email, password: password)
            errorMessage = ""
        } catch {
            print("AUTH ERROR:", error)
            print("DETAILS:", (error as NSError).userInfo)
            errorMessage = friendlyMessage(for: error)
        }
    }

    @MainActor
    func login(email: String, password: String) async {
        do {
            try await Auth.auth().signIn(withEmail: email, password: password)
            errorMessage = ""
        } catch {
            print("AUTH ERROR:", error)
            print("DETAILS:", (error as NSError).userInfo)
            errorMessage = friendlyMessage(for: error)
        }
    }

    func logout() {
        do {
            try Auth.auth().signOut()
        } catch {
            print("Error signing out: \(error)")
        }
    }

    private func friendlyMessage(for error: Error) -> String {
        let nsError = error as NSError
        switch AuthErrorCode(rawValue: nsError.code) {
        case .wrongPassword, .invalidCredential:
            return "Incorrect email or password."
        case .invalidEmail:
            return "That email address isn't valid."
        case .emailAlreadyInUse:
            return "An account with that email already exists."
        case .weakPassword:
            return "Password must be at least 6 characters."
        default:
            return error.localizedDescription
        }
    }
}
