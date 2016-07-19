//
//  MethodVC.m
//  Runtime_Learn
//
//  Created by zhilong.lin on 16/7/18.
//  Copyright © 2016年 zhilong.lin. All rights reserved.
//

#import "MethodVC.h"
#import <objc/runtime.h>

@interface MethodVC ()

@end

@implementation MethodVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self test];
    // Do any additional setup after loading the view.
}

- (void)test {
    unsigned int count = 0;
    Method *list = class_copyMethodList([self class], &count);
    for(int index = 0; index < count; index ++) {
        Method method = list[index];
        SEL name = method_getName(method);
        NSLog(@"method_name:%@", NSStringFromSelector(name));
        
        const char *type = method_getTypeEncoding(method);
        NSLog(@"method_type:%s\n", type);
        
        IMP imp = method_getImplementation(method);
        
        const char *returnType = method_copyReturnType(method);
        NSLog(@"method_return_type:%s\n", returnType);
        
        unsigned int argumentsNum = method_getNumberOfArguments(method);
        
        for (int i = 0; i < argumentsNum; i++) {
            const char *argumentType = method_copyArgumentType(method, i);
            NSLog(@"method_argumentType:%s\n", argumentType);
        }
        
        if ([NSStringFromSelector(name) isEqualToString:@"addArguOne:arguTwo:"]) {
            typedef int (*AddFunc)(id, SEL, int, int);
            AddFunc func = (AddFunc)imp;
            int sum = func(self, name, 1, 2);
            NSLog(@"sum=%ld", (long)sum);
        }
    }
    free(list);
}

- (NSString *)test:(NSInteger)integer float:(CGFloat)testFloat {
    return @"";
}

- (void)testVoid {
}

- (NSInteger)addArguOne:(NSInteger)arguOne arguTwo:(NSInteger)arguTwo {
    return arguOne + arguTwo;
}

@end
