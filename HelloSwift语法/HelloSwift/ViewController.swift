//
//  ViewController.swift
//  HelloSwift
//
//  Created by vvlong on 2017/2/12.
//  Copyright © 2017年 vvlong. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        /*
        let number1 = 10
        let number2 = 20
        let four : Float = 4
        let apple = 6
        
        let label = "The Width is\(apple)"
        let width = 94
        let labelWidth = label + String(width)
        
        print(number1,number2,four,labelWidth)
 */
        var books = ["Objective-C","Swift","DesignThinking"]
        books[1] = "Swift 3.1"
        var Mapper = [
            "1":"value1",
            "2":"value2",
        ]
        Mapper["1"] = "value11111"
        
        let emptyArray = [String]()
//        print(books,Mapper,emptyArray)
        
        
        
        
        let individualScores = [75, 43, 103, 87, 12] //3 1 3 3 1   = 11
        var teamScore = 0
        for score in individualScores {
            if score > 50 {
                teamScore += 3
            } else {
                teamScore += 1
            }
        }
//        print(teamScore)
        
        
        /*
        var optionalString: String? = "Hello"
        print(optionalString == nil)
        print(optionalString)
        
        var optionalName: String? = nil
        var greeting = "Hello!"
        if let name = optionalName {
            greeting = "Hello,\(name)"
            print(greeting)
        } else {
            greeting = "There's not nil"
            print(greeting)
        }
        print(optionalName)
 
        
        let nickName:String? = nil
        let fullName:String = "vvlong"
        let greeting = "hi\(nickName ?? fullName)"
        print(greeting)
 
        let vegetable = "red pepper"
        switch vegetable {
        case "celery":
            print("ccc")
        case let x where x.hasSuffix("pepper") :
            print("Is it a spicy\(x)?")
        default:
            print("default")
        }
 
        let interestingNumbers = [
            "1":[2,3,5,7,11,13],
            "2":[1,1,2,3,5,8],
            "3":[1,4,9,16,25]
        ]
        var largest = 0
        var largestkind = "No."
        for (kind,numbers) in interestingNumbers {
            for number in numbers {
                if number > largest {
                    largest = number
                    largestkind = kind
                }
            }
        }
        print("Largest kind is ",largestkind,":",largest)
 
        
//        循环
        var n = 2
        while n < 100 {
            n = n * 2
        }
        print(n)
        
        var m = 2
        repeat {
            m = m * 2
        } while m < 100
        print(m)
        
        var total = 0
//        ..< 表示范围 ... 表示范围且包括上界
        for i in 0..<4 {
            total += i
        }
        print(total)
 
        print(greet(name: "vvlong", day: "Thursday"))
        
        let statistics = calculateStatistics(scores: [5,3,100,3,9])
        print(statistics.sum)
        print(statistics.2)
        
        print(sumOf(numbers:0))
        print(sumOf(numbers: 42,597,12))
 
        
        print(returnFifteen())
        var increment = makeIncrementer()
        print(increment)
        print(increment(7))
         */

        ///    函数作为参数传入另一个函数   闭包“
        ///Functions are actually a special case of closures: blocks of code that can be called later 可以回调
        ///condition: (Int) -> Bool传入一个int判断后返回一个布尔值
        func hasAnyMatches(list: [Int], condition: (Int) -> Bool) -> Bool {
            for item in list {
                if condition(item) {
                    return true
                }
            }
            return false
        }
        func lessThanTen(number: Int) -> Bool {
            return number < 10
        }

        
//        注意 嵌套函数直接返回的时候 函数要在内部声明 闭包  在函数的定义中 参数(_  ) 可以不用写参数名）
        let numbers = [20,19,7,12]
        print(hasAnyMatches(list: numbers, condition: lessThanTen))
 
        
        ///无名的闭包用({})   in分离声明和返回类型
        print(numbers.map({
            (number: Int) -> Int in
            let result = 3 * number
            return result
        }))
        
        let mappedNumbers = numbers.map({number in 3 * number})
        print(mappedNumbers)
        
        
        
        ///EXPERIMENT   Rewrite the closure to return zero for all odd numbers.
        print(numbers.map({
            (number: Int) -> Int in
            guard number % 2 == 0 else {
                return 0
            }
            return number
        }))
        /// 可以简化的闭包   吓死我了 orz..
        let sortedNumbers = numbers.sorted { $0 > $1 }
        print("sort:\(sortedNumbers)")
        
        
        let testArray = ["test1","test1234","","test56"]
        let anotherArray = testArray.map { (string:String) -> Int? in
            
            let length = string.characters.count
            
            guard length > 0 else {
                return nil
            }
            
            return string.characters.count
        }
        
        print(anotherArray) //[Optional(5), Optional(8), nil, Optional(6)]
        
        
        
        let nickName: String? = nil
        let fullName: String = "vvlong"
//        当optional变量为nil 则??会填充另一个值
        let informalGreeting = "Hi \(nickName ?? fullName)"
        print(informalGreeting)
        
        print(greet("vvlong",on:"FriDay"))
        
        let increment = makeIncrementer()
        print(increment)
        print(increment(7))
        
    
        ///压缩一波图片
        /*
        var origin: UIImage
        origin = UIImage(named: "IMG_4199.JPG")!
        let data:Data! = UIImageJPEGRepresentation(origin, 0.1)
        var newImage = UIImage(data: data)
        
        func imageSave(image:UIImage,didFinishSavingWithError error:NSError?,contextInfo:AnyObject) {
            if error != nil {
                print("error!")
                return
            }
        }
        */
        
        /*
        let shape = Shape()
        NSLog("\(shape)", "")
        print(shape)
        shape.numberOfSides = 7
        print(shape.simpleDescription())
        let n = 8
        print(shape.speak(n))
        
        let shapeCp = Shape.init()
        print(shapeCp)*/
        print(NameShape.init(name: "Hello"))
        
        
    }   ///viewDidLoad method
    ///object & Class
    class Shape {
        var numberOfSides = 0
        func simpleDescription() -> String {
            return "A shape with \(numberOfSides) sides."
        }
        func speak(_ word: Int) -> String {
            return "I'm speaking! \(word)"
        }
    }
    
    class NameShape {
        var numberOfSides: Int = 0
        var name: String
        init(name: String) {
            self.name = name
        }
        
        func simpleDescription() -> String {
            return "\(self.name) shape with \(numberOfSides)sides "
        }
    }

    
//    函数嵌套，非常值得注意的是，->的位置 还有 函数参数必须有()套住的 这样可以标识出嵌套函数的参数
//    函数作另一函数返回值
    func makeIncrementer() -> ((Int) -> Int) {
        func addOne(number:Int) -> Int {
            return 1 + number
        }
        return addOne
    }
    //    函数嵌套
    func returnFifteen() -> Int {
        var y = 10
        func add() {
            y += 5
        }
        add()
        return y
    }
    
    
    func sumOf(numbers: Int...) -> Int {
        var sum = 0
        for number in numbers {
            sum += number
        }
        return sum
    }
    
    func average(numbers: Int...) -> Int {
        var ave: Int = 0
        var sum: Int = 0
        var count: Int = 0
        for number in numbers {
            sum += number
            count += 1
        }
        ave = sum/count
        return ave
    }
    
    func square(_ a:Float) -> Float {
        return a * a
    }
    func cube(_ a:Float) -> Float {
        return a * a * a
    }
    func averageSumOfSquares(_ a:Float,_ b:Float) -> Float {
        return (square(a) + square(b)) / 2.0
    }
    func averageSumOfCubes(_ a:Float,_ b:Float) -> Float {
        return (cube(a) + cube(b)) / 2.0
    }
    
    
    
    func averageOfFunction(a:Float,b:Float,f:((Float) -> Float)) -> Float {
        return (f(a) + f(b)) / 2
    }
//    averageOfFunction(3, 4, square)
//    averageOfFunction(3, 4, cube)
    
    
    //    函数返回的是tuple type 相当于结构体
    func calculateStatistics(scores: [Int]) -> (min: Int, max: Int, sum: Int) {
        var min = scores[0]
        var max = scores[0]
        var sum = 0
        
        for score in scores {
            if score > max {
                max = score
            } else if score < min {
                min = score
            }
            
            sum += score
        }
        return (min, max, sum)
    }
        
    
    
    
    func greet(_ name: String, on day: String) -> String {
        return "Hello \(name), today is \(day)."
    }
    
    

    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

