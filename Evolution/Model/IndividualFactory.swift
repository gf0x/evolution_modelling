//
//  IndividualFactory.swift
//  Evolution
//
//  Created by Alex Frankiv on 08.02.2020.
//  Copyright © 2020 g_f0x. All rights reserved.
//

import Foundation
import SwiftStats

final class IndividualFactory {

	// MARK: - Constants
	static let perfectSymbol = Symbol.A

	// MARK: - Generation rule
	enum GenerationRule {
		case uber, uniform, normal
	}

	// MARK: - Parameters
	let length: Int
	let populationSize: Int

	// MARK: - Initialisation
	init(length: UInt, populationSize: UInt) {
		self.length = Int(length)
		self.populationSize = Int(populationSize)
	}

	// MARK: - Generating über population
	// perfect individual according to the task
	private func newUberIndividual() -> Individual {
		return Array<Symbol>(repeating: Self.perfectSymbol, count: self.length)
	}

	private func newUberPopulation() -> Population {
		return Array<Individual>(repeating: newUberIndividual(), count: self.populationSize)
	}

	// MARK: - Generating uniform population
	private func newUniformPopulation() -> Population {
		return self.population(accordingTo: SwiftStats.Distributions.Uniform(a: 0, b: Double(length)))
	}

	// MARK: - Generating normal population
	private func newNormalPopulation() -> Population {
		let halfLength = Double(length) / 2
		return self.population(accordingTo: SwiftStats.Distributions.Normal(m: halfLength, v: halfLength))
	}

	// MARK: - Public API
	func newPopulation(_ rule: GenerationRule) -> Population {
		switch rule {
		case .uber: return newUberPopulation()
		case .uniform: return newUniformPopulation()
		case .normal: return newNormalPopulation()
		}
	}

	// MARK: - Generating population according to distribution
	private func population(accordingTo distribution: SwiftStats.ContinuousDistribution) -> Population {
		let hammingDistances = distribution.random(populationSize).map { Int($0.rounded()) }
		print(hammingDistances)
		let uniDistribution = SwiftStats.Distributions.Uniform(a: 0, b: Double(length) - 1)
		var initialPopulation = newUberPopulation()
		for (hammingDistance, individualIndex) in zip(hammingDistances, initialPopulation.indices) {
			let indicesToMutate = uniDistribution.random(hammingDistance).map { Int($0.rounded()) }
			for index in indicesToMutate {
				initialPopulation[individualIndex][index].mutate()
			}
		}
		return initialPopulation
	}
}
