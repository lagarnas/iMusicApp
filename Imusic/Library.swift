//
//  Library.swift
//  Imusic
//
//  Created by Анастасия Леонтьева on 15.09.2020.
//  Copyright © 2020 lagarnas. All rights reserved.
//

import SwiftUI

struct Library: View {
  var body: some View {
    NavigationView {
      VStack {
        GeometryReader { geometry in
          HStack(spacing: 20) {
            Button(action: {
              print("12345")
            }, label: {
              Image(systemName: "play.fill")
                .frame(width: geometry.size.width / 2 - 10, height: 50)
                .accentColor(Color(#colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1)))
                .background(Color(#colorLiteral(red: 0.9301335812, green: 0.9246042371, blue: 0.9343838096, alpha: 1)))
                .cornerRadius(10)
            })
            Button(action: {
              print("54321")
            }, label: {
              Image(systemName: "arrow.2.circlepath")
                .frame(width: geometry.size.width / 2 - 10, height: 50)
                .accentColor(Color(#colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1)))
                .background(Color(#colorLiteral(red: 0.9301335812, green: 0.9246042371, blue: 0.9343838096, alpha: 1)))
                .cornerRadius(10)
            })
          }
        }.padding().frame(height: 50)
        //сепаратор
        Divider()
          .padding(.top)
          .padding(.leading)
          .padding(.trailing)
        List {
          LibraryCell()
        }
      }
        
      .navigationBarTitle("Library")
    }
  }
}

struct LibraryCell: View {
  var body: some View {
    HStack{
      Image("Image")
        .resizable()
        .frame(width: 60, height: 60)
        .cornerRadius(2)
      VStack {
        Text("Track Name")
        Text("Artist Name")
      }
    }
  }
}

struct Library_Previews: PreviewProvider {
  static var previews: some View {
    Library()
  }
}
