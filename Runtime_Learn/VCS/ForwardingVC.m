//
//  ForwardingVC.m
//  NSObject_Learn
//
//  Created by zhilong.lin on 16/3/7.
//  Copyright © 2016年 zhilong.lin. All rights reserved.
//

#import "ForwardingVC.h"
#import <objc/runtime.h>

@interface ForwardingTarget : NSObject

- (NSString *)forwardingTarget:(id)sender;

@end

@implementation ForwardingTarget

- (NSString *)forwardingTarget:(id)sender {
    NSLog(@"self:%@;id:%@", self, sender);
    return @"forwardingTarget___";
}

- (id)forwardingTargetForSelector:(SEL)aSelector {
    //    if ([self.forwardingTarget respondsToSelector:aSelector]) {
    //        return self.forwardingTarget;
    //    } else {
    return [super forwardingTargetForSelector:aSelector];
    //    }
}

- (void)forwardInvocation:(NSInvocation *)anInvocation {
    //    [anInvocation setSelector:@selector(noForwardingTarget:)];
    //    void *arg1;
    //    [anInvocation getArgument:arg1 atIndex:2];
    //    free(&arg1);
    //    [anInvocation invokeWithTarget:self];
    //    return;
    
    NSLog(@"anInvocation:%@", anInvocation);
    SEL aSelector = [anInvocation selector];
    
//    //    if ([self.forwardingTarget respondsToSelector:aSelector])
//    [anInvocation invokeWithTarget:self.forwardingTarget];
    //    else
            [super forwardInvocation:anInvocation];
    return;
}

- (void)noForwardingTarget:(id)sender {
    NSLog(@"self:%@;id:%@", self, sender);
}

- (void)doesNotRecognizeSelector:(SEL)aSelector {
    NSLog(@"self:%@;id:%@;;_cmd:%@", self, NSStringFromSelector(aSelector), NSStringFromSelector(_cmd));
//    [super doesNotRecognizeSelector:aSelector];
}

+ (NSMethodSignature *)instanceMethodSignatureForSelector:(SEL)aSelector {
    return [super instanceMethodSignatureForSelector:aSelector];
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector {
    return [NSMethodSignature signatureWithObjCTypes:"i@:i"];
}
@end

@interface ForwardingVC ()

@property (nonatomic, strong) ForwardingTarget *forwardingTarget;
@end

@implementation ForwardingVC

+ (void)initialize {
    NSLog(@"%@", NSStringFromSelector(_cmd));
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.forwardingTarget = [[ForwardingTarget alloc] init];
    
    [self performSelector:@selector(test) withObject:self];
//    [self performSelector:@selector(forwardingTarget22:) withObject:self];
//    NSString *result;
    IMP imp = [self methodForSelector:NSSelectorFromString(@"forwardingTarget22:")];
//    imp();
    typedef NSString* (*AddFunc)(id, SEL, id);
    AddFunc func = (AddFunc)imp;
    NSString *test = func(self, NSSelectorFromString(@"forwardingTarget1:"), self);
    NSLog(@"rest_result:%@", test);
//    [self targettest];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)test {
    NSLog(@"%@", NSStringFromSelector(_cmd));
}

+ (BOOL)instancesRespondToSelector:(SEL)aSelector {
//    if (sel_isEqual(aSelector, NSSelectorFromString(@"test"))) {
//        return NO;
//    }
    return [super instancesRespondToSelector:aSelector];
}

- (BOOL)respondsToSelector:(SEL)aSelector {
//    if (sel_isEqual(aSelector, NSSelectorFromString(@"test"))) {
//        return NO;
//    }
    return [super respondsToSelector:aSelector];
}

  + (BOOL)resolveInstanceMethod {
    return YES;
}

//- (id)forwardingTargetForSelector:(SEL)aSelector {
//    if ([self.forwardingTarget respondsToSelector:aSelector]) {
//        return self.forwardingTarget;
//    } else {
//        return [super forwardingTargetForSelector:aSelector];
//    }
//}

- (void)forwardInvocation:(NSInvocation *)anInvocation {
//    [anInvocation setSelector:@selector(noForwardingTarget:)];
//    void *arg1;
//    [anInvocation getArgument:arg1 atIndex:2];
//    free(&arg1);
//    [anInvocation invokeWithTarget:self];
//    return;
    
    NSLog(@"anInvocation:%@", anInvocation);
    id target = [anInvocation target];
    SEL aSelector = [anInvocation selector];
    NSUInteger argumentsCount = [[anInvocation methodSignature] numberOfArguments];
    NSMutableArray *arguments = [NSMutableArray array];
    
    [arguments addObject:target];
    [arguments addObject:NSStringFromSelector(aSelector)];
    for (NSUInteger index = 2; index < argumentsCount; index++) {
        void *arg;
        [anInvocation getArgument:&arg atIndex:index];
        [arguments addObject:(__bridge id)arg];
    }
    
    anInvocation.target = self;
    anInvocation.selector = @selector(forwardProcessArguments:);
    [anInvocation setArgument:(&arguments) atIndex:2];
    
    [anInvocation invoke];
    
    void *ret;
    [anInvocation getReturnValue:&ret];
    NSLog(@"return:%@", ret);
    
//    if ([self.forwardingTarget respondsToSelector:aSelector])
//        [anInvocation invokeWithTarget:self.forwardingTarget];
//    else
//        [super forwardInvocation:anInvocation];
}

- (id)forwardProcessArguments:(NSArray *)arguments {
    NSLog(@"_cmd:%@;;arguments:%@", NSStringFromSelector(_cmd), arguments);
    for (NSInteger index = 0; index < arguments.count; index ++) {
        NSLog(@"obj:%@", arguments[index]);
    }
    return @"abc";
}

- (void)noForwardingTarget:(id)sender {
    NSLog(@"self:%@;id:%@", self, sender);
}

- (void)doesNotRecognizeSelector:(SEL)aSelector {
    [super doesNotRecognizeSelector:aSelector];
   NSLog(@"self:%@;id:%@;;_cmd:%@", self, NSStringFromSelector(aSelector), NSStringFromSelector(_cmd));
}

+ (NSMethodSignature *)instanceMethodSignatureForSelector:(SEL)aSelector {
    return [super instanceMethodSignatureForSelector:aSelector];
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector {
//    return [NSMethodSignature signatureWithObjCTypes:"v@:@"];
    
    NSMethodSignature *signature = [self.forwardingTarget methodSignatureForSelector:aSelector];
    if (!signature) {
//        for (id obj in self) {
//            if ((signature = [obj methodSignatureForSelector:aSelector])) {
//                break;
//            }
//        }
        signature = [super methodSignatureForSelector:aSelector];
    }
    return signature;
}

+ (BOOL)resolveClassMethod:(SEL)sel {
    return NO;
}

+ (BOOL)resolveInstanceMethod:(SEL)sel {
    return NO;
}

@end
