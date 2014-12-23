//
//  ChemicalCalculator.swift
//  Pool Calculator
//
//  Created by Cameron Klein on 12/21/14.
//  Copyright (c) 2014 Cameron Klein. All rights reserved.
//

import Foundation

class ChemicalCalculator {
  
  var poolGallons : Double
  //Constants are amount in oz required to treat 10,000 gallons and raise by 1ppm
  
  //Raise chlorine
  let chlorineGas : Double = 1.3
  let calciumHypochlorite : Double = 2
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
  
  //Lower TA
  let muriaticAcid = 2.6
  let sodiumBisulfate = 3.36
  
  // Increase Calcium Hardness
  let calciumChloride100 = 1.44
  let calciumChloride77 = 1.92
  
  // Increase Stabilizer 
  let cynuricAcid = 1.3
  
  // Lower chlorine
  let sodiumThio = 2.6
  
  init(gallons:Int) {
    self.poolGallons = Double(gallons)
  }
  
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
  
  func raiseChlorineBy(amount : Double) -> String {
    
    let gallonsMultiplier = poolGallons / 10000
    let result = amount * calciumHypochlorite * gallonsMultiplier
    let formattedResult = String(format: "%.0f", result)
    
    return formattedResult + " ounces of\nCalcium Hypochlorite"
    
  }
  
  func lowerChlorineBy(amount : Double) -> String {
    
    let gallonsMultiplier = poolGallons / 10000
    let result = amount * sodiumThio * gallonsMultiplier
    let formattedResult = String(format: "%.0f", result)
    
    return formattedResult + " ounces of\nSodium Thiosulfate"
    
  }
  
  func raisePHBy(amount : Double) -> String {
    
    let gallonsMultiplier = poolGallons / 10000
    let result = amount * sodaAshForPH * gallonsMultiplier
    let formattedResult = String(format: "%.0f", result)
    
    return formattedResult + " ounces of\nSoda Ash"
    
  }
  
  func lowerPHBy(amount : Double) -> String {
    
    let gallonsMultiplier = poolGallons / 10000
    let result = amount * sodiumThio * gallonsMultiplier
    let formattedResult = String(format: "%.0f", result)
    
    return formattedResult + " ounces of\nSodium Thiosulfate"
    
  }
  
}