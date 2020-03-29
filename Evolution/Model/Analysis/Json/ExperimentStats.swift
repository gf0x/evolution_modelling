//
//  ExperimentStats.swift
//  Evolution
//
//  Created by Alex Frankiv on 29.03.2020.
//  Copyright © 2020 g_f0x. All rights reserved.
//

import Foundation

struct ExperimentStats: Codable {

	// MARK: - Constants (according to task)
	static let maxSingleTargetPolymorphicPercentage = 42.32 // %
	static let maxMultipleTargetPolymorphicPercentage = 19.91 // %

	// MARK: - Properties
	let identifier: String
	let stats: [AnalysisStats]
	let iterationsWithMaxSingleTargetPolymorphicPercentage: [Int]
	let iterationsWithMaxMultipleTargetPolymorphicPercentage: [Int]

	// MARK: - Init
	init(identifier: String, stats: [AnalysisStats]) {
		self.identifier = identifier
		self.stats = stats
		self.iterationsWithMaxSingleTargetPolymorphicPercentage =
			self.stats
				.map { $0.singlePolymorphicGenesPercentageAccornigToTarget }
				.filter { $0 == Self.maxSingleTargetPolymorphicPercentage }
				.enumerated()
				.map { $0.offset }
		self.iterationsWithMaxMultipleTargetPolymorphicPercentage =
			self.stats
				.map { $0.multiplePolymorphicGenesPercentageAccornigToTarget }
				.filter { $0 == Self.maxMultipleTargetPolymorphicPercentage }
				.enumerated()
				.map { $0.offset }
	}
}
