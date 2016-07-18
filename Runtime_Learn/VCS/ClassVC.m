//
//  ClassVC.m
//  Runtime_Learn
//
//  Created by zhilong.lin on 16/7/18.
//  Copyright © 2016年 zhilong.lin. All rights reserved.
//

#import "ClassVC.h"
#import <objc/runtime.h>

@interface ClassVC ()
@property (nonatomic, assign) CGFloat myFlt;
@property (nonatomic, assign) double myDouble;
@end

@implementation ClassVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    Class *buffer = nil;
//    unsigned int bufferCount = 0;
//    buffer = objc_copyClassList(&bufferCount);
//    
//    NSLog(@"count:%ld", (long)bufferCount);
//    for (int index = 0; index < bufferCount; index ++) {
//        Class *class = &buffer[index];
//        NSLog(@"className:%s\n", object_getClassName(*class));
//    }
//    free(buffer);
//    
//    NSLog(@"----------------------\n\n\n");
    
    Class targetClass = [self class];
    while (targetClass) {
        NSLog(@"className:%s;;%ld;;%ld\n",
              object_getClassName(targetClass),
              (long)class_getVersion(targetClass),
              class_getInstanceSize(targetClass));
        targetClass = class_getSuperclass(targetClass);
    }
    
    BOOL nsobjectIsMetaClass = class_isMetaClass([NSObject class]);
    BOOL selfIsmetaClass = class_isMetaClass([self class]);
    NSLog(@"nsobjectIsMetaClass:%@;;selfIsmetaClass:%@", nsobjectIsMetaClass ? @"yes" : @"no", selfIsmetaClass ? @"yes" : @"no");
}

@end
