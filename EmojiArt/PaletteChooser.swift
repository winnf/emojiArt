//
//  PaletteChooser.swift
//  EmojiArt
//
//  Created by Winnie Fong on 11/3/20.
//  Copyright © 2020 Winnie Fong. All rights reserved.
//

import SwiftUI

struct PaletteChooser: View {
    @Binding var chosenPalette: String 
    @ObservedObject var document: EmojiArtDocument
    
    var body: some View {
        HStack {
            Stepper(onIncrement: {
                self.chosenPalette = self.document.palette(after: self.chosenPalette)
            }, onDecrement: {
                self.chosenPalette = self.document.palette(before: self.chosenPalette)
            }, label: { EmptyView()
            })
            Text(self.document.paletteNames[self.chosenPalette] ?? "")
        }
        .fixedSize(horizontal: /*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/, vertical: false)
        .onAppear{ self.chosenPalette = self.document.defaultPalette }
    }
}




struct PaletteChooser_Previews: PreviewProvider {
    static var previews: some View {
        PaletteChooser(chosenPalette: Binding.constant(""), document: EmojiArtDocument())
    }
}
