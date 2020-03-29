//
//  MutationProbability.swift
//  Evolution
//
//  Created by Alex Frankiv on 08.02.2020.
//  Copyright © 2020 g_f0x. All rights reserved.
//

import Foundation

enum MutationProbability: String, CaseIterable {
	case basic
	case high
	case low
	case veryLow

	var value: Double {
		switch self {
		case .basic: return pX // Px
		case .high: return 1.5 * pX // PX+0.5*PX
		case .low: return 0.5 * pX // PX–0.5*PX
		case .veryLow: return 0.1 * pX // PX/10
		}
	}
}

extension Double {

	static var randomProbability: Self {
		return Double.random(in: (0...1))
	}
}
