//
//  File.swift
//  calculCool
//
//  Created by Apple on 27/04/2017.
//  Copyright © 2017 Apple. All rights reserved.
//

import Foundation

public extension Double {
    var smartValue: Double {
        //if abs(1 - self) < 1e-10 {return 1}
        return abs(self) < 1e-10 ? 0.0 : self
    }
}


protocol canShowMyMind {
    func result(_ result: Double)
}

struct Mind {
    private enum Op  {
        case binary((Double, Double) -> Double)
        case unary((Double) -> Double)
        case constant(Double)
        case equal
    }
    
    private var tempOperation: Op?
    
    private var insertOperation: Op?
    {
        didSet{
            guard insertOperation != nil else {return}
            
            switch insertOperation! {
            case .binary:
                guard value != nil else {return}
                tempOperation = insertOperation
                tempValue = value
                point = false
            case .unary(let f):
                guard value != nil else {return}
                result = f(value!)
            case .equal:
                guard tempOperation != nil, value != nil, tempValue != nil else {return}
                switch tempOperation! {
                case .binary(let f):
                    result = f(tempValue!, value!)
                default: break
                }
                tempOperation = nil
                tempValue = nil
            case .constant(let const): value = const
                isEnteredValue = false
                //point = false
            }
        }
    }
    var nextPosition = 1.0
    
    private var point = false{
        didSet{
            nextPosition = point ? 1/10 : 1.0
        }
    }
    
    private var tempValue: Double?
    
    var delegate: canShowMyMind!
    
    var isEnteredValue = false
    
    var operation: String? {
        didSet{
            isEnteredValue = false
            guard let myOperation = operation else {return}
            
            switch myOperation {
            case "∞": insertOperation = Op.constant(Double.infinity)
            case "LN2": insertOperation = Op.constant(M_LN2)
            case "e": insertOperation = Op.constant(M_E)
            case "cos": insertOperation = Op.unary(cos)
            case "sin": insertOperation = Op.unary(sin)
            case "π": insertOperation = Op.constant(.pi)
            case "√": insertOperation = Op.unary(sqrt)
            case "+": insertOperation = Op.binary(+)
            case "-": insertOperation = Op.binary(-)
            case "×": insertOperation = Op.binary(*)
            case "/": insertOperation = Op.binary(/)
            case "=": insertOperation = Op.equal
            case "AC": value = 0
            case ".": point = true
                isEnteredValue = true
            default: break
            }
        }
    }
    var result : Double? {
        
        didSet{
            result = result?.smartValue
            delegate?.result(result!)
            value = result
            isEnteredValue = false
            insertOperation = nil
            tempValue = nil
            point = false
        }
    }
    
    var value: Double? = 0{
        didSet{
            value = value?.smartValue
            if isEnteredValue {
                if !point{
                    value = oldValue! * 10 + value!
                } else {
                    value = oldValue! + value! * nextPosition //oldValue!.truncatingRemainder(dividingBy: value!)
                    nextPosition = nextPosition / 10
                }
            } else {
                    value = value!
            }
            isEnteredValue = true
            delegate?.result(value!)
        }
    }
}
