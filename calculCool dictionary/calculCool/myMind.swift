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
    func resultDidChanged(_ result: String)
}

struct Mind {
    private enum Op  {
        case binary((Double, Double) -> Double),
        unary((Double) -> Double),
        constant(Double),
        equal
    }
    
    private var point = false
    
    private var accumulatorOperand: Double?

    private var accumulatorBinaryOperation: Op? {
        didSet{
            accumulatorOperand = currentOperandDouble
        }
    }
    
    weak var delegate: canShowMyMind!
    
    private var isEnteredValue = true
    
    private var ollOperations : [String : Op] = [
        "+": Op.binary(+),
        "-": Op.binary(-),
        "×": Op.binary(*),
        "/": Op.binary(/),
        "cos": Op.unary(cos),
        "sin": Op.unary(sin),
        "√": Op.unary(sqrt),
        "e": Op.constant(M_E),
        "π": Op.constant(.pi)
    ]
    
    mutating func operation(operation: String?) {
        
        if operation != "⬅︎" && operation != "." && operation != "+/-" {
            isEnteredValue = false
            point = false
        }
        
        guard let myOperation = operation else {return}
            
            switch myOperation {
            case "+/-": guard currentOperandDouble != 0 else {return}
                if currentOperandDouble > 0 {
                    displayOperand = "-" + displayOperand
                } else {
                     displayOperand.characters.removeFirst()
                }
            case "⬅︎": displayOperand.characters.removeLast() == "." ? point = false : ()
            case "=":  guard accumulatorBinaryOperation != nil,
                accumulatorOperand != nil else {return}
                switch accumulatorBinaryOperation! {
                case .binary(let f):
                    currentOperandDouble = f(accumulatorOperand!, currentOperandDouble)
                default: break
                }
                accumulatorOperand = nil
            case "C": currentOperandDouble = 0
            case "AC": currentOperandDouble = 0
                accumulatorBinaryOperation = nil
                accumulatorOperand = nil
            case ".": if isEnteredValue && point == false {
                    point = true
                    displayOperand = displayOperand + "."
                }
            default: guard ollOperations[myOperation] != nil else {return}
                switch ollOperations[myOperation]! {
                case .binary: accumulatorBinaryOperation = ollOperations[myOperation]
                case .unary(let f): currentOperandDouble = f(currentOperandDouble)
                case .constant(let c): currentOperandDouble = c
                default: break
                }
            }
    }
    
    func countDigisAfterComma(_ value: String) -> Int {
        let separatedByComma = value.characters.split(separator: ".")
        return separatedByComma.count > 1 ? separatedByComma.last?.count ?? 0 : 0
    }
    
    private var displayOperand: String = "0" {
        didSet{
            if point == false && countDigisAfterComma(displayOperand) == 1 && displayOperand.characters.last == "0" {
                displayOperand.characters.removeLast(2)
            }
            delegate.resultDidChanged(displayOperand)
        }
    }
    
    private var currentOperandDouble: Double {
        set{ displayOperand = String(newValue.smartValue) }
        get{ return Double(displayOperand)?.smartValue ?? 0 }
    }
    
    mutating func insertOperand(operand: String) {
        if !isEnteredValue || displayOperand == "0" {
            displayOperand = operand
        } else {
            displayOperand = displayOperand + operand
        }
        isEnteredValue = true
    }
}
