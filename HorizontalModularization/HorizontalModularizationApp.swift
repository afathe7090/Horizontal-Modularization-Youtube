//
//  HorizontalModularizationApp.swift
//  HorizontalModularization
//
//  Created by Ahmed Fathy on 01/08/2026.
//

import Data
import Domain
import Infrastructure
import Presentation
import SwiftUI

@main
struct HorizontalModularizationApp: App {
  var body: some Scene {
    WindowGroup {
      makeRootView()
    }
  }
  
  private func makeRootView() -> some View {
    /// Infrastrucure
    
    /// Data
    let repo = APIRepository()
    
    /// Domain
    let useCase = DomainUseCaseImpl(repo: repo)
    
    /// Presentation
    let viewModel = PresentationViewModel(useCase: useCase)
    let view = PresentationView(viewModel: viewModel)
    return view
  }
}
