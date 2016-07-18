//
//  UIViewContorller+.m
//  NSObject_Learn
//
//  Created by zhilong.lin on 16/3/7.
//  Copyright © 2016年 zhilong.lin. All rights reserved.
//

#import "UIViewContorller+runtime.h"
#import <objc/runtime.h>

@implementation UIViewController (runtime)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class class = [self class];
        // When swizzling a class method, use the following:
        // Class class = object_getClass((id)self);
        
        SEL originalSelector = @selector(viewWillAppear:);
        SEL swizzledSelector = @selector(xxx_viewWillAppear:);
        
        Method originalMethod = class_getInstanceMethod(class, originalSelector);
        Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
        
        //如果ViewController有override viewWillAppear方法，则didAddMethod＝no；否则，添加一个override 的viewWillAppear方法，返回yes。
        BOOL didAddMethod =
        class_addMethod(class,
                        originalSelector,
                        method_getImplementation(swizzledMethod),
                        method_getTypeEncoding(swizzledMethod));
        
        if (didAddMethod) {
            class_replaceMethod(class,
                                swizzledSelector,
                                method_getImplementation(originalMethod),
                                method_getTypeEncoding(originalMethod));
        } else {
            //如果ViewController有viewWillAppear方法，则可以替换。 否则，若ViewController没有override viewWillAppear方法，
            //调用method_exchangeImplementations的话，替换的是ViewController的父类UIViewController的viewWillAppear方法，作用于所有UIViewController的子类。
            method_exchangeImplementations(originalMethod, swizzledMethod);
        }
    });
}

#pragma mark - Method Swizzling

- (void)xxx_viewWillAppear:(BOOL)animated {
    [self xxx_viewWillAppear:animated];
    NSLog(@"viewWillAppear: %@", self);
}

@end