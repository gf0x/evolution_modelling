//
//  HealthStandard.swift
//  Evolution
//
//  Created by Alex Frankiv on 09.02.2020.
//  Copyright © 2020 g_f0x. All rights reserved.
//

import Foundation

class HealthStandardFactory {

	// MARK: - Singleton
	static let single = HealthStandardFactory()
	private init() {}

	// MARK: - Registry of standards
	private var readyStasndards = [Int: HealthStandard]()

	// MARK: - Factory method
	func healthStandard(for length: Int) -> HealthStandard {
		if let standard = readyStasndards[length] {
			return standard
		} else {
			let standard = HealthStandard(forLength: length)
			self.readyStasndards[length] = standard
			return standard
		}
	}
}

class HealthStandard {

	// MARK: - Mutation type
	enum MutationType {
		case none
		case neutral
		case patogenic
		case lethal
	}

	// MARK: - Task constants
	private let neutralMutation1Percentage = 0.0637
	private let neutralMutation2Percentage = 0.402
	private let neutralMutation3Percentage = 0.1567
	private let patogenicMutationPercentage = 0.0232

	// MARK: - Properties
	let length: Int
	// neutral mutation 1
	private let neutralMutation1Range: Set<Int>
	private let neutralMutation1SafeSymbol = Symbol.allCases.randomElement()!
	// neutral mutation 2
	private var neutralMutation2Range = Set<Int>()
	private let neutralMutation2SafeSymbol = Symbol.allCases.randomElement()!
	// neutral mutation 3
	private var neutralMutation3Range = Set<Int>()
	// patogenic mutation
	private var patogenicMutationRange = Set<Int>()

	// MARK: - Lifecycle
	fileprivate init(forLength length: Int) {
		self.length = length
		// neutral mutation 1
		self.neutralMutation1Range = Set<Int>((0..<Int((Double(length) * neutralMutation1Percentage).rounded())))
		// neutral mutation 2
		let safe2IndexesCount = Int((Double(length) * neutralMutation2Percentage).rounded())
		while self.neutralMutation2Range.count < safe2IndexesCount {
			let index = Int.random(in: (0..<length))
			guard !self.neutralMutation1Range.contains(index) else { continue }
			self.neutralMutation2Range.insert(index)
		}
		// neutral mutation 3
		let safe3IndexesCount = Int((Double(length) * neutralMutation3Percentage).rounded())
		while self.neutralMutation3Range.count < safe3IndexesCount {
			let index = Int.random(in: (0..<length))
			guard !self.neutralMutation1Range.contains(index) && !self.neutralMutation2Range.contains(index)
				else { continue }
			self.neutralMutation3Range.insert(index)
		}
		// patogenic mutation
		let unsafeIndexesCount = Int((Double(length) * patogenicMutationPercentage).rounded())
		while self.patogenicMutationRange.count < unsafeIndexesCount {
			let index = Int.random(in: (0..<length))
			guard !self.neutralMutation1Range.contains(index) &&
				!self.neutralMutation2Range.contains(index) &&
				!self.neutralMutation3Range.contains(index)
				else { continue }
			self.patogenicMutationRange.insert(index)
		}
	}

	// MARK: - Standards
	private lazy var neutralMutation1: (Symbol, Int) -> Bool = { [unowned self] (symbol, index) in
		return self.neutralMutation1Range.contains(index) &&
			(index % 3 != 0 || symbol == self.neutralMutation1SafeSymbol)
	}

	private lazy var neutralMutation2: (Symbol, Int) -> Bool = { [unowned self] (symbol, index) in
		return self.neutralMutation2Range.contains(index) && symbol == self.neutralMutation2SafeSymbol
	}

	private lazy var neutralMutation3: (Symbol, Int) -> Bool = { [unowned self] (_, index) in
		return self.neutralMutation3Range.contains(index)
	}

	private lazy var patogenicMutation: (Symbol, Int) -> Bool = { [unowned self] (_, index) in
		return self.patogenicMutationRange.contains(index)
	}

	// MARK: - Test individual
	private func mutationType(of symbol: Symbol, at index: Int) -> MutationType {
		if symbol == IndividualFactory.perfectSymbol {
			return .none
		} else if self.neutralMutation1(symbol, index) ||
			self.neutralMutation2(symbol, index) ||
			self.neutralMutation3(symbol, index) {
			return .neutral
		} else if self.patogenicMutation(symbol, index) {
			return .patogenic
		} else {
			return .lethal
		}
	}

	func testFitness(individual: Individual) -> Double {
		guard self.length >= 100 else { return Double(self.length) }
		var patogenicCount = 0
		for (index, symbol) in individual.enumerated() {
			switch mutationType(of: symbol, at: index) {
			case .none, .neutral: ()
			case .patogenic: patogenicCount += 1
			case .lethal: return 0.1
			}
		}
		return Double(self.length - 10 * patogenicCount)
	}
}

// MARK: - CustomStringConvertible
extension HealthStandard: CustomStringConvertible {

	var description: String {
		return """
		==============================================================
		Перше нейтральне правило:
		допустимі локуси: \(neutralMutation1Range)
		безпечний нуклеотид: \(neutralMutation1SafeSymbol)

		Друге нейтральне правило:
		допустимі локуси: \(neutralMutation2Range)
		безпечний нуклеотид: \(neutralMutation2SafeSymbol)

		Третє нейтральне правило:
		допустимі локуси: \(neutralMutation3Range)

		Патогенне правило:
		патогенні локуси: \(patogenicMutationRange)
		==============================================================
		"""
	}
}
