//
//  Rws.swift
//  Evolution
//
//  Created by Alex Frankiv on 10.02.2020.
//  Copyright © 2020 g_f0x. All rights reserved.
//

import Foundation

final class Rws: ParentChoosing {

	let stringRepresentation: String = "rws"

	func parents(from testedPopulation: [(individual: Individual, health: Double)], populationSize: Int) -> Population {
		let totalHealth = testedPopulation.map { $1 }.reduce(0, +)
		let beingInPoolProbabilities = testedPopulation.map { ($0, $1 / totalHealth) }
//		let expectedCountInPool = beingInPoolProbabilities.map { ($0.0, Int($0.1) * testedPopulation.count) }

		var parentPool = Population()
		for _ in (0..<populationSize) {
			let randomProbability = Double.randomProbability
			var accumulator = 0.0
			loopIndividuals: for tuple in beingInPoolProbabilities {
				let (individual, probability) = tuple
				accumulator += probability
				if randomProbability <= accumulator {
					parentPool.append(individual)
					break loopIndividuals
				}
			}
		}

		return parentPool
	}
}
