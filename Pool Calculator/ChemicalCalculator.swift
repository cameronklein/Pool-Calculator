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
  
  init() {
    
  }
  
  var poolGallons : Double {
    return NSUserDefaults.standardUserDefaults().doubleForKey(kUserSettingsPoolVolumeInGallons)
  }
  //Constants are amount in oz required to treat 10,000 gallons and raise by 1ppm
  
  var macid : [String:Double]!
  
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
  let sodaAshForPH = 65.6
  
  // Lower pH
  let muriaticAcidForPH = 45.0
  
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
  
  func changePHBy(amount: Double, startingPH: Double) -> String {
    if amount > 0 {
      return raisePHBy(amount)
    } else if amount < 0 {
      return lowerPHBy(-amount, beginningPH: startingPH)
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
    
    if NSUserDefaults.standardUserDefaults().boolForKey("Sodium Hypochlorite 13%") {
      let result = amount * sodiumHypochlorite * gallonsMultiplier
      return formatResult(result, chemicalName: "13% Sodium Hypochlorite", measurementType: .Volume)
    } else if NSUserDefaults.standardUserDefaults().boolForKey("Calcium Hypochlorite 67%") {
      let result = amount * calciumHypochlorite * gallonsMultiplier
      return formatResult(result, chemicalName: "67% Sodium Hypochlorite", measurementType: .Volume)
    } else if NSUserDefaults.standardUserDefaults().boolForKey("Dichlor 56%") {
      let result = amount * dichlor56 * gallonsMultiplier
      return formatResult(result, chemicalName: "Dichlor 56%", measurementType: .Volume)
    } else if NSUserDefaults.standardUserDefaults().boolForKey("Dichlor 62%") {
      let result = amount * dichlor62 * gallonsMultiplier
      return formatResult(result, chemicalName: "Dichlor 62%", measurementType: .Volume)
    } else if NSUserDefaults.standardUserDefaults().boolForKey("Trichlor") {
      let result = amount * trichlor * gallonsMultiplier
      return formatResult(result, chemicalName: "Trichlor", measurementType: .Volume)
    } else {
      let result = amount * sodiumHypochlorite * gallonsMultiplier
      return formatResult(result, chemicalName: "13% Sodium Hypochlorite", measurementType: .Volume)
    }
    
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
  
  func lowerPHBy(amount : Double, beginningPH: Double) -> String {
    let gallonsMultiplier = poolGallons / 10000
    setupMacid()
    
    var tempPH = beginningPH
    var result = 0.0
    
    while tempPH > beginningPH - amount + 0.05 {
      let lookupValue = NSString(format: "%0.1f", tempPH)
      result += macid[lookupValue]!
      tempPH -= 0.1
    }
    
    return formatResult(result * 10, chemicalName: "Muriatic Acid", measurementType: .Volume)
    
    
    
    
//    if NSUserDefaults.standardUserDefaults().boolForKey("Muriatic Acid") {
//      let result = amount * muriaticAcidForPH * gallonsMultiplier
//      return formatResult(result, chemicalName: "Muriatic Acid", measurementType: .Volume)
//    } else if NSUserDefaults.standardUserDefaults().boolForKey("Dry Acid"){
//      let result = amount * muriaticAcidForPH * gallonsMultiplier
//      return formatResult(result, chemicalName: "Dry Acid", measurementType: .Volume)
//    } else {
//      let result = amount * muriaticAcidForPH * gallonsMultiplier
//      return formatResult(result, chemicalName: "Muriatic Acid", measurementType: .Volume)
//    }
  }
  
  func raiseAlkalinityBy(amount : Double) -> String {
    
    let gallonsMultiplier = poolGallons / 10000
    let result = amount * sodiumBiCarb * gallonsMultiplier
    return formatResult(result, chemicalName: "Sodium Bicarbonate", measurementType: .Weight)
    
  }
  
  func lowerAlkalinityBy(amount : Double) -> String {
    
    return "Adjust pH between 7.0 and 7.2, then aerate pool."
    
  }
  
  func raiseHardnessBy(amount : Double) -> String {
    
    let gallonsMultiplier = poolGallons / 10000
    
    if NSUserDefaults.standardUserDefaults().boolForKey("Calcium Chloride 100%") {
      let result = amount * calciumChloride100 * gallonsMultiplier
      return formatResult(result, chemicalName: "100% Calcium Chloride", measurementType: .Weight)
    } else if NSUserDefaults.standardUserDefaults().boolForKey("Calcium Chloride 77%"){
      let result = amount * muriaticAcidForPH * gallonsMultiplier
      return formatResult(result, chemicalName: "77% Calcium Chloride", measurementType: .Weight)
    } else {
      let result = amount * calciumChloride100 * gallonsMultiplier
      return formatResult(result, chemicalName: "100% Calcium Chloride", measurementType: .Weight)
    }
    
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
    switch measurementType {
    case .Volume:
      return formatResultForVolumeWithOunces(ounces, andChemical: chemicalName)
    case .Weight:
      return formatResultForWeightWithOunces(ounces, andChemical: chemicalName)
    }
  }
  
  func formatResultForVolumeWithOunces(ounces: Double, andChemical chemicalName: String) -> String {
    let units : VolumeUnit = VolumeUnit(rawValue: NSUserDefaults.standardUserDefaults().integerForKey(kUserSettingsVolumeUnits))!
    
    switch units {
      
    case .Gallons:
      
      if ounces < 128 {
        return String(format: "%.0f", ounces) + " oz of\n \(chemicalName)"
      } else {
        let gallons = ounces / 128
        if gallons < 10 {
          return String(format: "%.1f", gallons) + " gallons of\n \(chemicalName)"
        } else {
          return String(format: "%.0f", round(gallons)) + " gallons of\n \(chemicalName)"
        }
      }
      
    case .Liters:
      let liters = ounces / 33.814
      
      if liters < 20 {
        return String(format: "%.1f", liters) + " liters of\n \(chemicalName)"
      } else {
        return String(format: "%.0f", round(liters)) + " liters of\n \(chemicalName)"
      }
    }
    
  }
  
  func formatResultForWeightWithOunces(ounces: Double, andChemical chemicalName: String) -> String {
    let units : WeightUnit = WeightUnit(rawValue: NSUserDefaults.standardUserDefaults().integerForKey(kUserSettingsWeightUnits))!
    
    switch units {
      
    case .Pounds:
      
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
      
    case .Kilograms:
      let grams = ounces * 28.3495231
      
      if grams < 500 {
        return String(format: "%.0f", grams) + " g of\n \(chemicalName)"
      } else {
        return String(format: "%.1f", grams / 1000) + " kg of\n \(chemicalName)"
      }
    }
    
  }
  
  func setupMacid() {
    
    macid = [String:Double]()
    macid["6.1"] = 32.1
    macid["6.2"] = 29.0
    macid["6.3"] = 26.0
    macid["6.4"] = 23.2
    macid["6.5"] = 20.6
    macid["6.6"] = 18.2
    macid["6.7"] = 16.0
    macid["6.8"] = 14.0
    macid["6.9"] = 12.2
    macid["7.0"] = 10.5
    macid["7.1"] = 9.0
    macid["7.2"] = 7.6
    macid["7.3"] = 6.5
    macid["7.4"] = 5.4
    macid["7.5"] = 4.6
    macid["7.6"] = 3.8
    macid["7.7"] = 3.2
    macid["7.8"] = 2.7
    macid["7.9"] = 2.4
    macid["8.0"] = 2.2
    macid["8.1"] = 2.11
    macid["8.2"] = 2.13
    macid["8.3"] = 2.26
    macid["8.4"] = 2.49
    macid["8.5"] = 2.83
    macid["8.6"] = 3.26
    macid["8.7"] = 3.78
    macid["8.8"] = 4.39
    macid["8.9"] = 5.07
    macid["9.0"] = 5.84

  }
  
  
  
  
  
}