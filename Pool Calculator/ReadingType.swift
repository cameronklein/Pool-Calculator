//
//  ReadingType.swift
//  Pool Calculator
//
//  Created by Cameron Klein on 12/18/14.
//  Copyright (c) 2014 Cameron Klein. All rights reserved.
//

import Foundation

enum Chemical : Int {
  case FreeChlorine, CombinedChlorine, TotalChlorine, pH, TotalAlk, Hardness
}

struct ReadingType {
  
  var name : String
  var minValue : Double
  var maxValue: Double
  
  static func getType(type: Chemical) -> ReadingType{
    switch type{
    case .FreeChlorine:
      return ReadingType(name: "Free Chlorine", minValue: 0, maxValue: 10)
    case .CombinedChlorine:
      return ReadingType(name: "Combined Chlorine", minValue: 0, maxValue: 10)
    case .TotalChlorine:
      return ReadingType(name: "Total Chlorine", minValue: 0, maxValue: 10)
    case .pH:
      return ReadingType(name: "pH", minValue: 6.0, maxValue: 9.0)
    case .TotalAlk:
      return ReadingType(name: "Total Alkalinity", minValue: 0, maxValue: 500)
    case .Hardness:
      return ReadingType(name: "Calcium Hardness", minValue: 0, maxValue: 500)
    }
  }
  
}

