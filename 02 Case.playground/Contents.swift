//: Playground - noun: a place where people can play

import Foundation

// 1. Создайте пару функций с короткими именами, которые возвращают строку с символом или строкой. Например heart() возвращает сердце и т.п. Вызовите все эти функции внутри принта для вывода строки этих символов путем конкатенации

func hearth() -> Character {
    return "❤️"
}

// 2. Шахматные клетки.
// a) Реализовать функцию, которая принимает строку с именем клетки (например, "B5") и возвращает строку “белая” или “черная”. Строку потом распечатайте в консоль
// b) Реализовать функцию, которая принимает букву и целое значение (координаты клетки) и возвращает строку “белая” или “черная”. Строку потом распечатайте в консоль

func chess1(cell: String) -> String {
    // ...
}

func chess2(column: Character, row: Int) -> String {
    // ...
}

// 3. Создайте функцию, которая принимает массив, а возвращает массив в обратном порядке
// Создайте еще одну, которая принимает последовательность (Range) и возвращает массив элементов последовательности в обратном порядке
// Чтобы не дублировать код, сделайте так, чтобы функция с последовательностью вызывала первую

func f3(source: [Int]) -> [Int] {
    // ...
}

// 4. Разберитесь с inout самостоятельно и выполните задание номер 3 так, чтобы функция не возвращала перевернутый массив, но меняла элементы в существующем. Что будет если убрать inout?

// 5. Создайте функцию, которая принимает строку, убирает из нее все знаки препинания, делает все гласные большими буквами, согласные маленькими, а цифры меняет на соответствующие слова (9 -> nine и тд)

func f5(source: String) -> String {
    // ...
}