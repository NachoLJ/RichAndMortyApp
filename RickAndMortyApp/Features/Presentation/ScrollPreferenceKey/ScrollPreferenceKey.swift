//
//  ScrollPreferenceKey.swift
//  RickAndMortyApp
//
//  Created by Ignacio Lopez Jimenez on 15/4/24.
//

import SwiftUI

struct ScrollPreferenceKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}
