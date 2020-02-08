//
//  Population.swift
//  Evolution
//
//  Created by Alex Frankiv on 08.02.2020.
//  Copyright © 2020 g_f0x. All rights reserved.
//

import Foundation

typealias Population = Array<Individual>

extension Population {

	var beautifiedDescription: String {
		return self.reduce("{\r\n", { $0 + $1.beautifiedDescription + "\r\n" }) + "}"
	}
}
