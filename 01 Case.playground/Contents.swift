import Foundation

// 1. Создать тюпл с тремя параметрами:
//
// - максимальное количество отжиманий
// - максимальное количество подтягиваний
// - максимальное количество приседаний
//
// Заполните его своими достижениями :)
//
// Распечатайте его через print()
//
// 2. Также сделайте три отдельных вывода в консоль для каждого параметра
// При том одни значения доставайте по индексу, а другие по параметру
//
// 3. Создайте такой же тюпл для другого человека (супруги или друга)
// с такими же параметрами, но с другими значениями
//
// 4. Создайте третий тюпл с теми же параметрами, но значения это разница
// между соответствующими значениями первого и второго тюплов

import UIKit


var bodybuilding : (pushUp: Int, pullUp: Int, sitUps: Int) = (0,0,0)
bodybuilding = (pushUp: 80, pullUp: 30, sitUps: 300)

print(bodybuilding)

print(bodybuilding.0)
print(bodybuilding.pullUp)
print(bodybuilding.2)

//typealias Type = type(of: bodybuilding)

var bodybuilding2 = (pushUp: 10, pullUp: 0, sitUps: 100)
print(bodybuilding2)

var bodybuilding3 = (pushUp: 0, pullUp: 0, sitUps: 0)


//for i in 0 ... 2 {  // так не работает = (
//    bodybuilding3.i = bodybuilding.i - bodybuilding2.i
//}

bodybuilding3.0 = bodybuilding.0 - bodybuilding2.0
bodybuilding3.1 = bodybuilding.1 - bodybuilding2.1
bodybuilding3.2 = bodybuilding.2 - bodybuilding2.2

print(bodybuilding3)
