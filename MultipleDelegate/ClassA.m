//
//  ClassA.m
//  MultipleDelegate
//
//  Created by chengbin on 16/1/15.
//  Copyright © 2016年 chengbin. All rights reserved.
//

#import "ClassA.h"
@class ClassB;

@implementation ClassA
-(ClassA *(^)(BOOL))aaa{
    ClassA *(^ret)(BOOL) = ^ ClassA *(BOOL enabel){
        if (enabel) {
            NSLog(@"ClassA yes");
        }else{
            NSLog(@"ClassA no");
        }
        return self;
    };
    
    return ret;
}

-(ClassA *(^)(NSString *))bbb{
    ClassA *(^ret)(NSString *) = ^ ClassA *(NSString *str){
        NSLog(@"%@",str);
        return self;
    };
    return ret;
}

-(ClassB *(^)(NSString *))ccc{
    return ^ClassB *(NSString *str){
        NSLog(@"%@",str);
        ClassB *b = [[ClassB alloc]initWithString:str];
        return b;
    };
}
@end


@implementation ClassB
-(ClassB *(^)(BOOL))ddd{
    return ^(BOOL enable){
        if (enable) {
            NSLog(@"ClassB yes");
        }else{
            NSLog(@"ClassB no");
        }
        return self;
    };
}
-(instancetype)initWithString:(NSString *)str{
    if (self = [super init]) {
        
    }
    return self;
}

@end