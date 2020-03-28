//
//  TournamentSelection.swift
//  Evolution
//
//  Created by Alex Frankiv on 18.02.2020.
//  Copyright © 2020 g_f0x. All rights reserved.
//

import Foundation
import SwiftStats

final class TournamentSelection: ParentChoosing {

	lazy var stringRepresentation: String = {
		"tournament_\(self.t)"
	}()

	// MARK: - Properties
	let t: Int

	// MARK: - Init
	init(t: Int) {
		self.t = t
	}

	// MARK: - ParentChoosing
	func parents(from testedPopulation: [(individual: Individual, health: Double)]) -> Population {
		var parentPool = Population()
		for _ in (0..<testedPopulation.count) {
			let tournamentMembers = Distributions.Uniform(a: 0, b: Double(testedPopulation.count - 1))
				.random(self.t)
				.map { testedPopulation[Int($0.rounded())] }
			let winner = tournamentMembers.max(by: { $0.health < $1.health })!
			parentPool.append(winner.individual)
		}
		return parentPool
	}
}
