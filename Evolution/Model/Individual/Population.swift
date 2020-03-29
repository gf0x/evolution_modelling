//
//  Population.swift
//  Evolution
//
//  Created by Alex Frankiv on 08.02.2020.
//  Copyright © 2020 g_f0x. All rights reserved.
//

import Foundation

typealias Population = Array<Individual>

extension Population {

	var beautifiedDescription: String {
		return self.reduce("{\r\n", { $0 + $1.beautifiedDescription + "\r\n" }) + "}"
	}
}

// MARK: - Mutation
extension Population {

	mutating func mutateAll(withProbability pM: Double) {
		for index in self.indices {
			self[index].mutate(withProbability: pM)
		}
	}
}

// MARK: - Health stats
extension Population {

	func healthStats(accordingTo standard: HealthStandard) -> String {
		var healthy = 0
		var unhealthy = 0
		var dead = 0
		self
			.map { standard.testFitness(individual: $0) }
			.forEach {
				switch $0 {
				case Double(standard.length): healthy += 1
				case 0.1: dead += 1
				default: unhealthy += 1
				}
		}
		return """
		Здорові: \(healthy)
		Нездорові: \(unhealthy)
		Мертві: \(dead)
		"""
	}
}
