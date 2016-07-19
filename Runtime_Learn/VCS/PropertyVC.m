//
//  PropertyVC.m
//  Runtime_Learn
//
//  Created by zhilong.lin on 16/7/19.
//  Copyright © 2016年 zhilong.lin. All rights reserved.
//

#import "PropertyVC.h"
#import <objc/runtime.h>

@interface PropertyVC () {
    NSString *testStr;
}
@property (nonatomic, assign) BOOL testBool;
@property double doubleDefault;
@end

@implementation PropertyVC
@synthesize doubleDefault = _doubleDefault;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self test];
    // Do any additional setup after loading the view.
}

- (void)test {
    unsigned int count = 0;
    objc_property_t *list = class_copyPropertyList([self class], &count);
    for(int index = 0; index < count; index ++) {
        objc_property_t property = list[index];
        const char *name = property_getName(property);
        NSLog(@"property_name:%s", name);
        
        const char *attributes = property_getAttributes(property);
        NSLog(@"property_attributes:%s\n", attributes);
        
        unsigned int attributeCount = 0;
        objc_property_attribute_t *attributeList = property_copyAttributeList(property, &attributeCount);
        for (int i = 0; i < attributeCount; i ++) {
            NSLog(@"property_attribute.name:%s,,value:%s\n", attributeList[i].name, attributeList[i].value);
        }
    }
    free(list);
}

@end
