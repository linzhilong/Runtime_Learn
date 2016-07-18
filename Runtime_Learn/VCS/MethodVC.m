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
    // Do any additional setup after loading the view.
}

- (void)test {
    unsigned int count = 0;
    Method *list = class_copyMethodList([self class], &count);
    for(int index = 0; index < count; index ++) {
        Method method = list[index];
        const char *name = method_getName(method);
        const char *type = method_getTypeEncoding(method);
        NSString  *methodName = [NSString stringWithCString:name encoding:[NSString defaultCStringEncoding]];
        NSString  *methodType = [NSString stringWithCString:type encoding:[NSString defaultCStringEncoding]];
        
    }
}

@end
