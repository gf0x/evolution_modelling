//
//  Settings.swift
//  Evolution
//
//  Created by Alex Frankiv on 29.03.2020.
//  Copyright © 2020 g_f0x. All rights reserved.
//

import Foundation

let lengthAndPopulationSizeSettings = [
	10: [100, 200, 1_000],
	20: [100, 200, 1_000, 2_000],
//	50: [100, 200, 1_000, 2_000],
	100: [100, 200, 1_000, 2_000, 5_000, 10_000],
	200: [100, 200, 1_000, 2_000, 5_000, 10_000],
//	500: [100, 200, 1_000, 2_000, 5_000, 10_000],
	1_000: [100, /*200,*/ 1_000, 2_000, 5_000, 10_000, /*20_000, 80_000*/],
	2_000: [100, 200, 1_000, 2_000, 5_000, 10_000, /*20_000, 80_000*/]
]

let pmSettings = MutationProbability.allCases

let populationGeneratingRulesSettings: [IndividualFactory.GenerationRule] = [
	.uber,
	.normal(1),
	.normal(3)
]

let parentChoosingSettings: [ParentChoosing] = [
	Rws(),
	TournamentSelection(t: 2),
	TournamentSelection(t: 12)
]

let repetitionSettings = 5
let numberOfIterationsSetting = 20_000
