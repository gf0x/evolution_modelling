//
//  Symbol.swift
//  Evolution
//
//  Created by Alex Frankiv on 08.02.2020.
//  Copyright © 2020 g_f0x. All rights reserved.
//

import Foundation

enum Symbol: String, Codable, CaseIterable, CustomStringConvertible {
	case A, C, T, G

	var description: String {
		return self.rawValue
	}

	mutating func mutate() {
		let fixedPreviousValue = self
		repeat {
			self = Symbol.allCases.randomElement()!
		} while self == fixedPreviousValue
	}
}
