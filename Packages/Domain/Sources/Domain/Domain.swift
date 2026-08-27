// The Swift Programming Language
// https://docs.swift.org/swift-book

public protocol DomainUseCase {
  func send()
}

public final class DomainUseCaseImpl: DomainUseCase {
  private let repo: Repository
  public init(repo: Repository) {
    self.repo = repo
  }

  public func send() {
    repo.send()
  }
}
