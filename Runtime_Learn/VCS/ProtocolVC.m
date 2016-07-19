//
//  ProtocolVC.m
//  Runtime_Learn
//
//  Created by zhilong.lin on 16/7/19.
//  Copyright © 2016年 zhilong.lin. All rights reserved.
//

#import "ProtocolVC.h"
#import <objc/runtime.h>

@interface ProtocolVC ()<NSCopying>

@end

@implementation ProtocolVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self test];
    // Do any additional setup after loading the view.
}

- (void)test {
    unsigned int count = 0;
    __unsafe_unretained Protocol **list = class_copyProtocolList([self class], &count);
    for(int index = 0; index < count; index ++) {
        Protocol *ptotocol = list[index];
        const char * name = protocol_getName(ptotocol);
        NSLog(@"ptotocol_name:%s", name);
    }
}

#pragma mark - test
- (id)copyWithZone:(nullable NSZone *)zone {
    return nil;
}


@end
