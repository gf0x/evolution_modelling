//
//  PxProbability.swift
//  Evolution
//
//  Created by Alex Frankiv on 28.03.2020.
//  Copyright © 2020 g_f0x. All rights reserved.
//

import Foundation

func getPx(forSelectionType parentChoosing: ParentChoosing, length: Int, populationSize: Int) -> Double {
	if let tuple = pxProbabilities.first(where: { tuple in
		tuple.parentChoosing == parentChoosing.stringRepresentation && tuple.l == length && tuple.n == populationSize
	}) {
		return tuple.px
	}
	// else if not found Px for parameters, we take "old" Px according to task
	guard let tuple = pxProbabilities.first(where: { tuple in
		tuple.parentChoosing == parentChoosing.stringRepresentation && tuple.l == length && tuple.n == 200
	}) else {
		fatalError("Px not provided for such parameter set")
	}
	// get k_Px according to n
	guard let k_Px = kPx_factors[populationSize] else {
		fatalError("k_Px not provided for such parameter set")
	}
	return tuple.px / k_Px
}

private let pxProbabilities: [(parentChoosing: String, l: Int, n: Int, px: Double)] = [
	("rws", 10, 100, 0.0004870239),
	("rws", 10, 200, 0.0002274225),
	("rws", 10, 1000, 0.0000489496),
	("rws", 10, 2000, 0.0000244995),
	("rws", 20, 100, 0.0002227478),
	("rws", 20, 200, 0.0001110498),
	("rws", 20, 1000, 0.0000213575),
	("rws", 20, 2000, 0.0000113709),
	("rws", 80, 100, 0.0000430657),
	("rws", 80, 200, 0.0000228516),
	("rws", 80, 1000, 0.0000039427),
	("rws", 80, 2000, 0.0000022934),
	("rws", 100, 100, 0.0000337390),
	("rws", 100, 200, 0.0000168640),
	("rws", 200, 100, 0.0000166470),
	("rws", 200, 200, 0.0000084375),
	("rws", 200, 1000, 0.0000014634),
	("rws", 200, 2000, 0.0000006921),
	("rws", 800, 100, 0.0000041899),
	("rws", 800, 200, 0.0000019844),
	("rws", 800, 1000, 0.0000003447),
	("rws", 1000, 100, 0.0000032762),
	("rws", 1000, 200, 0.0000015809),
	("rws", 1000, 1000, 0.0000002703),
	("rws", 2000, 100, 0.0000017935),
	("rws", 2000, 200, 0.0000007355),
	("tournament_12", 10, 100, 0.0006272644),
	("tournament_12", 10, 200, 0.0003059692),
	("tournament_12", 20, 100, 0.0003172852),
	("tournament_12", 20, 200, 0.0001574341),
	("tournament_12", 80, 100, 0.0000793508),
	("tournament_12", 80, 200, 0.0000385483),
	("tournament_12", 100, 100, 0.0000632922),
	("tournament_12", 100, 200, 0.0000313215),
	("tournament_12", 200, 100, 0.0000308362),
	("tournament_12", 200, 200, 0.0000157269),
	("tournament_12", 800, 100, 0.0000079939),
	("tournament_12", 800, 200, 0.0000039427),
	("tournament_12", 1000, 100, 0.0000061464),
	("tournament_12", 1000, 200, 0.0000030894),
	("tournament_12", 2000, 100, 0.0000030734),
	("tournament_12", 2000, 200, 0.0000015276),
	("tournament_2", 10, 100, 0.0006243530),
	("tournament_2", 10, 200, 0.0003186035),
	("tournament_2", 20, 100, 0.0002970895),
	("tournament_2", 20, 200, 0.0001633118),
	("tournament_2", 80, 100, 0.0000738144),
	("tournament_2", 80, 200, 0.0000391113),
	("tournament_2", 100, 100, 0.0000611609),
	("tournament_2", 100, 200, 0.0000306118),
	("tournament_2", 200, 100, 0.0000311493),
	("tournament_2", 200, 200, 0.0000157214),
	("tournament_2", 800, 100, 0.0000077989),
	("tournament_2", 800, 200, 0.0000040553),
	("tournament_2", 1000, 100, 0.0000060623),
	("tournament_2", 1000, 200, 0.0000030135),
	("tournament_2", 2000, 100, 0.0000029490),
	("tournament_2", 2000, 200, 0.0000015079),
]

private let kPx_factors: [Int: Double] = [
	1000:	6.2612573371,
	2000:	14.0900462671,
	4000:	31.1560236571,
	5000:	38.9353303171,
	10000:	88.8769,
]
