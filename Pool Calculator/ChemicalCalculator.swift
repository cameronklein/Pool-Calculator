//
//  ChemicalCalculator.swift
//  Pool Calculator
//
//  Created by Cameron Klein on 12/21/14.
//  Copyright (c) 2014 Cameron Klein. All rights reserved.
//

import Foundation

enum CalculatorReadingType: Int {
  case Chlorine, PH, Alkalinity, Hardness, Stablizer
}

enum MeasurementType: Int {
  case Weight, Volume
}

class ChemicalCalculator {
  
  var poolGallons : Double {
    return NSUserDefaults.standardUserDefaults().doubleForKey(kUserSettingsPoolVolumeInGallons)
  }
  //Constants are amount in oz required to treat 10,000 gallons and raise by 1ppm
  
  //Raise chlorine
  let chlorineGas : Double = 1.3
  let calciumHypochlorite : Double = 2.0
  let sodiumHypochlorite = 10.7
  let lithiumHypochlorite = 3.8
  let dichlor62 = 2.1
  let dichlor56 = 2.4
  let trichlor = 1.5
  
  //Raise TA
  let sodaAsh = 1.4
  let sodiumBiCarb = 2.24
  let sodiumSesquicarbonate = 2.0
  
  //Raise pH
  let sodaAshForPH = 6.56
  
  // Lower pH
  let muriaticAcidForPH = 3.9
  
  //Lower TA
  let muriaticAcidForTA = 2.6
  let sodiumBisulfate = 3.36
  
  // Increase Calcium Hardness
  let calciumChloride100 = 1.44
  let calciumChloride77 = 1.92
  
  // Increase Stabilizer 
  let cynuricAcid = 1.3
  
  // Lower chlorine
  let sodiumThio = 2.6
  
  
  
  func changeChlorineBy(amount: Double) -> String {
    if amount > 0 {
      return raiseChlorineBy(amount)
    } else if amount < 0 {
      return lowerChlorineBy(-amount)
    } else {
      return "Nothing"
    }
  }
  
  func changePHBy(amount: Double) -> String {
    if amount > 0 {
      return raisePHBy(amount)
    } else if amount < 0 {
      return lowerPHBy(-amount)
    } else {
      return "Nothing"
    }
  }
  
  func changeAlkalinityBy(amount: Double) -> String {
    if amount > 0 {
      return raiseAlkalinityBy(amount)
    } else if amount < 0 {
      return lowerAlkalinityBy(-amount)
    } else {
      return "Nothing"
    }
  }
  
  func changeHardnessBy(amount: Double) -> String {
    if amount > 0 {
      return raiseHardnessBy(amount)
    } else if amount < 0 {
      return lowerHardnessBy(-amount)
    } else {
      return "Nothing"
    }
  }
  
  func changeCynuricAcidBy(amount: Double) -> String {
    if amount > 0 {
      return raiseCynuricAcidBy(amount)
    } else if amount < 0 {
      return lowerCynuricAcidBy(-amount)
    } else {
      return "Nothing"
    }
    
  }
  
  func raiseChlorineBy(amount : Double) -> String {
    
    let gallonsMultiplier = poolGallons / 10000
    let result = amount * calciumHypochlorite * gallonsMultiplier
    return formatResult(result, chemicalName: "Calcium Hypochlorite", measurementType: .Volume)
    
  }
  
  func lowerChlorineBy(amount : Double) -> String {
    
    let gallonsMultiplier = poolGallons / 10000
    let result = amount * sodiumThio * gallonsMultiplier
    return formatResult(result, chemicalName: "Sodium Thiosulfate", measurementType: .Weight)
    
  }
  
  func raisePHBy(amount : Double) -> String {
    
    let gallonsMultiplier = poolGallons / 10000
    let result = amount * sodaAshForPH * gallonsMultiplier
    return formatResult(result, chemicalName: "Soda Ash", measurementType: .Weight)

  }
  
  func lowerPHBy(amount : Double) -> String {
    
    let gallonsMultiplier = poolGallons / 10000
    let result = amount * muriaticAcidForPH * gallonsMultiplier
    return formatResult(result, chemicalName: "Muriatic Acid", measurementType: .Volume)
    
  }
  
  func raiseAlkalinityBy(amount : Double) -> String {
    
    let gallonsMultiplier = poolGallons / 10000
    let result = amount * sodiumBiCarb * gallonsMultiplier
    return formatResult(result, chemicalName: "Sodium Bicarbonate", measurementType: .Weight)
    
  }
  
  func lowerAlkalinityBy(amount : Double) -> String {
    
    return "Adjust pH between 7.0 and 7.2, then aerate to increase pH while keeping total alkalinity down."
    
  }
  
  func raiseHardnessBy(amount : Double) -> String {
    
    let gallonsMultiplier = poolGallons 	/ 10000
    let result = amount * calciumChloride100 * gallonsMultiplier
    return formatResult(result, chemicalName: "Calcium Chloride", measurementType: .Weight)
    
  }
  
  func lowerHardnessBy(amount : Double) -> String {
    
    return "Partially replace pool water with softer water."
    
  }
  
  func raiseCynuricAcidBy(amount: Double) -> String {
    
    let gallonsMultiplier = poolGallons / 10000
    let result = amount * cynuricAcid * gallonsMultiplier
    return formatResult(result, chemicalName: "Stablizer", measurementType: .Weight)
    
  }
  
  func lowerCynuricAcidBy(amount: Double) -> String {
    
    return "Partially replace pool water with new water."
    
  }
  
  
  func formatResult(ounces : Double, chemicalName: String, measurementType: MeasurementType) -> String {
    let units : VolumeUnit = VolumeUnit(rawValue: NSUserDefaults.standardUserDefaults().integerForKey(kUserSettingsVolumeUnits))!
    
    switch units {

    case .Gallons:
      
      if ounces < 16 {
        return String(format: "%.0f", ounces) + " oz of\n \(chemicalName)"
      } else {
        let pounds = ounces / 16
        if pounds < 10 {
          return String(format: "%.1f", pounds) + " lbs of\n \(chemicalName)"
        } else {
          return String(format: "%.0f", round(pounds)) + " lbs of\n \(chemicalName)"
        }
      }
      
    case .Liters:
      let grams = ounces * 28.3495231
      
      if grams < 500 {
        return String(format: "%.0f", grams) + " g of\n \(chemicalName)"
      } else {
        return String(format: "%.1f", grams / 1000) + " kg of\n \(chemicalName)"
      }
    }
  }
}