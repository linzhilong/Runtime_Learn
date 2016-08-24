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
//    [self test];
    
    [self ex_registerClassPair];
    // Do any additional setup after loading the view.
}

void TestMetaClass(id self, SEL _cmd) {
    
//    @synchronized (<#token#>) {
//        <#statements#>
//    }
    
    NSLog(@"This objcet is %p", self);
    
    NSLog(@"Class is %@, super class is %@", [self class], [self superclass]);
    
    
    
    Class currentClass = [self class];
    const char *className = object_getClassName(currentClass);
    
    for (int i = 0; i < 4; i++) {
        
        NSLog(@"Following the isa pointer %d times gives %p", i, currentClass);
        
        currentClass = objc_getClass((__bridge void *)currentClass);
        className = object_getClassName(currentClass);
        
    }
    
    
    
    NSLog(@"NSObject's class is %p", [NSObject class]);
    
    NSLog(@"NSObject's meta class is %p", objc_getClass((__bridge void *)[NSObject class]));
    
}



#pragma mark -



- (void)ex_registerClassPair {
    Class newClass = objc_allocateClassPair([NSError class], "TestClass", 0);
    
    class_addMethod(newClass, @selector(testMetaClass), (IMP)TestMetaClass, "v@:");
    
    objc_registerClassPair(newClass);
    
    
    
    id instance = [[newClass alloc] initWithDomain:@"some domain" code:0 userInfo:nil];
    
    [instance performSelector:@selector(testMetaClass)];
    
}

- (void)test {
    unsigned int count = 0;
    
    
    
    Method *list = class_copyMethodList([NSObject class], &count);
    const char *className = object_getClassName([NSObject class]);
    
    Class tmpclass = objc_getClass((__bridge void *)self);
    list = class_copyMethodList(tmpclass, &count);
    NSLog(@"NSObject's meta class is %p", objc_getClass("MethodVC"));
    NSLog(@"NSObject's meta class is %p", objc_getClass("NSObject"));
    
    Class getclass = objc_getClass("MethodVC");
    className = object_getClassName(getclass);
    list = class_copyMethodList(getclass, &count);
    
    getclass = objc_getClass((__bridge void *)getclass);
    className = object_getClassName(getclass);
    list = class_copyMethodList(getclass, &count);
    
    for(int index = 0; index < count; index ++) {
        Method method = list[index];
        SEL name = method_getName(method);
        NSLog(@"method_name:%@", NSStringFromSelector(name));
        
        //        const char *type = method_getTypeEncoding(method);
        //        NSLog(@"method_type:%s\n", type);
        //
        //        IMP imp = method_getImplementation(method);
        //
        //        const char *returnType = method_copyReturnType(method);
        //        NSLog(@"method_return_type:%s\n", returnType);
        //
        //        unsigned int argumentsNum = method_getNumberOfArguments(method);
        //
        //        for (int i = 0; i < argumentsNum; i++) {
        //            const char *argumentType = method_copyArgumentType(method, i);
        //            NSLog(@"method_argumentType:%s\n", argumentType);
        //        }
        //
        //        if ([NSStringFromSelector(name) isEqualToString:@"addArguOne:arguTwo:"]) {
        //            typedef int (*AddFunc)(id, SEL, int, int);
        //            AddFunc func = (AddFunc)imp;
        //            int sum = func(self, name, 1, 2);
        //            NSLog(@"sum=%ld", (long)sum);
        //        }
    }
    free(list);
    
    
    
    Class metaClass = objc_getMetaClass(className);
    className = object_getClassName(metaClass);
    list = class_copyMethodList(metaClass, &count);
    
//    Class superClass = class_getSuperclass(metaClass);
//    className = object_getClassName(superClass);
//    list = class_copyMethodList(superClass, &count);
    
    BOOL respond;
    respond = [metaClass instancesRespondToSelector:@selector(addArguOne1:arguTwo:)];
    respond = [metaClass instancesRespondToSelector:@selector(init)];
    
    respond = [[MethodVC class] instancesRespondToSelector:@selector(init)];
    respond = [[MethodVC class] instancesRespondToSelector:@selector(conformsToProtocol:)];
    
//    while (metaClass) {
//        metaClass = objc_getMetaClass(className);
//        className = object_getClassName(metaClass);
//        list = class_copyMethodList(metaClass, &count);
//    }
    
    
    
    
    
    for(int index = 0; index < count; index ++) {
        Method method = list[index];
        SEL name = method_getName(method);
        NSLog(@"method_name:%@", NSStringFromSelector(name));
        
//        const char *type = method_getTypeEncoding(method);
//        NSLog(@"method_type:%s\n", type);
//        
//        IMP imp = method_getImplementation(method);
//        
//        const char *returnType = method_copyReturnType(method);
//        NSLog(@"method_return_type:%s\n", returnType);
//        
//        unsigned int argumentsNum = method_getNumberOfArguments(method);
//        
//        for (int i = 0; i < argumentsNum; i++) {
//            const char *argumentType = method_copyArgumentType(method, i);
//            NSLog(@"method_argumentType:%s\n", argumentType);
//        }
//        
//        if ([NSStringFromSelector(name) isEqualToString:@"addArguOne:arguTwo:"]) {
//            typedef int (*AddFunc)(id, SEL, int, int);
//            AddFunc func = (AddFunc)imp;
//            int sum = func(self, name, 1, 2);
//            NSLog(@"sum=%ld", (long)sum);
//        }
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

+ (NSInteger)addArguOne1:(NSInteger)arguOne arguTwo:(NSInteger)arguTwo {
    return arguOne + arguTwo;
}

@end
