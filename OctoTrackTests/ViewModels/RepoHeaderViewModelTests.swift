//
//  RepoHeaderViewModelTests.swift
//  OctoTrackTests
//
//  Created by Julien Cotte on 27/06/2025.
//

import XCTest
@testable import OctoTrack

final class RepoHeaderViewModelTests: XCTestCase {
    var sut: RepoHeaderViewModel!
    var testRepository: Repository!
    
    override func setUp() {
        super.setUp()
        testRepository = makeTestRepository()
        sut = RepoHeaderViewModel(repository: testRepository)
    }
    
    override func tearDown() {
        sut = nil
        testRepository = nil
        super.tearDown()
    }

    // MARK: - Initialization Tests
    
    func test_init_setsRepositoryCorrectly() {
        XCTAssertEqual(sut.repository.id, testRepository.id)
        XCTAssertEqual(sut.repository.name, testRepository.name)
    }

    // MARK: - Pull Request Count Tests
    
    func test_pullRequestCounts_returnsZeroWhenNoPullRequests() {
        // Repository sans pull requests
        XCTAssertEqual(sut.openPRCount, 0)
        XCTAssertEqual(sut.closedPRCount, 0)
        XCTAssertEqual(sut.mergedPRCount, 0)
        XCTAssertEqual(sut.totalPRCount, 0)
    }
    
    func test_openPRCount_returnsCorrectCount() {
        let openPR1 = makeTestPullRequest(state: .open)
        let openPR2 = makeTestPullRequest(state: .open)
        let closedPR = makeTestPullRequest(state: .closed)
        
        testRepository.pullRequests = [openPR1, openPR2, closedPR]
        
        XCTAssertEqual(sut.openPRCount, 2)
    }
    
    func test_closedPRCount_returnsCorrectCount() {
        let openPR = makeTestPullRequest(state: .open)
        let closedPR1 = makeTestPullRequest(state: .closed)
        let closedPR2 = makeTestPullRequest(state: .closed)
        
        testRepository.pullRequests = [openPR, closedPR1, closedPR2]
        
        XCTAssertEqual(sut.closedPRCount, 2)
    }
    
    func test_mergedPRCount_returnsCorrectCount() {
        let openPR = makeTestPullRequest(state: .open)
        let mergedPR1 = makeTestPullRequest(state: .merged)
        let mergedPR2 = makeTestPullRequest(state: .merged)
        let mergedPR3 = makeTestPullRequest(state: .merged)
        
        testRepository.pullRequests = [openPR, mergedPR1, mergedPR2, mergedPR3]
        
        XCTAssertEqual(sut.mergedPRCount, 3)
    }
    
    func test_totalPRCount_returnsCorrectTotal() {
        let openPR = makeTestPullRequest(state: .open)
        let closedPR = makeTestPullRequest(state: .closed)
        let mergedPR1 = makeTestPullRequest(state: .merged)
        let mergedPR2 = makeTestPullRequest(state: .merged)
        
        testRepository.pullRequests = [openPR, closedPR, mergedPR1, mergedPR2]
        
        XCTAssertEqual(sut.totalPRCount, 4)
    }
    
    func test_allCounts_sumToTotal() {
        let openPR1 = makeTestPullRequest(state: .open)
        let openPR2 = makeTestPullRequest(state: .open)
        let closedPR1 = makeTestPullRequest(state: .closed)
        let mergedPR1 = makeTestPullRequest(state: .merged)
        let mergedPR2 = makeTestPullRequest(state: .merged)
        let mergedPR3 = makeTestPullRequest(state: .merged)
        
        testRepository.pullRequests = [openPR1, openPR2, closedPR1, mergedPR1, mergedPR2, mergedPR3]
        
        let sumOfCounts = sut.openPRCount + sut.closedPRCount + sut.mergedPRCount
        
        XCTAssertEqual(sumOfCounts, sut.totalPRCount)
        XCTAssertEqual(sut.totalPRCount, 6)
    }

    // MARK: - Helper Methods
    
    private func makeTestPullRequest(state: Status) -> PullRequest {
        let pr = UserDataManagerTestHelpers.makeTestPullRequest()
        
        // Simuler l'état en modifiant les dates appropriées
        switch state {
        case .open:
            pr.closedAt = nil
            pr.mergedAt = nil
        case .closed:
            pr.closedAt = Date()
            pr.mergedAt = nil
        case .merged:
            pr.closedAt = nil
            pr.mergedAt = Date()
        default:
            break
        }
        
        return pr
    }
}
