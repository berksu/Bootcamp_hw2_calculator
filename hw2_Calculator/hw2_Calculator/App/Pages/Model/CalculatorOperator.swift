//
//  CalculatorOperator.swift
//  VaryForTraits
//
//  Created by Berksu Kısmet on 2.10.2022.
//

import Foundation

struct CalculatorOperator{
    
    private(set) var calculation: Double?
    
    // enumarate all of the operations
    enum Operations{
        case constantNumbers(Double)
        case unaryOperations((Double) -> Double)
        case binaryOperations((Double, Double) -> (Double))
        case equals
    }
    
    // If we want to add newer operations, we just need to add one more line in that space
    private let operations:[String: Operations] = [
        "π": .constantNumbers(3.14),
        "e": .constantNumbers(M_E),
        "cos": .unaryOperations({cos($0)}),
        "sin": .unaryOperations({sin($0)}),
        "tan": .unaryOperations({tan($0)}),
        "log_e": .unaryOperations({log($0)}),
        "log_10": .unaryOperations({log10($0)}),
        "±": .unaryOperations({-$0}),
        "+": .binaryOperations({$0 + $1}),
        "-": .binaryOperations({$0 - $1}),
        "x": .binaryOperations({$0 * $1}),
        "÷": .binaryOperations({$0 / $1}),
        "=": .equals
    ]
    
    mutating func setCalculation(_ number: Double){
        calculation = number
    }
    
    //this part do all of the operations
    mutating func doMathematicalOperations(_ chosenOperation: String){
        if let currentOperation = operations[chosenOperation]{
            switch currentOperation{
            case .constantNumbers(let number):
                calculation = number
            case .unaryOperations(let unaryOperationFunction):
                if calculation != nil{
                    calculation = unaryOperationFunction(calculation!)
                }
            case .binaryOperations(let binaryOperationFunction):
                if calculation != nil {
                    if binaryOpertaionLine != nil {
                        calculation = binaryOpertaionLine?.doOperation(secondNumber: calculation!)
                    }
                    binaryOpertaionLine = BinaryOperationLine(operation: binaryOperationFunction, firstNumber: calculation!)
                    calculation = nil
                }
            case .equals:
                if calculation != nil && binaryOpertaionLine != nil {
                    calculation = binaryOpertaionLine?.doOperation(secondNumber: calculation!)
                    binaryOpertaionLine = nil
                }
            }
        }
    }
    
    // get special constants values
    mutating func getContantValue(for value: String) -> String?{
        if let currentOperation = operations[value]{
            switch currentOperation{
            case .constantNumbers(let number):
                return "\(number)"
            default:
                return nil
            }
        }
        return nil
    }
    
    
    // because binary operations need two input, we need to store our state. With this struct, we hold the state.
    var binaryOpertaionLine: BinaryOperationLine?
    
    struct BinaryOperationLine{
        let operation: (Double, Double) -> Double
        let firstNumber: Double
        
        func doOperation(secondNumber: Double) -> Double{
            operation(firstNumber, secondNumber)
        }
    }

}

