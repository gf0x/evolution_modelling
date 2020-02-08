//
//  main.swift
//  Evolution
//
//  Created by Alex Frankiv on 08.02.2020.
//  Copyright © 2020 g_f0x. All rights reserved.
//

import Foundation

// MARK: - Algorithm input parameters
// TODO: input from console
let length: UInt = 100 // l
let populationSize: UInt = 10 // N
let pX = 0.15 // Px mutation possibility for one symbol
let generationRule: IndividualFactory.GenerationRule = .random
let numberOfIterations = 20_000

// MARK: - Main flow
let factory = IndividualFactory(length: length, populationSize: populationSize)

// MARK: - Initialization
var population = factory.newPopulation(generationRule)
print("Початкова популяція: \(population.beautifiedDescription)")


// MARK: - Main loop
print("\r\nЗапуск\r\n")
for iteration in (1...numberOfIterations) {

	print("Ітерація: \(iteration)")

	// MARK: - Evaluation
	// TODO: implement

	// MARK: - Kill unhealthy (+ drawing)
	// TODO: implement

	// MARK: - Choose parents' pool
	// TODO: implement

	// MARK: - Commit mutations
	// TODO: implement
}

print("\r\nКінцева популяція: \(population.beautifiedDescription)")
