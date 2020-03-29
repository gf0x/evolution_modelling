//
//  Stats.swift
//  Evolution
//
//  Created by Alex Frankiv on 29.03.2020.
//  Copyright © 2020 g_f0x. All rights reserved.
//

import Foundation

struct Stats: Codable {
	let mathExpectation: Double
	let sigma: Double
	let moda: [Int]
	let minValue: Int
	let maxValue: Int
	let variationFactor: Double
}
