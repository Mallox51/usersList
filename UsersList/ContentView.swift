//
//  ContentView.swift
//  UsersList
//
//  Created by Emmanuel Digiaro on 13/09/2022.
//

import SwiftUI

struct ContentView: View {
    @State var users: [UserModel] = []
    
    var body: some View {
        NavigationView {
            VStack {
                List(self.users, id: \.id) { (user) in
                    UserRowView(user: user)
                }
            }
            .navigationTitle("Avg review scores")
        }.onAppear(
            perform: {
                guard let url: URL = URL(string: "https://preprod-api.bbst.eu/test_tech") else {
                    print("invalid URL")
                    return
                }
                
                var urlRequest: URLRequest = URLRequest(url: url)
                urlRequest.httpMethod = "GET"
                URLSession.shared.dataTask(with: urlRequest, completionHandler: { (data, response, error) in
                    
                    guard let data = data else {
                        print("invalid response")
                        return
                    }
                    do {
                        let response = try JSONDecoder().decode(ResponseModel.self, from: data)
                        self.users = response.data.sorted(by: { $0.averageReviewScore ?? 0.0 > $1.averageReviewScore ?? 0.0  })
                    } catch {
                        print(String(describing: error))
                    }
                }).resume()
            })
    }
}

struct UserRowView: View {
    var user: UserModel
    
    var body: some View {
        HStack {
            HStack(spacing: 3) {
                AsyncImage(url: URL(string: user.defaultPictureUrl ?? "")) { image in
                    image.resizable()
                } placeholder: {
                    ZStack {
                        Color.gray
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: Color.white))
                    }
                }
                .frame(width: 50, height: 50)
                .clipShape(RoundedRectangle(cornerRadius: 25))
                Text(user.firstName ?? "")
                    .foregroundColor(.secondary)
                    .font(.headline)
                Text(user.lastName ?? "")
                    .foregroundColor(.primary)
                    .font(.headline)
            }
            Spacer()
            if let score = user.averageReviewScore {
                Text("\(score, specifier: "%.2f")")
                    .foregroundColor(.secondary)
                    .font(.headline)
                
            } else {
                Text("-")
                    .foregroundColor(.secondary)
                    .font(.headline)
            }
            Image(systemName: "star.fill")
                .foregroundColor(.yellow)
                .font(.system(size: 22))
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(users: [])
    }
}
