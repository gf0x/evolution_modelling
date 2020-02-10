//
//  MutationProbability.swift
//  Evolution
//
//  Created by Alex Frankiv on 08.02.2020.
//  Copyright © 2020 g_f0x. All rights reserved.
//

import Foundation

class MutationProbability {
	static let basic = pX // Px
	static let high = 1.5 * pX // PX+0.5*PX
	static let low = 0.5 * pX // PX–0.5*PX
	static let veryLow = 0.1 * pX // PX/10
}

extension Double {

	static var randomProbability: Self {
		return Double.random(in: (0...1))
	}
}
