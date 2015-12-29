//
//  MuiltipleProxyManager.h
//  MultipleDelegate
//
//  Created by chengbin on 15/12/28.
//  Copyright © 2015年 chengbin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Singleton.h"

typedef NS_ENUM(NSUInteger, MuiltipleProxyManagerDelegateTargetsType) {
    MuiltipleProxyManagerDelegateTargetsTypeDefault,//
    MuiltipleProxyManagerDelegateTargetsTypeDictionary,
    MuiltipleProxyManagerDelegateTargetsTypeArray = MuiltipleProxyManagerDelegateTargetsTypeDefault
};

typedef void(^MuiltipleProxyManagerRefreshDelegateBlock)(void);

@interface MuiltipleProxyManager : NSObject

@property (nonatomic, strong) id delegateTargets;
@property (nonatomic, assign) MuiltipleProxyManagerDelegateTargetsType delegateTargetsType;


AS_SINGLETON(MuiltipleProxyManager);
-(void)addDelegate:(id)object andRefreshDelegateBlock:(MuiltipleProxyManagerRefreshDelegateBlock)block;
-(void)removeDelegate:(id)object;
-(void)removeDelegates:(id)objects;
-(void)removeAllDelegates;
-(void)addDelegates:(id)objects andRefreshDelegateBlock:(MuiltipleProxyManagerRefreshDelegateBlock)block;
@end
