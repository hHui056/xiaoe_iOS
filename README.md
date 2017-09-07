# Swift学习
[toc]
## 基本语法
- 对空格敏感,变量赋值时＝号后面不能直接加常量，需要添加空格否则会报错

- 常量----->定义后不可修改，类似java final
```
let teststring = "hello,wrold!"
```
- 变量----->定义后可修改

```
var teststring = "hello,wrold!"
```

- (强类型语言)支持类型推断
- 区分大小写
## Swift可选（Optionals）类型
- ？ Optional类型用于处理缺失值的情况。

```
var optionalInteger: Int?
var optionalInteger: Optional<Int>
```
以上两种情况是一致的。

- ！强制解析
当你确定可选类型确实包含值之后，你可以在可选的名字后面加一个感叹号（!）来获取值。这个感叹号表示"我知道这个可选有值，请使用它。"这被称为可选值的强制解析（forced unwrapping）。
- 自动解析
在创建可选变量时用！代替？，这样在使用时就不用再加一个！来获取值。
- 可选绑定
来判断可选类型是否包含值，如果包含就把值赋给一个临时常量或者变量
```
var myString:String?

myString = "Hello, Swift!"

if let yourString = myString {
   print("你的字符串值为 - \(yourString)")
}else{
   print("你的字符串没有值")
}
```
## 常量
常量一旦设定，运行时不允许再修改值
- 类型标注  声明定义的常量的类型

```
let constB:Float = 3.14159

print(constB)
```

- 字符串型字面量

转义字符 | 含义
---|---
 \0|空字符
 \000|	1到3位八进制数所代表的任意字符
 \xhh...|	1到2位十六进制所代表的任意字符
 
注：其余常用与java一致，如 \n----->换行

## Swift循环
### for...in循环
 用于遍历一个集合里面的所有元素

```
var someInts:[Int] = [10, 20, 30]

for index in someInts {
   print( "index 的值为 \(index)")
}
```
### repeat....while... 循环执行结束时判断条件是否符合

```
var index = 15

repeat{
    print( "index 的值为 \(index)")
    index = index + 1
}while index < 20
```
## 数组
### 创建数组

以下实例创建了一个类型为 Int ，数量为 3，初始值为 0 的空数组

```
var someInts = [Int](repeating: 0, count: 3)
```

### 访问数组


```
var someVar = someArray[index]
```
index的索引从0开始

### 修改数组

使用append()方法，或者＋＝符号来在数组末尾添加元素

```
someInts.append(20)
someInts.append(30)
someInts += [40]
```
通过索引可以直接修改数组对应元素的值

```
someInts[2] = 50
```
### 合并数组

使用 ＋ 来合并数组

```
var intsA = [Int](repeating: 2, count:2)
var intsB = [Int](repeating: 1, count:3)

var intsC = intsA + intsB
```
- 一些属性和方法

count------>计算数组的长度

isEmpty------>判断数组是否为空
## Swift字典
1.用来存储无序的相同类型数据的集合；

2.每个值（value）都关联唯一的键（key），键作为字典中的这个值数据的标识符；

### 创建字典

以下是创建一个空字典，键的类型为 Int，值的类型为 String 的简单语法：

```
var someDict = [Int: String]()
```
### 访问字典

根据字典的索引来访问数组的元素，语法如下：

```
var someVar = someDict[key]
```
### 移除 Key-Value 对

1.使用 removeValueForKey() 方法来移除字典 key-value 对。如果 key 存在该方法返回移除的值，如果不存在返回 nil ;

```
var removedValue = someDict.removeValue(forKey: 2)
```

2.也可以通过指定键的值为 nil 来移除 key-value（键-值）对;

```
someDict[2] = nil
```
### 遍历字典

1.可以使用 for-in 循环来遍历某个字典中的键值对

```
var someDict:[Int:String] = [1:"One", 2:"Two", 3:"Three"]

for (key, value) in someDict {
   print("字典 key \(key) -  字典 value \(value)")
}
```
2.也可以使用enumerate()方法来进行字典遍历，返回的是字典的索引及 (key, value) 对;

```
var someDict:[Int:String] = [1:"One", 2:"Two", 3:"Three"]

for (key, value) in someDict.enumerate() {
    print("字典 key \(key) -  字典 (key, value) 对 \(value)")
}
```
## 字典转换为数组


```
var someDict:[Int:String] = [1:"One", 2:"Two", 3:"Three"]

let dictKeys = [Int](someDict.keys)
let dictValues = [String](someDict.values)
```
## Count和isEmpty

count------>有多少个键值对
## Swift闭包
闭包(Closures)是自包含的功能代码块，可以在代码中使用或者用来作为参数传值。
以下为闭包语法：
```
{(parameters) -> return type in
   statements
}
```
## Swift枚举

定义如下

```
enum ConnectType {
    case CONNECTED
    case DISCONNECTED
    case CONNTING
}

var myconnectType = ConnectType.DISCONNECTED
myconnectType = .CONNECTED
switch myconnectType
{
case .CONNECTED:
    print("已连接")
case .DISCONNECTED:
    print("未连接")
case .CONNTING:
    print("链接中")
}
```
## Swift结构体

### 语法

我们通过关键字 struct 来定义结构体：

```
struct nameStruct { 
   Definition 1
   Definition 2
   ……
   Definition N
}
```
## Swift类
Swift 并不要求你为自定义类去创建独立的接口和实现文件。你所要做的是在一个单一文件中定义一个类，系统会自动生成面向其它代码的外部接口。

定义语法如下

```
Class classname {
   Definition 1
   Definition 2
   ……
   Definition N
}

let newclassname = classname()
```
## Swift属性
### 存储属性

一个存储属性就是存储在特定类或结构体的实例里的一个常量或变量

### 延迟存储属性

第一次被调用的时候才会计算其初始值的属性。如下
 
```
lazy var no = number() // `var` 关键字是必须的
```
延迟存储属性一般用于：

1.延迟对象的创建；

2.当属性的值依赖于其他未知类

### 计算属性

除存储属性外，类、结构体和枚举可以定义计算属性，计算属性不直接存储值，而是提供一个 getter 来获取值，一个可选的 setter 来间接设置其他属性或变量的值。

### 属性观察器

属性观察器监控和响应属性值的变化，==**每次属性被设置值的时候都会调用属性观察器**==，甚至新的值和现在的值相同的时候也不例外。

```
class Samplepgm {
    var counter: Int = 0{
        willSet(newTotal){
            print("计数器: \(newTotal)")
        }
        didSet{
            if counter > oldValue {
                print("新增数 \(counter - oldValue)")
            }
        }
    }
}
let NewCounter = Samplepgm()
NewCounter.counter = 100
NewCounter.counter = 800
```
## Swift下标脚本

下标脚本 可以定义在类（Class）、结构体（structure）和枚举（enumeration）这些目标中，可以认为是访问对象、集合或序列的快捷方式，不需要再调用实例的特定的赋值和访问方法。
举例来说，用下标脚本访问一个数组(Array)实例中的元素可以这样写 someArray[index] ，访问字典(Dictionary)实例中的元素可以这样写 someDictionary[key]。
对于同一个目标可以定义多个下标脚本，通过索引值类型的不同来进行重载，而且索引值的个数可以是多个。

```
struct test2 {
    var numbers = [1,2,4,2,3,4,5,234]
    
    var strings = ["hello","wrold","my","name","is","paul"]
    
    var mydic : [String:String] = ["key1":"hello","key2":"wrold"]
    subscript (index:Int) -> String {
        return strings[index]
    }
    
    subscript (mykey:String) -> String{
        return mydic[mykey]!
    }
}

var mytest2 = test2()
print(mytest2[5])
print(mytest2["key2"])
```
## Swift构造过程

Swift 构造函数使用 init() 方法。

## Swift析构过程


```
var count:Int = 0
class BaseClass {
    init() {
        count += 1
}
    deinit {
        count -= 1
    }
}
var myclass:BaseClass? = BaseClass()
print("count is \(count)")
myclass = nil

print("count is \(count)")
```
## Swift可选链
可选链（Optional Chaining）是一种可以请求和调用属性、方法和子脚本的过程，用于请求或调用的目标可能为nil。

可选链返回两个值：

1.如果目标有值，调用就会成功，返回该值

2.如果目标为nil，调用将返回nil

可选链 ？ | 可选链 ！
---|---
? 放置于可选值后来调用方法，属性，下标脚本| ! 放置于可选值后来调用方法，属性，下标脚本来强制展开值
当可选为 nil 输出比较友好的错误信息| 当可选为 nil 时强制展开执行错误

## Swift 自动引用计数（ARC）

Swift 使用自动引用计数（ARC）这一机制来跟踪和管理应用程序的内存
通常情况下我们不需要去手动释放内存，因为 ARC 会在类的实例不再被使用时，自动释放其占用的内存。
但在有些时候我们还是需要在代码中实现内存管理。

### **ARC功能**

当每次使用 init() 方法创建一个类的新的实例的时候，ARC 会分配一大块内存用来储存实例的信息。

内存中会包含实例的类型信息，以及这个实例所有相关属性的值。

当实例不再被使用时，ARC 释放实例所占用的内存，并让释放的内存能挪作他用。

为了确保使用中的实例不会被销毁，ARC 会跟踪和计算每一个实例正在被多少属性，常量和变量所引用。

实例赋值给属性、常量或变量，它们都会创建此实例的强引用，只要强引用还在，实例是不允许被销毁的。

### 类实例之间的循环强引用

这种情况发生在两个类实例互相保持对方的强引用，并让对方不被销毁。这就是所谓的循环强引用。

====解决实例之间的循环强引用====

对于生命周期中会变为nil的实例使用弱引用（====weak====）。相反的，对于初始化赋值后再也不会被赋值为nil的实例，使用无主引用（==unowned==）。

### 闭包引起的循环强引用

循环强引用还会发生在==当你将一个闭包赋值给类实例的某个属性，并且这个闭包体中又使用了实例（self）。这个闭包体中可能访问了实例的某个属性==，例如self.someProperty，或者闭包中调用了实例的某个方法，例如self.someMethod。这两种情况都导致了闭包 "捕获" self，从而产生了循环强引用。

==解决闭包引起的循环强引用==

在定义闭包时同时定义捕获列表作为闭包的一部分，通过这种方式可以解决闭包和类实例之间的循环强引用。


 
```
lazy var asHTML: () -> String = {
        [unowned self] in //此处使用无主引用
        if let text = self.text {
            return "<\(self.name)>\(text)</\(self.name)>"
        } else {
            return "<\(self.name) />"
        }
    }
```

## Swift类型转换

Swift 语言类型转换可以判断实例的类型。也可以用于检测实例类型是否属于其父类或者子类的实例。
Swift 中类型转换使用 is 和 as 操作符实现，is 用于检测值的类型，as 用于转换类型。
类型转换也可以用来检查一个类是否实现了某个协议

```
//类型转换
class Sbujects {
    var xueke : String
    init(xueke:String) {
        self.xueke = xueke
    }
    
}
class Wuli :Sbujects {
    var fangcheng :String
    init(xueke:String,fangcheng:String) {
        self.fangcheng = fangcheng
        super.init(xueke: xueke)
    }
}
class Shuxue :Sbujects {
    var fangcheng :String
    init(xueke:String,fangcheng:String) {
    self.fangcheng = fangcheng
        super.init(xueke: xueke)
    }
}

let subs : [Sbujects] = [Wuli(xueke: "物理1", fangcheng: "物理方程1"),Shuxue(xueke: "数学1", fangcheng: "数学方程1"),Wuli(xueke: "物理2", fangcheng: "物理方程2"),
  Wuli(xueke: "物理3", fangcheng: "物理方程3"),Wuli(xueke: "物理4", fangcheng: "物理方程4"),Shuxue(xueke: "数学2", fangcheng: "数学方程2")]
var shuxuecount = 0
var wulicount = 0
for subject in subs{
    if subject is Wuli {
        wulicount = wulicount + 1
    }else if subject is Shuxue{
        shuxuecount = shuxuecount + 1
    }
}
print("物理个数 \(wulicount)\n数学个数 \(shuxuecount)")
//向下转型
for subject in subs {
    if let wuliitem = subject as? Wuli {
       print("物理学科： \(wuliitem.xueke) 方程式： \(wuliitem.fangcheng)")
    }else if let shuxueitem = subject as? Shuxue{
        print("数学学科： \(shuxueitem.xueke) 方程式： \(shuxueitem.fangcheng)")
    }
}
```
## Swift扩展
扩展就是向一个已有的类、结构体或枚举类型添加新功能。
扩展可以对一个类型添加新的功能，但是不能重写已有的功能。
Swift 中的扩展可以：

- 添加计算型属性和计算型静态属性
- 定义实例方法和类型方法
- 提供新的构造器
- 定义下标
- 定义和使用新的嵌套类型
- 使一个已有类型符合某个协议


### 扩展计算属性


```
extension Int {
    var addTen:Int{return self+10}
}
let testint = 3.addTen
print("\(testint)")
```
### 扩展方法

```
extension Double {
    func testaddfunc(){
        print("扩展方法： \(self)")
    }
}

3.0.testaddfunc()
```

### 可变实例方法

通过扩展添加的实例方法也可以修改该实例本身。
结构体和枚举类型中修改self或其属性的方法必须将该实例方法标注为mutating，正如来自原始实现的修改方法一样。


```
extension Int {//可变实例方法
    mutating func squre(){
        self = self * self
    }
}
var myint = 2
print("之前的值 \(myint)")
myint.squre()
print("之后的值 \(myint)")
```
## Swift协议 

类似java接口，不同的是遵循协议还必须指定协议规定的常量，
==协议规定了用来实现某一特定功能所必需的方法和属性。==

### 对属性的规定
协议用于指定特定的实例属性或类属性，而不用指定是存储型属性或计算型属性。此外还必须指明是只读的还是可读可写的。
协议中的通常用var来声明变量属性，在类型声明后加上{ set get }来表示属性是可读可写的，只读属性则用{ get }来表示。如下：

```
procotol Perion {
    var name :String {get set}
    var age : Int {get}
    var like : String {get set}
}
```
### 对 Mutating 方法的规定
有时需要在方法中改变它的实例。
例如，值类型(结构体，枚举)的实例方法中，将mutating关键字作为函数的前缀，写在func之前，表示可以在该方法中修改它所属的实例及其实例属性的值。
### 对构造器的规定

```
protocol SomeProtocol {
   init(someParameter: Int)
}
```
你可以在遵循该协议的类中实现构造器，并指定其为类的指定构造器或者便利构造器。在这两种情况下，你都必须给构造器实现标上"required"修饰符,实例如下:

```
protocol tcpprotocol {
   init(aprot: Int)
}

class tcpClass: tcpprotocol {
   required init(aprot: Int) {
   }
}
```
### 协议类型
尽管协议本身并不实现任何功能，但是协议可以被当做类型来使用。
协议可以像其他普通类型一样使用，使用场景:
- 作为函数、方法或构造器中的参数类型或返回值类型
- 作为常量、变量或属性的类型
- 作为数组、字典或其他容器中的元素类型

## 检验协议一致性


```
//检验协议一致性

protocol HasArea{
    var area : Double{ get }
}
class yuan: HasArea{
    var radius : Double
     let pi = 3.141592652
    var area:Double{
               return pi * radius * radius
    }
    init(radius:Double) {
        self.radius = radius
    }
}
class changfangxing: HasArea{
    var chang:Double
    var kuan:Double
    var area:Double {
        return chang * kuan
    }
    init(chang:Double,kuan:Double) {
        self.chang = chang
        self.kuan = kuan
    }
}
class qitaxing{//未实现HasArea协议
    var legs: Int
    
    init(legs: Int) { self.legs = legs }
}

var objects : [AnyObject] = []
objects.append(yuan(radius:12.0))
objects.append(yuan(radius:2))
objects.append(changfangxing(chang:2,kuan:3))
objects.append(qitaxing(legs:3))
objects.append(changfangxing(chang:4,kuan:3))
objects.append(qitaxing(legs:5))

for item in objects{
    if let hasareaitem = item as? HasArea {//符合协议规则
        print("图形面积是： \(hasareaitem.area)")
    }else{//不符合协议规则
        print("不符合协议规定，无面积")
    }
}
```
## Swift泛型
实例如下:

```
//泛型

func swipTwoValue<T> (_ a:inout T,_ b:inout T){
    let mya = a
    a = b
    b = mya
}
var testray = 15
var testallen = 12

print("转换前: \(testray) : \(testallen)")
swipTwoValue(&testray ,&testallen)
print("转换后: \(testray) : \(testallen)")
```

### 泛型类型
Swift 允许你定义你自己的泛型类型。
自定义类、结构体和枚举作用于任何类型，如同 Array 和 Dictionary 的用法。
### 类型约束
你可以写一个在一个类型参数名后面的类型约束，通过冒号分割，来作为类型参数链的一部分。这种作用于泛型函数的类型约束的基础语法如下所示（和泛型类型的语法相同）：

```
func someFunction<T: SomeClass, U: SomeProtocol>(someT: T, someU: U) {
    // 这里是泛型函数的函数体部分
}
```
上面这个函数有两个类型参数。第一个类型参数 T，有一个要求 T 必须是 SomeClass 子类的类型约束；第二个类型参数 U，有一个要求 U 必须符合 SomeProtocol 协议的类型约束。
```
//类型约束

func learn<T:Sbujects,U:Persion>(xueke: T,who: U){
    if let wodewuli = xueke as? Wuli{
        print("\(who.name) 学习 \(wodewuli.xueke) - \(wodewuli.fangcheng)")
    }else{
        
    }

}
let myxueke = Wuli(xueke:"天体物理",fangcheng:"物理方程1")
let people = Paul()

learn(xueke: myxueke, who: people)
```
### 关联类

Swift 中使用 ==associatedtype== 关键字来设置关联类型实例。
下面例子定义了一个 Container 协议，该协议定义了一个关联类型 ItemType。
Container 协议只指定了三个任何遵从 Container 协议的类型必须提供的功能。遵从协议的类型在满足这三个条件的情况下也可以提供其他额外的功能。

```
// Container 协议
protocol Container {
    associatedtype ItemType
    // 添加一个新元素到容器里
    mutating func append(_ item: ItemType)
    // 获取容器中元素的数
    var count: Int { get }
    // 通过索引值类型为 Int 的下标检索到容器中的每一个元素
    subscript(i: Int) -> ItemType { get }
}

// Stack 结构体遵从 Container 协议
struct Stack<Element>: Container {
    // Stack<Element> 的原始实现部分
    var items = [Element]()
    mutating func push(_ item: Element) {
        items.append(item)
    }
    mutating func pop() -> Element {
        return items.removeLast()
    }
    // Container 协议的实现部分
    mutating func append(_ item: Element) {
        self.push(item)
    }
    var count: Int {
        return items.count
    }
    subscript(i: Int) -> Element {
        return items[i]
    }
}

var tos = Stack<String>()
tos.push("google")
tos.push("runoob")
tos.push("taobao")
// 元素列表
print(tos.items)
// 元素个数
print( tos.count)
```
### where语句
类型约束能够确保类型符合泛型函数或类的定义约束。
你可以在参数列表中通过where语句定义参数的约束。
你可以写一个where语句，紧跟在在类型参数列表后面，where语句后跟一个或者多个针对关联类型的约束，以及（或）一个或多个类型和关联类型间的等价(equality)关系。

实例如下：

```
// Container 协议
protocol Container {
    associatedtype ItemType
    // 添加一个新元素到容器里
    mutating func append(_ item: ItemType)
    // 获取容器中元素的数
    var count: Int { get }
    // 通过索引值类型为 Int 的下标检索到容器中的每一个元素
    subscript(i: Int) -> ItemType { get }
}
 
// // 遵循Container协议的泛型TOS类型
struct Stack<Element>: Container {
    // Stack<Element> 的原始实现部分
    var items = [Element]()
    mutating func push(_ item: Element) {
        items.append(item)
    }
    mutating func pop() -> Element {
        return items.removeLast()
    }
    // Container 协议的实现部分
    mutating func append(_ item: Element) {
        self.push(item)
    }
    var count: Int {
        return items.count
    }
    subscript(i: Int) -> Element {
        return items[i]
    }
}
// 扩展，将 Array 当作 Container 来使用
extension Array: Container {}
 
func allItemsMatch<C1: Container, C2: Container>
    (_ someContainer: C1, _ anotherContainer: C2) -> Bool
    where C1.ItemType == C2.ItemType, C1.ItemType: Equatable {
        
        // 检查两个容器含有相同数量的元素
        if someContainer.count != anotherContainer.count {
            return false
        }
        
        // 检查每一对元素是否相等
        for i in 0..<someContainer.count {
            if someContainer[i] != anotherContainer[i] {
                return false
            }
        }
        
        // 所有元素都匹配，返回 true
        return true
}
var tos = Stack<String>()
tos.push("google")
tos.push("runoob")
tos.push("taobao")
 
var aos = ["google", "runoob", "taobao"]
 
if allItemsMatch(tos, aos) {
    print("匹配所有元素")
} else {
    print("元素不匹配")
}
```
## Swift访问控制


访问级别 | 定义
---|---
public | 可以访问自己模块中源文件里的任何实体，别人也可以通过引入该模块来访问源文件里的所有实体。
internal | 可以访问自己模块中源文件里的任何实体，但是别人不能访问该模块中源文件里的实体。
fileprivate | 文件内私有，只能在当前源文件中使用
private | 只能在类中访问，离开了这个类或者结构体的作用域外面就无法访问



