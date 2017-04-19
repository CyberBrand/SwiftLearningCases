//: Playground - noun: a place where people can play

import UIKit

var str = "Hello, playground"

// ДНК
// Нуклеотиды: Аденин = A, Гуанин = G, Тимин = T, Цитозин = C
// 1. Сделайте описание элемента (нуклеотид) ДНК с 4 возможными типами нуклеотидов, создайте пару примеров

enum Nucleotide : Int {
    case A = 0
    case G
    case T
    case C
}

let n1: Nucleotide = .A
let n2 = Nucleotide.C

// 2. Сделайте экстеншн для нуклеотида, который поможет вам потом с функцией print(...), выведите результат в консоль из п. 1

extension Nucleotide {
    func myName() -> String {
        switch self {
        case .A: return "Adein"
        case .G: return "Guanin"
        case .T: return "Timin"
        case .C: return "Citozin"
        }
    }
}

print(n1.myName())
n2.myName()

// 3. Сделайте описание ДНК, который содержит набор нуклеотидов, создайте пару примеров

struct DNK {
    var nucMass : [Nucleotide] = []
    init(nuc: [Nucleotide]) {
        nucMass = nuc
    }
}

let dnk1 = DNK(nuc: [n1, n2, Nucleotide.T, Nucleotide.G])
let dnk2 = DNK(nuc: [Nucleotide.T, Nucleotide.G, n2, Nucleotide.G])

//typealias DNK = [Nucleotide] //Array<Nucleotide> //[Nucleotide]
//extension Array where Array: DNK {
//func printMe(){
    //self.map{value in if let valueNuc = value as? Nucleotide { valueNuc.myName()}}
//} // tak ne rabotaet

// 4. Сделайте экстеншн для ДНК, который поможет вам потом с функцией print(...), выведите результат в консоль из п. 3

extension DNK {
    func printMe() -> [String]{
        return self.nucMass.map{ $0.myName()}
    }
}

dnk1.printMe()

// 5. Сделайте так, чтобы можно было создавать случайную цепочку ДНК определенной длины

func rnd(_ int: Int) -> Int{
    return Int(arc4random()) % int
}

extension DNK {
    init(count: Int) {
        guard count > 0 else {return}
        
        for _ in 1...count{
            nucMass.append(Nucleotide(rawValue: rnd(3))!)
        }
    }
}

var rndDNK = DNK(count: 5)

rndDNK.printMe()

// 6. Мутация (рождение ребенка)
// 6.1 Создайте 2 случайных ДНК, каждая из которых содержит 30 нуклеотидов (уловно - мама и папа), выведите их в консоль
let countDNK = 30

var mutherDNK = DNK(count: countDNK)
var fatherDNK = DNK(count: countDNK)
mutherDNK.printMe()
fatherDNK.printMe()

// 6.2 Правила мутации - сравниваем элементы в обоих днк попарно в массивах из п.6.1
// 6.3 С вероятностью 40% результат будет иметь ген или "папы" или "мамы" (итоговая вероятность - 80%)
// 6.4 Иначе, результат приобретает случайный ген (вероятность 20%)
// 6.5 Создайте функцию, принимающую две ДНК на входе и отдающую результирующую ДНК (после мутации) на выходе.
// 6.6 Выведите результат мутации (ребенка) в консоль
// 6.7 Организуйте проект так, чтобы длина цепочки ДНК, а так же все вероятности были отдельными константами

let chanceMother = 0...39
let chanceFather = 40...79
let chanceRandom = 80...99

func sex(muther: DNK, father: DNK) -> DNK{
    if muther.nucMass.count != father.nucMass.count {return DNK(count: 0) }
    var child = DNK(count: 0)
    
    for i in 0...muther.nucMass.count - 1{
        switch  rnd(100) {
        case chanceMother: child.nucMass.append(muther.nucMass[i])
        case chanceFather: child.nucMass.append(father.nucMass[i])
        case chanceRandom: child.nucMass.append(Nucleotide(rawValue: rnd(3))!)
        default : print("It's alien, go away!")
        }
    }
    return child
}

let superChild = sex(muther: mutherDNK, father: fatherDNK)

superChild.printMe()
superChild.nucMass.count

// 6.8 Проверьте, имеет ли ребенок гены, отличные от обоих родителей, и сколько их

//let differGenes = superChild.nucMass.filter{mutherDNK.nucMass.contains($0) == false && fatherDNK.nucMass.contains($0) == false}
//differGenes.count

func differGenes(muther: DNK, father: DNK, child: DNK) -> [Nucleotide]{
    if muther.nucMass.count != father.nucMass.count {return [] }
    var differGenes: [Nucleotide] = []
    
    for i in 0...muther.nucMass.count - 1{
        if child.nucMass[i] != muther.nucMass[i] && child.nucMass[i] != father.nucMass[i] {
            differGenes.append(child.nucMass[i])
        }
    }
    return differGenes
}

differGenes(muther: mutherDNK, father: fatherDNK, child: superChild).count



