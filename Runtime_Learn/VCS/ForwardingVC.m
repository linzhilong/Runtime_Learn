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

- (void)forwardingTarget:(id)sender;

@end

@implementation ForwardingTarget

- (void)forwardingTarget:(id)sender {
    NSLog(@"self:%@;id:%@", self, sender);
}

- (id)forwardingTargetForSelector:(SEL)aSelector {
    //    if ([self.forwardingTarget respondsToSelector:aSelector]) {
    //        return self.forwardingTarget;
    //    } else {
    return [NSObject new];
    //    }
}

@end

@interface ForwardingVC ()

@property (nonatomic, strong) ForwardingTarget *forwardingTarget;
@end

@implementation ForwardingVC
- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.forwardingTarget = [[ForwardingTarget alloc] init];
    [self performSelector:@selector(test) withObject:self];
    [self performSelector:@selector(forwardingTarget22:) withObject:self];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)test {
    NSLog(@"%@", NSStringFromSelector(_cmd));
}

+ (BOOL)instancesRespondToSelector:(SEL)aSelector {
    if (sel_isEqual(aSelector, NSSelectorFromString(@"test"))) {
        return NO;
    }
    return [super instancesRespondToSelector:aSelector];
}

- (BOOL)respondsToSelector:(SEL)aSelector {
    if (sel_isEqual(aSelector, NSSelectorFromString(@"test"))) {
        return NO;
    }
    return [super respondsToSelector:aSelector];
}

  + (BOOL)resolveInstanceMethod {
    return YES;
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
    
    if ([self.forwardingTarget respondsToSelector:aSelector])
        [anInvocation invokeWithTarget:self.forwardingTarget];
    else
        [super forwardInvocation:anInvocation];
    return;
}

- (void)noForwardingTarget:(id)sender {
    NSLog(@"self:%@;id:%@", self, sender);
}

- (void)doesNotRecognizeSelector:(SEL)aSelector {
//    [super doesNotRecognizeSelector:aSelector];
   NSLog(@"self:%@;id:%@;;_cmd:%@", self, NSStringFromSelector(aSelector), NSStringFromSelector(_cmd));
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

@end
