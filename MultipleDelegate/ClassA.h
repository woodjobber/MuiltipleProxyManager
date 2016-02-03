//
//  ClassA.h
//  MultipleDelegate
//
//  Created by chengbin on 16/1/15.
//  Copyright © 2016年 chengbin. All rights reserved.
//

#import <Foundation/Foundation.h>
@class ClassB;
@interface ClassA : NSObject
@property (nonatomic, readonly) ClassA *(^aaa)(BOOL enable);
@property (nonatomic, readonly) ClassA *(^bbb)(NSString *str);
@property (nonatomic, readonly) ClassB *(^ccc)(NSString *str);
@end


@interface ClassB : NSObject
@property (nonatomic, readonly) ClassB *(^ddd)(BOOL enable);
-(instancetype)initWithString:(NSString *)str;
@end