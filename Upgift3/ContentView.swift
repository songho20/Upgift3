//
//  ContentView.swift
//  Upgift3
//
//  Created by Soniya Ghorbani on 2024-10-30.
//
import SwiftUI

struct ContentView: View {
    
    @State private var dogImageURL: String = "https://images.dog.ceo/breeds/boxer/n02096585_6827.jpg" // Default image
    @State private var isLoading: Bool = false
    
    var body: some View {
        
        VStack {
            Image(systemName: "pawprint.fill") // A dog pawprint icon
                .imageScale(.large)
                .foregroundStyle(.tint)
            
            // AsyncImage to load the image from the URL
            AsyncImage(url: URL(string: dogImageURL)) { image in
                image
                    .resizable()
                    .scaledToFit()
                    .frame(width: 300, height: 300)
                    .cornerRadius(10)
            } placeholder: {
                Color.gray.opacity(0.3)
                    .frame(width: 300, height: 300)
                    .cornerRadius(10)
            }
            
            // Button to fetch a new dog image
            Button("New Dog Image") {
                Task {
                    await loadDogImage()
                }
            }
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(10)
        }
        .padding()
        .onAppear {
            // Optionally, load a random dog image when the view appears
            Task {
                await loadDogImage()
            }
        }
    }
    
    // Function to load a new dog image from the Dog CEO API
    func loadDogImage() async {
        let dogAPI = "https://dog.ceo/api/breeds/image/random"
        
        guard let url = URL(string: dogAPI) else {
            print("Invalid URL")
            return
        }
        
        print("Fetching data from URL: \(url)") // Log URL for debugging
        
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            
            // Debugging response status
            if let httpResponse = response as? HTTPURLResponse {
                print("HTTP Response: \(httpResponse.statusCode)")
            }
            
            if let decodedResponse = try? JSONDecoder().decode(DogImageResponse.self, from: data) {
                // Update the image URL with the new random dog image URL
                dogImageURL = decodedResponse.message
                print("Received Dog Image URL: \(decodedResponse.message)")
            }

        } catch {
            print("Failed to load dog image: \(error.localizedDescription)")
        }
    }
}

struct DogImageResponse: Codable {
    var message: String // URL of the random dog image
    var status: String  // Status of the API call
}

#Preview {
    ContentView()
}
