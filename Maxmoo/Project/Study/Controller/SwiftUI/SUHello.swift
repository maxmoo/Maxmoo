//
//  SUHello.swift
//  Maxmoo
//
//  Created by 程超 on 2023/12/22.
//

import SwiftUI

struct SUHello: View {
    @State var count = 0
    var title: String = "Hello, World!"
    var body: some View {
        VStack {
            Button(action: {self.count += 1}, label: {Text(title)
                .padding()
                .background(Color(.tertiarySystemFill))
                .cornerRadius(5)})
            
            if count > 0 {
                Text("You are taped \(count) times")
            } else {
                Text("You are not taped!")
            }
        }.frame(width: 200, height: 200)
        .border(Color.black)
    }
}

struct SUHello_Previews: PreviewProvider {
    static var previews: some View {
        SUHello(title: "xxxxxxx")
    }
}
