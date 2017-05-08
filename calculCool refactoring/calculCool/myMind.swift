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
    func getCurrentTitleScreen()-> String
}

struct Mind {
    private enum Op  {
        case binary((Double, Double) -> Double),
        unary((Double) -> Double),
        constant(Double),
        equal
    }
    
    private var point = false {
        didSet{
            point == true ? delegate?.resultDidChanged( String(Int(currentOperand!)) + ".") : ()
        }
    }
    
    private var accumulatorOperand: Double?

    private var accumulatorBinaryOperation: Op? {
        didSet{
            accumulatorOperand = currentOperand
        }
    }
    
    weak var delegate: canShowMyMind!
    
    private var isEnteredValue = true
    
    mutating func operation(operation: String?) {
        
        if operation != "⬅︎" && operation != "." {
            isEnteredValue = false
            point = false
        }
            
        guard let myOperation = operation else {return}
            
            switch myOperation {
            case "⬅︎":
                var correctScreen = delegate.getCurrentTitleScreen()
                correctScreen.characters.removeLast()
                currentOperand = Double(correctScreen) ?? 0
                countDigisAfterComma(correctScreen) == 0 ? point = false : ()
            case "LN2": currentOperand = M_LN2
            case "e": currentOperand = M_E
            case "π": currentOperand = .pi
            case "cos": currentOperand = cos(currentOperand!)
            case "sin": currentOperand = sin(currentOperand!)
            case "√": currentOperand = sqrt(currentOperand!)
            case "+": accumulatorBinaryOperation = Op.binary(+)
            case "-": accumulatorBinaryOperation = Op.binary(-)
            case "×": accumulatorBinaryOperation = Op.binary(*)
            case "/": accumulatorBinaryOperation = Op.binary(/)
            case "=":  guard accumulatorBinaryOperation != nil,
                currentOperand != nil,
                accumulatorOperand != nil else {return}
            switch accumulatorBinaryOperation! {
            case .binary(let f):
                currentOperand = f(accumulatorOperand!, currentOperand!)
            default: break
            }
            accumulatorBinaryOperation = nil
            accumulatorOperand = nil
                
            case "AC": currentOperand = 0
            case ".": if isEnteredValue && point == false { point = true }
            default: break
            }
    }
    let decimal = Character(NumberFormatter().decimalSeparator ?? ".")
    
    func countDigisAfterComma(_ value: String) -> Int {
        let separatedByComma = value.characters.split(separator: decimal)
        return separatedByComma.count > 1 ? separatedByComma.last?.count ?? 0 : 0
    }
    
    private var currentOperand: Double? = 0 {
        didSet{
            guard currentOperand != nil, currentOperand != Double.infinity else {return}
            currentOperand = currentOperand!.smartValue
            
            if currentOperand! == Double(Int(currentOperand!)) {
                delegate?.resultDidChanged(String(Int(currentOperand!)))
            } else {
                delegate?.resultDidChanged( String(currentOperand!))
            }
        }
    }
    
    mutating func insertOperand(operand: Double) {
        if isEnteredValue {
            if !point{
                currentOperand = (currentOperand ?? 0) * 10 + operand
            } else {
                if operand == 0 {
                    let tempString = delegate?.getCurrentTitleScreen() ?? ""
                       delegate?.resultDidChanged( tempString + "0")
                } else {
                    let divider = pow(10, (1 + Double(countDigisAfterComma(delegate.getCurrentTitleScreen()))))
                    print(divider)
                    currentOperand = currentOperand! + (operand / divider)
                }
            }
        } else {
            currentOperand = operand
        }
          isEnteredValue = true
    }
}
