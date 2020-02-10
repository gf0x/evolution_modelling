//
//  IndividualFactory.swift
//  Evolution
//
//  Created by Alex Frankiv on 08.02.2020.
//  Copyright © 2020 g_f0x. All rights reserved.
//

import Foundation

final class IndividualFactory {

	// MARK: - Constants
	static let perfectSymbol = Symbol.A

	// MARK: - Generation rule
	enum GenerationRule {
		case uber, random, normal
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

	// MARK: - Generating random population
	private func newRandomIndividual() -> Individual {
		return (0..<self.length).map { _ in Symbol.allCases.randomElement()! }
	}

	private func newRandomPopulation() -> Population {
		return (0..<self.populationSize).map { _ in self.newRandomIndividual() }
	}

	// MARK: - Generating normal population
	private func newNormalPopulation() -> Population {
		// TODO: implement
		return []
	}

	// MARK: - Public API
	func newPopulation(_ rule: GenerationRule) -> Population {
		switch rule {
		case .uber: return newUberPopulation()
		case .random: return newRandomPopulation()
		case .normal: return newNormalPopulation()
		}
	}
}
