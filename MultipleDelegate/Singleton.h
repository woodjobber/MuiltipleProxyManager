//
//  Singleton.h
//  GNum
//
//  Created by chengbin on 15/10/22.
//  Copyright © 2015年 globalroam. All rights reserved.
//

#ifndef Singleton_h
#define Singleton_h

#ifndef AS_SINGLETON
#define AS_SINGLETON( __class)\
- (__class *)sharedInstance;\
+ (__class *)sharedInstance;

#endif

#if __has_feature(objc_arc)
#undef  DEF_SINGLETON
#define DEF_SINGLETON( __class ) \
- (__class *)sharedInstance \
{\
return [__class sharedInstance]; \
} \
static __class * __singleton__; \
+ (id)allocWithZone:(struct _NSZone *)zone \
{ \
static dispatch_once_t onceToken; \
dispatch_once(&onceToken, ^{ \
__singleton__ = [super allocWithZone:zone];\
}); \
return __singleton__; \
}   \
+ (__class *)sharedInstance \
{ \
static dispatch_once_t onceToken; \
dispatch_once( &onceToken, ^{  __singleton__ = [[self alloc] init]; }); \
return __singleton__; \
} \
\
- (id)copyWithZone:(NSZone *)zone \
{  \
return __singleton__; \
} \
- (id)mutableCopyWithZone:(NSZone *)zone \
{ \
return __singleton__; \
}


#else

#error This file must be compiled with ARC. Convert your project to ARC or specify the -fobjc-arc flag.

#endif

#endif /* Singleton_h */
