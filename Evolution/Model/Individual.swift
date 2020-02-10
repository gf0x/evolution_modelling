//
//  Individual.swift
//  Evolution
//
//  Created by Alex Frankiv on 08.02.2020.
//  Copyright © 2020 g_f0x. All rights reserved.
//

import Foundation

typealias Individual = Array<Symbol>

extension Individual {

	var beautifiedDescription: String {
		return self.reduce("[", { $0 + $1.rawValue }) + "]"
	}
	// TODO: implement health
}

// MARK: - Mutation
extension Individual {

	mutating func mutate(withProbability pM: Double) {
		for index in self.indices {
			if Double.randomProbability < pM {
				self[index].mutate()
			}
		}
	}
}
