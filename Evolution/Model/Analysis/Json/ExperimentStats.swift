//
//  ExperimentStats.swift
//  Evolution
//
//  Created by Alex Frankiv on 29.03.2020.
//  Copyright © 2020 g_f0x. All rights reserved.
//

import Foundation

struct ExperimentStats: Codable {
	let identifier: String
	let stats: [AnalysisStats]
}
