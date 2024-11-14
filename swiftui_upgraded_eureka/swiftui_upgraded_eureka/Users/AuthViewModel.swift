//
//  AuthViewModel.swift
//  swiftui_upgraded_eureka
//
//  Created by m1_air on 11/13/24.
//

import Foundation
import Observation

@Observable class AuthViewModel {
    var auth: AuthModel = AuthModel()
    var baseURL: String = "http://192.168.0.134:3000/" //local host
    var error: String = ""
    
    func createNewUser() async -> Bool {

        guard let url = URL(string: "\(baseURL)auth/create") else { return false }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let body: [String: Any] = [
            "email": auth.email,
            "password": auth.password,
            "displayName": auth.displayName,
            "photoUrl": auth.avatar
        ]

        guard let jsonData = try? JSONSerialization.data(withJSONObject: body, options: []) else {
            return false
        }

        request.httpBody = jsonData

        do {
            let (data, response) = try await URLSession.shared.data(for: request)

            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                // Decode the JSON response to get the uid
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                   let uid = json["uid"] as? String {
                    DispatchQueue.main.async {
                        self.auth.uid = uid
                        UserDefaults.standard.set(uid, forKey: "uid") //save authenticated user uid to device
                    }
                    print("User created with UID: \(uid)")
                    return true
                } else {
                    print("An error occured while creating a new user.")
                    return false
                }
            } else {
                DispatchQueue.main.async {
                    self.error = "Error creating new user: \(response)"
                    print(self.error)
                }
                return false
            }
        } catch {
            print("Request error: \(error)")
            return false
        }
    }
    
    func authenticateUser() async -> Bool {
        
        guard let url = URL(string: "\(baseURL)auth/login") else { return false }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let body: [String: Any] = [
            "email": auth.email,
            "password": auth.password,
        ]

        guard let jsonData = try? JSONSerialization.data(withJSONObject: body, options: []) else {
            return false
        }

        request.httpBody = jsonData

        do {
            let (data, response) = try await URLSession.shared.data(for: request)

            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 201 {
                // Decode the JSON response to get the uid
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                   let uid = json["uid"] as? String {
                    DispatchQueue.main.async {
                        self.auth.uid = uid
                    }
                    print("User authenticated with UID: \(uid)")
                    return true
                } else {
                    print("UID not found in response")
                    return false
                }
            } else {
                DispatchQueue.main.async {
                    self.error = "Error authenticating user: \(response)"
                }
                return false
            }
        } catch {
            print("Request error: \(error)")
            return false
        }
    }
    
    func getCurrentUser() async -> Bool {
        guard let url = URL(string: "\(baseURL)auth/current_user") else { return false }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)

            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                // Decode the JSON response into UserModel
                let decoder = JSONDecoder()
                do {
                    let currentUser = try decoder.decode(AuthModel.self, from: data)
                    DispatchQueue.main.async {
                        self.auth = currentUser
                    }
                    print("Current authenticated user UID: \(auth.uid)")
                    return true
                } catch {
                    print("Error decoding response: \(error)")
                    return false
                }
            } else {
                print("Return user to login/registration.")
                return false
            }
        } catch {
            print("Request error: \(error)")
            return false
        }
    }
    
    func logoutUser() async -> Bool {
        
        guard let url = URL(string: "\(baseURL)auth/logout") else { return false }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let body: [String: Any] = [
            "uid": auth.uid,
        ]

        guard let jsonData = try? JSONSerialization.data(withJSONObject: body, options: []) else {
            print("An error occured preparing the request to logout!")
            return false
        }

        request.httpBody = jsonData

        do {
            let (data, response) = try await URLSession.shared.data(for: request)

            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                print("The current authenticated user has successfully been logged out.")
                return true
            } else {
                print("An error occured while trying to logout!")
                return false
            }
        } catch {
            print("Request error: \(error)")
            return false
        }
    }
}

