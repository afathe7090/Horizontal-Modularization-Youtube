//
//  PresentationViewModel.swift
//  Presentation
//
//  Created by Ahmed Fathy on 02/08/2026.
//

import Domain

public final class PresentationViewModel {
  private let useCase: DomainUseCase
  public init(useCase: DomainUseCase) {
    self.useCase = useCase
  }
}
