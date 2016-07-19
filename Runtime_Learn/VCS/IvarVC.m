//
//  IvarVC.m
//  Runtime_Learn
//
//  Created by zhilong.lin on 16/7/18.
//  Copyright © 2016年 zhilong.lin. All rights reserved.
//

#import "IvarVC.h"
#import <objc/runtime.h>

@implementation TestObject

@end

@interface IvarVC () {
    CGFloat testFlt;
}
@property (nonatomic, assign) CGFloat myFloat;
@end

@implementation IvarVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.myFloat = 2.34f;
    
    float myFloatValue;
    object_getInstanceVariable(self, "_myFloat", (void*)&myFloatValue);
    NSLog(@"%f", myFloatValue);
    
    float newValue = 5.34f;
    unsigned int addr = (unsigned int)&newValue;
    object_setInstanceVariable(self, "_myFloat", *(float**)addr);
    NSLog(@"%f", self.myFloat);
    
//    [self description];
}

-(NSString *)description {
    NSString  *strInfo = nil;
    const char *className = class_getName([self class]);
    NSString  *strClassName = [NSString stringWithCString:className encoding:[NSString defaultCStringEncoding]];
    
    strInfo = [NSString stringWithFormat:@"baseclass:%@ <<%p>> ",strClassName,self];
    
    
    unsigned int  count = 0;
    Ivar *list  =   class_copyIvarList([self class], &count);
    for (int i = 0; i < count; i++)
    {
        Ivar ivar = list[i];
        
        const char *name = ivar_getName(ivar);
        const char *type = ivar_getTypeEncoding(ivar);
        NSString  *ivarName = [NSString stringWithCString:name encoding:[NSString defaultCStringEncoding]];
        NSString  *ivarTye = [NSString stringWithCString:type encoding:[NSString defaultCStringEncoding]];
        //id realType = nil; //id object_getIvar(id obj, Ivar ivar)
        //id value = object_getIvar(self, ivar);
        
        if ([ivarTye rangeOfString:@"@"].location != NSNotFound)
        {
            id value = object_getIvar(self, ivar);
            strInfo = [strInfo stringByAppendingFormat:@" %@: %@",ivarName,value];
            //  NSLog();
        }else
        {
            if ([ivarTye length] == 1)
            {
                switch (type[0])
                {
                    case 'c':
                    {
                        char c = (char)object_getIvar(self, ivar);
                          NSLog(@"c:%@: %c",ivarName,c);
                        strInfo = [strInfo stringByAppendingFormat:@" %@: %c",ivarName,c];
                        
                    }
                        
                        break;
                    case 'i':
                    {
                        int c = (int)object_getIvar(self, ivar);
                        strInfo = [strInfo stringByAppendingFormat:@" %@: %i",ivarName,c];
                         NSLog(@"i:%@: %i",ivarName,c);
                        
                    }
                        break;
                    case 's':
                    {
                        short c = (short)object_getIvar(self, ivar);
                        strInfo = [strInfo stringByAppendingFormat:@" %@: %i",ivarName,c];
                         NSLog(@"s:%@: %i",ivarName,c);
                        
                    }
                        break;
                    case 'l':
                    {
                        long c = (long)object_getIvar(self, ivar);
                        strInfo = [strInfo stringByAppendingFormat:@" %@: %ld",ivarName,c];
                         NSLog(@"l:%@: %ld",ivarName,c);
                        
                    }
                        break;
                    case 'q':
                    {
                        long long c = (long long)object_getIvar(self, ivar);
                        strInfo = [strInfo stringByAppendingFormat:@" %@: %lld",ivarName,c];
                           NSLog(@"q:%@: %lld",ivarName,c);
                        
                    }
                        
                        break;
                    case 'C':
                    {
                        unsigned char c = (unsigned char)object_getIvar(self, ivar);
                        strInfo = [strInfo stringByAppendingFormat:@" %@: %c",ivarName,c];
                          NSLog(@"C:%@: %c",ivarName,c);
                        
                    }
                        break;
                    case 'I':
                    {
                        unsigned int c = (unsigned int)object_getIvar(self, ivar);
                        strInfo = [strInfo stringByAppendingFormat:@" %@: %d",ivarName,c];
                          NSLog(@"I:%@: %d",ivarName,c);
                        
                    }
                        break;
                    case 'S':
                    {
                        unsigned short c = (unsigned short)object_getIvar(self, ivar);
                        strInfo = [strInfo stringByAppendingFormat:@" %@: %d",ivarName,c];
                          NSLog(@"S:%@: %d",ivarName,c);
                        
                    }
                        break;
                    case 'L':
                    {
                        unsigned long c = (unsigned long)object_getIvar(self, ivar);
                        strInfo = [strInfo stringByAppendingFormat:@" %@: %ld",ivarName,c];
                         NSLog(@"L:%@: %ld",ivarName,c);
                        
                    }
                        break;
                    case 'Q':
                    {
                        unsigned long long c = (unsigned long long)object_getIvar(self, ivar);
                        strInfo = [strInfo stringByAppendingFormat:@" %@: %lld",ivarName,c];
                         NSLog(@"Q:%@: %lld",ivarName,c);
                        
                    }
                        break;
                    case 'f':
                    {
                        float  value = 0;
//                        self.ivar2 = 10;
                        object_getInstanceVariable(self,name,(void*)&value);
                        NSLog(@"f:value:%f",value);
//                        float c = object_getIvar(self, ivar);
//                        NSLog(@"%@: %f",ivarName,c);
                        
                    }
                        break;
                    case 'd':
                    {
                        double  value = 0;
//                        self.ivar2 = 10;
                        object_getInstanceVariable(self,name,(void*)&value);
                        NSLog(@"d:value:%f",value);
//                        double c = object_getIvar(self, ivar);
//                        NSLog(@"%@: %f",ivarName,c);
                        
                    }
                        break;
                    case 'B':
                    {
                        int c = (int)object_getIvar(self, ivar);
                        strInfo = [strInfo stringByAppendingFormat:@" %@: %d",ivarName,c];
                        NSLog(@"B:%@: %d",ivarName,c);
                        
                    }
                        break;
                    default:
                        break;
                }
            }
        }
        
         NSLog(@"name:%@ type:%@",ivarName,ivarTye);
    }
    
    
    
    free(list);
    
    
    return strInfo;
}

@end
