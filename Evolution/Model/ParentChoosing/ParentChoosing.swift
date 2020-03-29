//
//  ParentChoosing.swift
//  Evolution
//
//  Created by Alex Frankiv on 10.02.2020.
//  Copyright © 2020 g_f0x. All rights reserved.
//

import Foundation

protocol ParentChoosing {
	var stringRepresentation: String { get }
	func parents(from testedPopulation: [(individual: Individual, health: Double)], populationSize: Int) -> Population
}
