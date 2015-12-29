//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by Patrick Mumme on 5/15/15.
//  Copyright (c) 2015 Patrick Mumme. All rights reserved.
//

import Foundation

class CalculatorBrain {
    private enum Op: CustomStringConvertible {
        case Operand(Double)
        case Constant(String, Double)
        case UnaryOperation(String, Double -> Double)
        case BinaryOperation(String, (Double, Double) -> Double)
        
        var description: String
            {
            get {
                switch self {
                case .Operand(let operand):
                    return "\(operand)"
                case .Constant(let symbol, _):
                    return symbol
                case .UnaryOperation(let operation, _):
                    return operation
                case .BinaryOperation(let operation, _):
                    return operation
                }
            }
        }
    }
    
    private var opStack = [Op]()
    private var knownOps = [String:Op]()
    
    init() {
        func learnOp(op: Op) {
            knownOps[op.description] = op
        }
        learnOp(Op.BinaryOperation("×", *))
        learnOp(Op.BinaryOperation("+", +))
        learnOp(Op.BinaryOperation("−", {$1 - $0}))
        learnOp(Op.BinaryOperation("÷", {$1 / $0}))
        learnOp(Op.UnaryOperation("√", sqrt))
        learnOp(Op.UnaryOperation("±", {-1 * $0}))
        learnOp(Op.Constant("π", M_PI))
    }
    
    func pushOperand(operand: Double) -> Double? {
        opStack.append(Op.Operand(operand))
        return evaluate()
    }
    
    func performOperation(operation: String) -> Double? {
        if let op = knownOps[operation] {
            opStack.append(op)
        }
        return evaluate()
    }
    
    func evaluate() -> Double? {
        let (result, remainder) = evaluate(opStack)
        print("\(opStack) = \(result) with \(remainder) left over")
        return result
    }
    
    private func evaluate(ops: [Op]) -> (result: Double?, remainingOps: [Op]) {
        if !ops.isEmpty {
            var remainingOps = ops
            let op = remainingOps.removeLast()
            switch op {
            case .Operand(let operand):
                return (operand, remainingOps)
            case .Constant(_, let constantValue):
                return (constantValue, remainingOps)
            case .UnaryOperation(_, let operation):
                let op1Evaluation = evaluate(remainingOps)
                if let operand1 = op1Evaluation.result {
                    return (operation(operand1), op1Evaluation.remainingOps)
                }
            case .BinaryOperation(_, let operation):
                let op1Evaluation = evaluate(remainingOps)
                if let operand1 = op1Evaluation.result {
                    let op2Evaluation = evaluate(op1Evaluation.remainingOps)
                    if let operand2 = op2Evaluation.result {
                        return (operation(operand1, operand2), op2Evaluation.remainingOps)
                    }
                }
            }
        }
        return (nil, ops)
    }
    
    func calculateEquation() -> String {
        var (result, remainingOps) = evaluateStackEquation(opStack)
        var finalResult: String = result
        while (!remainingOps.isEmpty) {
            let (resultPiece, leftOverOps) = evaluateStackEquation(remainingOps)
            finalResult = "\(resultPiece) \(finalResult)"
            remainingOps = leftOverOps
        }

        return finalResult
    }
    
    private func evaluateStackEquation(ops: [Op]) -> (result: String, remainingOps: [Op]) {
        if !ops.isEmpty {
            var remainingOps = ops
            let op = remainingOps.removeLast()
            switch op {
            case .Operand(let operand):
                return ("\(operand)", remainingOps)
            case .Constant(let symbol, _):
                return ("\(symbol)", remainingOps)
            case .UnaryOperation(let symbol, _):
                let op1Evalutation = evaluateStackEquation(remainingOps)
                let operand1 = op1Evalutation.result
                return ("\(symbol)\(operand1)", op1Evalutation.remainingOps)
            case .BinaryOperation(let symbol, _):
                let op1Evaluation = evaluateStackEquation(remainingOps)
                let operand1 = op1Evaluation.result
                let op2Evaluation = evaluateStackEquation(op1Evaluation.remainingOps)
                let operand2 = op2Evaluation.result
                return ("(\(operand2) \(symbol) \(operand1))", op2Evaluation.remainingOps)
            }
        }
        return ("", ops)
    }
    
    func clearBrain() {
        opStack = [Op]()
    }
}