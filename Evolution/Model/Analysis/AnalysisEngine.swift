//
//  AnalysisEngine.swift
//  Evolution
//
//  Created by Alex Frankiv on 29.03.2020.
//  Copyright © 2020 g_f0x. All rights reserved.
//

import Foundation

class AnalysisEngine {

	// MARK: - Single
	static let single = AnalysisEngine()
	private init() {}

	// MARK: - Internal API
	func analyze(_ evaluatedPopulation: [(Individual, Double)], individualFactory: IndividualFactory)
		-> AnalysisStats {
			let population = evaluatedPopulation.map { $0.0 }
			// init
			let targetIndividual = individualFactory.uberIndividual
			let wildType = self.wildType(for: population)
			// get distances
			let distances = self.countDistances(for: population, targetIndividual: targetIndividual, wildType: wildType)
			// Hamming pairs
			let hammingStats = self.countStats(for: distances.hammingPairs.flatMap { $0 })
			let hammingPairs = HammingDistancePairs(pairedDistances: distances.hammingPairs,
													pairedDistancesEnumerated: hammingStats.1,
													stats: hammingStats.0)
			// Target Distances
			let targetStats = self.countStats(for: distances.targetDistances)
			let targetDistances = HammingDistanceTarget(distances: distances.targetDistances,
														distancesEnumerated: targetStats.1,
														stats: targetStats.0)
			// Wild Distances
			let wildStats = self.countStats(for: distances.wildDistances)
			let wildDistances = HammingDistanceWild(wildType: wildType,
													distances: distances.wildDistances,
													distancesEnumerated: wildStats.1,
													stats: wildStats.0)
			// polymorphicGenes
			let polymorphicCount = self.getPolymorohicGenesPercentage(for: population,
																	  targetType: targetIndividual,
																	  wildType: wildType)
			// wild type info
			let distanceWildTarget = targetIndividual <-> wildType
			let polymorphicGenesToTargetPercentage = Double(distanceWildTarget) / Double(targetIndividual.count) * 100
			let wildTypeInfo = WildTypeInfo(polymorphicGenesToTargetCount: distanceWildTarget,
											polymorphicGenesToTargetPercentage: polymorphicGenesToTargetPercentage)
			// health deviation
			let populationHealth = evaluatedPopulation.map { $0.1 }
			// N.B! targetIndividual.count == max health possible
			let averageHealthDeviation =
				abs((populationHealth.reduce(0, +) / Double(populationHealth.count)) - Double(targetIndividual.count))
			let maxHealthDeviation =
				abs(populationHealth.max()! - Double(targetIndividual.count))
			// return
			return AnalysisStats(individuals: population,
								 hammingDistancePairs: hammingPairs,
								 hammingDistanceTarget: targetDistances,
								 hammingDistanceWild: wildDistances,
								 singlePolymorphicGenesPercentageAccornigToTarget: polymorphicCount.singleAccordingToTarget,
								 multiplePolymorphicGenesPercentageAccornigToTarget: polymorphicCount.multipleAccordingToTarget,
								 polymorphicGenesPercentageAccornigToWildType: polymorphicCount.accordingToWild,
								 wildTypeInfo: wildTypeInfo,
								 averageHealthDeviation: averageHealthDeviation,
								 maxHealthDeviation: maxHealthDeviation)
	}


	// MARK: - Private
	private func countDistances(for population: Population, targetIndividual: Individual, wildType: Individual)
		-> (hammingPairs: [[Int]], targetDistances: [Int], wildDistances: [Int]) {
			// get distances
			var hammingPairs = [[Int]]()
			var targetDistances = [Int]()
			var wildDistances = [Int]()
			for i in 0..<population.count {
				targetDistances.append(targetIndividual <-> population[i])
				wildDistances.append(wildType <-> population[i])
				var distances = [Int]()
				for j in i+1..<population.count {
					distances.append(population[i] <-> population[j])
				}
				hammingPairs.append(distances)
			}
			// return
			return (hammingPairs: hammingPairs, targetDistances: targetDistances, wildDistances: wildDistances)
	}

	private func countStats(for distances: [Int]) -> (Stats, [Int: Int]) {
		let enumeratedDistances = self.enumerated(distances, valueFunction: { $0 })
		let mathExpectation = enumeratedDistances.reduce(0.0) { (accumulator, keyValue) in
			accumulator + (Double(keyValue.key) * Double(keyValue.value) / Double(distances.count) )
		}
		let sigma = enumeratedDistances.reduce(0.0) { (accumulator, keyValue) in
			let percentage = Double(keyValue.value) / Double(distances.count)
			let val = (pow(abs(Double(keyValue.key) - mathExpectation), 2) *  percentage)
			return accumulator + val
		}
		let biggestFrequency = enumeratedDistances.values.max()!
		return (Stats(mathExpectation: mathExpectation,
					  sigma: sigma,
					  moda: Array(Set(distances.filter { enumeratedDistances[$0] == biggestFrequency })),
					  minValue: enumeratedDistances.keys.min()!,
					  maxValue: enumeratedDistances.keys.max()!,
					  variationFactor: sigma / ((mathExpectation == 0) ? 1 : mathExpectation)),
				enumeratedDistances
		)
	}

	private func getPolymorohicGenesPercentage(for population: Population, targetType: Individual, wildType: Individual)
		-> (singleAccordingToTarget: Double, multipleAccordingToTarget: Double, accordingToWild: Double) {
			var singleTargetCounter = 0.0
			var multipleTargetCounter = 0.0
			var wildCounter = 0.0
			for i in 0..<targetType.count {
				var singleTargetDiffFound = false
				var multipleTargetDiffFound = false
				var targetDiffSymbol: Symbol?
				var wildDiffFound = false
				for individual in population {
					if individual[i] != targetType[i] {
						if !singleTargetDiffFound {
							singleTargetDiffFound = true
							targetDiffSymbol = individual[i]
							singleTargetCounter += 1
						} else if individual[i] != targetDiffSymbol {
							multipleTargetDiffFound = true
							singleTargetCounter -= 1
							multipleTargetCounter += 1
						}
					}
					if individual[i] != wildType[i] && !wildDiffFound {
						wildDiffFound = true
						wildCounter += 1
					}
					if multipleTargetDiffFound && wildDiffFound {
						break
					}
				}
			}
			return (singleAccordingToTarget: singleTargetCounter / Double(targetType.count) * 100,
					multipleAccordingToTarget: multipleTargetCounter / Double(targetType.count) * 100,
					accordingToWild: wildCounter / Double(wildType.count) * 100)
	}

	private func enumerated<T, V>(_ array: [T], valueFunction: (T) -> V) -> [V: Int] {
		var counter = [V: Int]()
		array.forEach { value in
			let symbol = valueFunction(value)
			if let symCounter = counter[symbol] {
				counter[symbol] = symCounter + 1
			} else {
				counter[symbol] = 1
			}
		}
		return counter
	}

	private func wildType(for population: Population) -> Individual {
		var wildType = Individual()
		for i in 0..<population.first!.count {
			let counter = self.enumerated(population) { $0[i] }
			let wildSymbol = counter.max { a, b in a.value < b.value }!.0
			wildType.append(wildSymbol)
		}
		return wildType
	}
}

// MARK: - Hamming distance calculation
infix operator <->
func <->(lhs: Individual, rhs: Individual) -> Int {
	// assume Individual lengths are same
	return zip(lhs, rhs).reduce(0, { $0 + ($1.0 == $1.1 ? 0 : 1) })
}
