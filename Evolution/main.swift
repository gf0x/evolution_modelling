//
//  main.swift
//  Evolution
//
//  Created by Alex Frankiv on 08.02.2020.
//  Copyright © 2020 g_f0x. All rights reserved.
//

import Foundation

func getDocumentsDirectory() -> URL {
    let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    return paths[0]
}

// MARK: - Algorithm input parameters
// TODO (optional): input from console
let length: UInt = 10 //2000 // l
let populationSize: UInt = 100 // N
var pM = MutationProbability.basic // Pm mutation probability for one symbol
let generationRule: IndividualFactory.GenerationRule = .normal(1)
let numberOfIterations = 10 // 20_000

// MARK: - Main flow
let factory = IndividualFactory(length: length, populationSize: populationSize)
let healthStandard = HealthStandardFactory.single.healthStandard(for: Int(length))
print(healthStandard.description)
let parentChoosing: ParentChoosing = TournamentSelection(t: 12)//Rws()
let pX = getPx(forSelectionType: parentChoosing, length: length, populationSize: populationSize)


// MARK: - Initialization (1)
let repetition = 1
let experimentIdentifier =
"exp-\(length)-\(populationSize)-\(generationRule.stringRepresentation)-\(parentChoosing.stringRepresentation)-\(pM.rawValue)-\(repetition)"
var analysisStats = [AnalysisStats]()

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
		health > 0.1
	}
	// stop if all the individuals are dead
	if evaluatedPopulation.isEmpty { break }

	// MARK: - Analyze + export data
	// TODO: implement properly
	let analysisData = AnalysisEngine.single.analyze(evaluatedPopulation, individualFactory: factory)
	analysisStats.append(analysisData)
//	print(population.healthStats(accordingTo: healthStandard))

	// MARK: - Choose parents' pool (2.3)
	population = parentChoosing.parents(from: evaluatedPopulation, populationSize: Int(populationSize))
//	print("Батьківський пул: \(population.beautifiedDescription)")
//
//	print(population.healthStats(accordingTo: healthStandard))

	// MARK: - Commit mutations (2.4)
	population.mutateAll(withProbability: pM.value)

//	print("\r\n\r\nПопуляція: \(population.beautifiedDescription)")
}

let experimentStats = ExperimentStats(identifier: experimentIdentifier,
									  stats: analysisStats)
let data = try! JSONEncoder().encode(experimentStats)
let filename = URL(string: "file://\(CommandLine.arguments[1])\(experimentIdentifier).json")!
try! data.write(to: filename)
//print("\r\nКінцева популяція: \(population.beautifiedDescription)")
