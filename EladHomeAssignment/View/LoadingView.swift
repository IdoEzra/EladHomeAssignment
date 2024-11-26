//
//  LoadingView.swift
//  EladHomeAssignment
//
//  Created by Ido Ezra on 26/11/2024.
//

import SwiftUI

struct LoadingView: View {
    var body: some View {
        ProgressView()
            .progressViewStyle(.circular)
            .scaleEffect(2.0)
            .tint(.indigo)
    }
}

#Preview {
    LoadingView()
}
