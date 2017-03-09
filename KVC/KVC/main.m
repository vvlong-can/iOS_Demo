//
//  main.m
//  KVC
//
//  Created by vvlong on 2017/3/4.
//  Copyright © 2017年 vvlong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Dog.h"
#import "TwoTimesArray.h"
#import "People.h"
#import "Address.h"
#import "arrTest.h"

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        // insert code here...
        ///part1
        NSLog(@"KVC Test!");
        Dog* dog = [Dog new];
//        [dog setValue:@"newName" forKey:@"name"];
        [dog setValue:@"isNewName" forKey:@"isName"];
        NSString* name = [dog valueForKey:@"name"];
        NSLog(@"%@",name);
        
        TwoTimesArray* arr = [TwoTimesArray new];
        ///对比key的遍历顺序 _<key>,_is<Key>,<key>,is<Key>
        NSNumber* num =   [arr valueForKey:@"num"];
        NSLog(@"%@",num);
        
        
        ///part2
        /*首先按get<Key>,<key>,is<Key>的顺序方法查找getter方法，找到的话会直接调用。如果是BOOL或者int等值类型， 会做NSNumber转换
        如果上面的getter没有找到，KVC则会查找countOf<Key>,objectIn<Key>AtIndex,<Key>AtIndex格式的方法。如果countOf<Key>和另外两个方法中的要个被找到，那么就会返回一个可以响应NSArray所的方法的代理集合(它是NSKeyValueArray，是NSArray的子类)，调用这个代理集合的方法，或者说给这个代理集合发送NSArray的方法，就会以countOf<Key>,objectIn<Key>AtIndex,<Key>AtIndex这几个方法组合的形式调用。还有一个可选的get<Ket>:range:方法。*/
        id ar = [arr valueForKey:@"numbers"];
        NSLog(@"%@",NSStringFromClass([ar class]));
        NSLog(@"0:%@     1:%@     2:%@     3:%@",ar[0],ar[1],ar[2],ar[3]);
        [arr incrementCount];                                                                            //count加1
        NSLog(@"%lu",(unsigned long)[ar count]);                                                         //打印出1
        [arr incrementCount];                                                                            //count再加1
        NSLog(@"%lu",(unsigned long)[ar count]);                                                         //打印出2
        
        [arr setValue:@"newName" forKey:@"arrName"];
        NSString* name1 = [arr valueForKey:@"arrName"];
        NSLog(@"%@",name1);
        
        ///keyPath   part3
        ///尽管valueForKey：会自动将值类型封装成对象，但是setValue：forKey：却不行。你必须手动将值类型转换成NSNumber或者NSValue类型，才能传递过去。
        ///valueForKey：总是返回一个id对象，如果原本的变量类型是值类型或者结构体，返回值会封装成NSNumber或者NSValue对象。
        People* people1 = [People new];
        Address* add = [Address new];
        add.country = @"China";
        people1.address = add;
        NSString* country1 = people1.address.country;
        NSString * country2 = [people1 valueForKeyPath:@"address.country"];
        NSLog(@"country1:%@   country2:%@",country1,country2);
        [people1 setValue:@"USA" forKeyPath:@"address.country"];
        country1 = people1.address.country;
        country2 = [people1 valueForKeyPath:@"address.country"];
        NSLog(@"country1:%@   country2:%@",country1,country2);
        
        ///异常处理  age会抛异常 name不会 因为name为String *
        People* peopleForException = [People new];
        [peopleForException setValue:nil forKey:@"age"];
        [peopleForException setValue:nil forKey:@"name"];
        
        
        ///当只是普通地调用[_arr addObject:@"1"]时，Observer并不会回调，只有[[self mutableArrayValueForKey:@"arr"] addObject:@"1"];这样写时才能正确地触发KVO。
        arrTest *arrtset = [arrTest new];
        [arrtset addItem];
        [arrtset addItemObserver];
        [arrtset removeItemObserver];
    }
    return 0;
}
