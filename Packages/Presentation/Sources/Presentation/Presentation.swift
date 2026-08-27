// The Swift Programming Language
// https://docs.swift.org/swift-book

import SwiftUI
import DesignSystem

public struct PresentationView: View {
  private let viewModel: PresentationViewModel
  public init(viewModel: PresentationViewModel) {
    self.viewModel = viewModel
  }

  public var body: some View {
    Text("Horizontal Modular")
  }
}
