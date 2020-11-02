//
//  OptionalImage.swift
//  EmojiArt
//
//  Created by Winnie Fong on 10/31/20.
//  Copyright © 2020 Winnie Fong. All rights reserved.
//

import SwiftUI

struct OptionalImage: View {
    var uiImage: UIImage?
    
    var body: some View {
        Group {
            if uiImage != nil {
                Image(uiImage: uiImage!)
            }
        }

    }
}
