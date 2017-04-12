//: Playground - noun: a place where people can play

import UIKit

var str = "Hello, playground"

// Write some awesome Swift code, or import libraries like "Foundation",
// "Dispatch", or "Glibc"

print("Hello world!")


//1. Объявить протокол Food, который будет иметь проперти name (только чтение) и метод taste(), который будет выводить текст со вкусовыми ощущениями
//

protocol Food: CustomStringConvertible {
    var name : String {get}
    func taste()
}

//2. Все продукты разных типов, которые вы принесли из супермаркета, находятся в сумке (массив) и все, как ни странно, реализуют протокол Food. Вам нужно пройтись по сумке, назвать предмет и откусить кусочек. Можете отсортировать продукты до имени. Используйте для этого отдельную функцию, которая принимает массив продуктов
//

extension CustomStringConvertible where Self: Food {
    var description: String {
        return String(name)
    }
}

protocol Storable /*: Food*/ {
    var expired: Bool{get}
    var daysToExpire: Int{get}
}


class Apple : Food {
    var name = "Apple"
    
    func taste(){
        print("Apple is Apple")
    }
}


class Cheese : Food, Storable {
    var name = "Cheese"
    
    var expired = false
    var daysToExpire = 4
    
    func taste(){
        print("Bread is a Head")
    }
}

class Egg : Food, Storable {
    var name : String {
        get{
            return "\(type(of: self))"
        }
    }
    
    var expired = false
    var daysToExpire = 4
    
    func taste(){
        print("Fresh Eggs")
    }
}

class Bread : Food, Storable {
    var name = "Bread"
    
    var expired = true
    var daysToExpire = 0
    
    func taste(){
        print("Bread is a Head")
    }
}

var package: [Food] = [Apple(), Egg(), Bread(), Cheese()]

for i in package {
    print("This is \(i.name)")
    i.taste()
}

print(package)

func sortFood(food: [Food]) -> [Food]{
    return food.sorted{ $0.name.characters.first ?? Character("z") < $1.name.characters.first ?? Character("z")}
}

print(sortFood(food: package))


//3. Некоторые продукты могут испортиться, если их не положить в холодильник. Создайте новый протокол Storable, он наследуется от протокола Food и содержит еще булевую проперти - expired. У некоторых продуктов замените Food на Storable. Теперь пройдитесь по всем продуктам и, если продукт надо хранить в холодильнике, то перенесите его туда, но только если продукт не испорчен уже, иначе просто избавьтесь от него. Используйте функцию для вывода продуктов для вывода содержимого холодильника
//

package = package.filter{$0 as? Storable == nil || $0 as? Storable != nil && ($0 as! Storable).expired == false}
print("In package without Expired \(package)")

var fridge : [Storable] = []
fridge = package.filter{$0 as? Storable != nil && ($0 as! Storable).expired == false} as! [Storable]

print("In fridge now \(fridge)")


//4. Добавьте проперти daysToExpire в протокол Storable. Отсортируйте массив продуктов в холодильнике. Сначала пусть идут те, кто быстрее портятся. Если срок совпадает, то сортируйте по имени.
//

/*
 fridge = fridge.sorted{
 if $0.daysToExpire == $1.daysToExpire {
 $0.name.characters.first ?? Character("z") < $1.name.characters.first ?? Character("z")
 } else {
 $0.daysToExpire < $1.daysToExpire}
 } */ // — not worked

fridge = sortFood(food: fridge as! [Food]) as! [Storable] // после 5 го задания это не работает )
fridge = fridge.sorted{$0.daysToExpire < $1.daysToExpire}


print("Fridge with Sorted by daysToExpire \(fridge)")

//5. Не все, что мы кладем в холодильник, является едой. Поэтому сделайте так, чтобы Storable не наследовался от Food. Мы по прежнему приносим еду домой, но некоторые продукты реализуют теперь 2 протокола. Холодильник принимает только те продукты, которые еще и Storable. функция сортировки должна по прежнему работать.

/*
 struct SmartFridge{
 fridge: [Storable] = []
 subscript(i: Int) {
 get(){}
 set(){}
 }
 }*/


class Medicine : Storable {
    var name = "Medicine"
    
    var expired = false
    var daysToExpire = 365
    
    func taste(){
        print("Foo")
    }
}

var tablet = Medicine()


var smartFridge: [Storable] = [] {
    didSet {
        if !(smartFridge is [Food]) {
            smartFridge = oldValue
        }
    }
}

smartFridge += [tablet]

print(smartFridge.count > 0)





