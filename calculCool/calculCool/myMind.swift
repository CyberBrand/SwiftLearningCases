//
//  File.swift
//  calculCool
//
//  Created by Apple on 27/04/2017.
//  Copyright © 2017 Apple. All rights reserved.
//

// 0. (!!!) комментарии в коде (!!!) либо код читается как английский язык (говорящие названия)
// 1. избавиться от багов
// 2. реализовать 2 публичных функции (для цифры и для операции)
// 3. реализовать свойство для отображения текущего значения (результат типа String), с учетом десятичной точки и суффиксных нулей
// 4. вынести перечень всех обрабатываемых операций в Dictionary<String, *YouType*>
// 5. должен быть аккумулятор для значения
// 6. должено быть optional значение для "запомненой" бинарной операции
// 7. на этом этапе вычисление только по операции equal (=)
// 8. в вью контроллере не пересоздавать майнд, никакой логики!!!! Даже очистка экрана 
// 9. backspace

import Foundation

public extension Double {
    var smartValue: Double {
        return abs(self) < 1e-10 ? 0.0 : self
    }
}

protocol canShowMyMind: class {
    func result(_ result: Double) // rename to resultDidChanged
    // accumulatorDidChanged(...)
}

struct Mind {
    private enum Op  {
        case binary((Double, Double) -> Double)
        case unary((Double) -> Double)
        case constant(Double)
        case equal
    }
    
    private var tempOperation: Op? // лишнее, избавиться
    
    var nextPosition = 1.0
    
    private var point = false { // бага с повторной точкой
        didSet{
            if oldValue != true {
                if isEnteredValue {
                    nextPosition = point ? 1 / 10 : 1.0
                }
            }
        }
    }
    
    private var tempValue: Double? // назвать accumulator
    
    weak var delegate: canShowMyMind!
    
    var isEnteredValue = false
    
    func insertOp(op: String) -> String? {
     return nil
    }
    
    mutating func operation(operation: String?) { // ты никогда не берешь это значение, почему не func?
        if operation != "." {
            isEnteredValue = false
            point = false
        }
        guard let myOperation = operation else {return}
        
         var insertOperation: Op?
        {
            didSet{ // лишнее, збавиться (pending*Binary*Operation)
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
                default: break
                }
            }
        }
            
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
            case ".": if isEnteredValue && point == false { point = true }
            default: break
            }
    }
    var result : Double? {
        
        didSet{
            result = result?.smartValue
            delegate?.result(result!)
            value = result
            isEnteredValue = false
            
            tempOperation = nil
            
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
