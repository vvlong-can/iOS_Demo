//
//  ViewController.m
//  KVO
//
//  Created by vvlong on 2017/3/31.
//  Copyright © 2017年 vvlong. All rights reserved.
//

#import "ViewController.h"
#import "Person.h"
#import "Dog.h"

@interface ViewController ()
@property (nonatomic, strong) Dog *dog;
@property (nonatomic, strong) Person *p;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.p = [Person new];
    self.dog = [Dog new];
//    KVO
    [self.dog addObserver:self.p forKeyPath:@"age" options:NSKeyValueObservingOptionNew context:nil];
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    self.dog.age = 99;
    ///isa	Class	NSKVONotifying_Dog	0x000060000010f540
    ///这里会监听 这个Dog子类的willChangeValueForKey:@"age" 和didChange方法
}


@end
