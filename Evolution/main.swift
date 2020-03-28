//
//  main.swift
//  Evolution
//
//  Created by Alex Frankiv on 08.02.2020.
//  Copyright © 2020 g_f0x. All rights reserved.
//

import Foundation

// MARK: - Algorithm input parameters
// TODO (optional): input from console
let length: UInt = 2_000 //2000 // l
let populationSize: UInt = 10_000 // N
var pM = MutationProbability.basic // Pm mutation probability ofr one symbol
// TODO: implement pM changing
let generationRule: IndividualFactory.GenerationRule = .normal(1)
let numberOfIterations = 20_000

// MARK: - Main flow
let factory = IndividualFactory(length: length, populationSize: populationSize)
let healthStandard = HealthStandardFactory.single.healthStandard(for: Int(length))
print(healthStandard.description)
let parentChoosing: ParentChoosing = TournamentSelection(t: 12)//Rws()
let pX = getPx(forSelectionType: parentChoosing, length: length, populationSize: populationSize)


// MARK: - Initialization (1)
var population = factory.newPopulation(generationRule)
print("Початкова популяція: \(population.beautifiedDescription)")


// MARK: - Main loop (2.0)
print("\r\nЗапуск\r\n")
let formatter = DateFormatter()
formatter.dateFormat = "HH:mm:ss"
for iteration in (1...numberOfIterations) {

	print("## Ітерація: \(iteration) \(formatter.string(from: Date())) (\(Double(iteration) / Double(numberOfIterations) * 100)%)")

	// MARK: - Evaluation (2.1)
	var evaluatedPopulation = population.map { ($0, healthStandard.testFitness(individual: $0)) }

	// MARK: - Kill unhealthy (2.2)
	evaluatedPopulation = evaluatedPopulation.filter { (_, health) in
		// assume that according to the task health of 0.1 is only possible if individual has lethal mutations
		health != 0.1
	}
	// stop if all the individuals are dead
	if evaluatedPopulation.isEmpty { break }

	// MARK: - Analyze + export data
	// TODO: implement properly
//	print(population.healthStats(accordingTo: healthStandard))

	// MARK: - Choose parents' pool (2.3)
	population = parentChoosing.parents(from: evaluatedPopulation)
//	print("Батьківський пул: \(population.beautifiedDescription)")
//
//	print(population.healthStats(accordingTo: healthStandard))

	// MARK: - Commit mutations (2.4)
	population.mutateAll(withProbability: pM)

//	print("\r\n\r\nПопуляція: \(population.beautifiedDescription)")
}

//print("\r\nКінцева популяція: \(population.beautifiedDescription)")
