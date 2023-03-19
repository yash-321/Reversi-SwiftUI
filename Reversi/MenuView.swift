//
//  MenuView.swift
//  Reversi
//
//  Created by Yash Sangha on 14/03/2023.
//

import SwiftUI

struct MenuView: View {
    var body: some View {
        ZStack {
            Color.green
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                Text("Reversi")
                    .font(.largeTitle)
                    .foregroundColor(Color.black)
                    .padding(20)
                
                Spacer()
                
                VStack {
                    Button {
                        print("minimax")
                    } label: {
                        Text("Minimax")
                    }
                    .controlSize(.large)
                    .buttonStyle(.borderedProminent)

                    
                    Button {
                        print("AlphaZero")
                    } label: {
                        Text("AlphaZero")
                    }
                    .controlSize(.large)
                    .buttonStyle(.borderedProminent)
                }
                .tint(.black)
                
                Spacer()
            }
            
        }
    }
}

struct MenuView_Previews: PreviewProvider {
    static var previews: some View {
        MenuView()
    }
}
