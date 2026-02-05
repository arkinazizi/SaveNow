//
//  ContentView.swift
//  SaveNow
//
//  Created by Arkin Azizi on 25.12.2025.
//

import SwiftUI
struct ContentView: View {
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Image(systemName: "arrow.down.circle.fill")
                    .resizable()
                    .frame(width: 100, height: 100)
                    .foregroundColor(.blue)
                
                Text("Save Now")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                Text("How to use:")
                    .font(.headline)
                    .padding(.top)
                
                VStack(alignment: .leading, spacing: 10) {
                    StepView(number: 1, text: "Open Instagram")
                    StepView(number: 2, text: "Find a Reel or Post")
                    StepView(number: 3, text: "Tap the '...' or Share button")
                    StepView(number: 4, text: "Select 'InstaDown'")
                }
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(10)
                
                Spacer()
                
                Text("Designed by Arkin")
                    .font(.headline)
                    .padding(.top)
            }
            .padding(50)
            .navigationTitle("")
        }
    }
}
struct StepView: View {
    let number: Int
    let text: String
    
    var body: some View {
        HStack {
            Text("\(number).")
                .fontWeight(.bold)
                .foregroundColor(.blue)
            Text(text)
        }
    }
}
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


