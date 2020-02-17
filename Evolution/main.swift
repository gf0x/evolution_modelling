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
let length: UInt = 100 //2000 // l
let populationSize: UInt = 10 // N
let pX = 0.0015 // Px basic mutation probability for one symbol
var pM = MutationProbability.basic // Pm mutation probability ofr one symbol
// TODO: implement pM changing
let generationRule: IndividualFactory.GenerationRule = .uniform
let numberOfIterations = 1//20_000

// MARK: - Main flow
let factory = IndividualFactory(length: length, populationSize: populationSize)
let healthStandard = try? HealthStandard(forLength: Int(length))
print(healthStandard?.description ?? "Функція пристосованості недоступна для значення довжини l=\(length)")
let parentChoosing: ParentChoosing = Rws()

// MARK: - Initialization
var population = factory.newPopulation(generationRule)
print("Початкова популяція: \(population.beautifiedDescription)")


// MARK: - Main loop
print("\r\nЗапуск\r\n")
for iteration in (1...numberOfIterations) {

	print("Ітерація: \(iteration)")

	population.forEach { individual in
		// MARK: - Evaluation
//		print("Індивід: \(individual), \r\nздоров'я: \(healthStandard!.testFitness(individual: individual))")


		// MARK: - Kill unhealthy (+ drawing!!!!)
		// TODO:  kill if not healthy
	}
	print(population.healthStats(accordingTo: healthStandard!))

	// MARK: - Choose parents' pool
	population = parentChoosing.parents(from:
		population.map { ($0, healthStandard!.testFitness(individual: $0)) }
	)
	print("Батьківський пул: \(population.beautifiedDescription)")

	print(population.healthStats(accordingTo: healthStandard!))

	// MARK: - Commit mutations
	population.mutateAll(withProbability: pM)

//	print("\r\n\r\nПопуляція: \(population.beautifiedDescription)")
}

//print("\r\nКінцева популяція: \(population.beautifiedDescription)")
