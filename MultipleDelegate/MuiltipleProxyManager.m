//
//  MuiltipleProxyBehavior.m
//  MultipleDelegate
//
//  Created by chengbin on 15/12/28.
//  Copyright © 2015年 chengbin. All rights reserved.
//

#import "MuiltipleProxyManager.h"

@interface MuiltipleProxyManager ()
@property (nonatomic, strong) NSPointerArray *weakRefTargets;//NSArray
@property (nonatomic, strong) NSMapTable *delegateRefTargets;//NSDictionary
@end

@implementation MuiltipleProxyManager
DEF_SINGLETON(MuiltipleProxyManager);
static MuiltipleProxyManager *instance = nil;

-(instancetype)init{
    if (self =[super init]) {
        _delegateTargetsType = MuiltipleProxyManagerDelegateTargetsTypeDefault;
        _delegateRefTargets = [NSMapTable strongToWeakObjectsMapTable];
        _weakRefTargets = [NSPointerArray weakObjectsPointerArray];
    }
    return self;
}
- (NSPointerArray *)weakRefTargets{
    if (!_weakRefTargets) {
      _weakRefTargets = [NSPointerArray weakObjectsPointerArray];
    }
    return _weakRefTargets;
}
-(NSMapTable *)delegateRefTargets{
    if (!_delegateRefTargets) {
        _delegateRefTargets = [NSMapTable strongToWeakObjectsMapTable];
    }
    return _delegateRefTargets;
}

- (void)setDelegateTargets:(id)delegateTargets{
    @synchronized(self) {
        _delegateTargets = delegateTargets;
        if (delegateTargets) {
            switch (_delegateTargetsType) {
                case MuiltipleProxyManagerDelegateTargetsTypeDictionary:
                {
                    for (id key in delegateTargets) {
                        id value = [delegateTargets objectForKey:key];
                        [self removeSomeDelegateWithAnObject:value];
                    }
                    for (id key in delegateTargets) {
                        id value = [delegateTargets objectForKey:key];
                        [self.delegateRefTargets setObject:value forKey:key];
                    }
                }
                    break;
                case MuiltipleProxyManagerDelegateTargetsTypeArray:
                {
                    for (id delegate in delegateTargets) {
                        [self removeSomeDelegateWithObject:delegate];
                    }
                    for (id delegate in delegateTargets) {
                        
                        [self.weakRefTargets addPointer:(__bridge void *)delegate];
                    }
                    
                }
                    break;
                default:
                    break;
            }
        }
 
    }
    
}
-(void)setDelegateTargetsType:(MuiltipleProxyManagerDelegateTargetsType)delegateTargetsType{
    if (_delegateTargetsType != delegateTargetsType) {
        switch (_delegateTargetsType) {
             case MuiltipleProxyManagerDelegateTargetsTypeDictionary:
                for (int i = 0 ; i < self.weakRefTargets.count; i ++) {
                [self.weakRefTargets removePointerAtIndex:i];
                }
              
                break;
             case MuiltipleProxyManagerDelegateTargetsTypeArray:
                [self.delegateRefTargets removeAllObjects];
                break;
            default:
                break;
        }
    }
    _delegateTargetsType = delegateTargetsType;
    if (_delegateTargets == nil) {
        return;
    }
    [self setDelegateTargets:_delegateTargets];
}

-(void)removeSomeDelegateWithAnObject:(id)delegate{
    if (self.delegateRefTargets.count !=0 && delegate) {
        NSDictionary *dic = [self.delegateRefTargets dictionaryRepresentation];
        for (id key in dic) {
            id value = [dic objectForKey:key];
            if ([delegate isEqual:value]) {
                [self.delegateRefTargets removeObjectForKey:key];
            }else if ([delegate isKindOfClass:[value class]]) {
                [self.delegateRefTargets removeObjectForKey:key];
            }else if (value == nil || [value isKindOfClass:[NSNull class]]){
               [self.delegateRefTargets removeObjectForKey:key];
            }
        }
    }
    
}
-(void)removeSomeDelegateWithObject:(id)delegate{
    if (self.weakRefTargets && self.weakRefTargets.count!=0 && delegate) {
        NSArray *weakTargets = [self.weakRefTargets allObjects];
        for (int i = 0; i < weakTargets.count; i++) {
            id pDelegate = [weakTargets objectAtIndex:i];
            if ([delegate isEqual:pDelegate]) {
                [self.weakRefTargets removePointerAtIndex:i];
            }else if ([delegate isKindOfClass:[pDelegate class]]){
                [self.weakRefTargets  removePointerAtIndex:i];
            }
        }
        [self.weakRefTargets compact];
    }
}
-(void)removeAllDelegates{
    switch (_delegateTargetsType) {
        case MuiltipleProxyManagerDelegateTargetsTypeArray:
        {
            for (int i =0 ; i <self.weakRefTargets.count; i++) {
                [self.weakRefTargets removePointerAtIndex:i];
            }
             [self.weakRefTargets compact];
            _delegateTargets = [self.weakRefTargets allObjects];
        }
            break;
         case MuiltipleProxyManagerDelegateTargetsTypeDictionary:
        {
            [self.delegateRefTargets removeAllObjects];
            _delegateTargets = [self.delegateRefTargets dictionaryRepresentation];
        }
            break;
        default:
            break;
    }
}
-(void)removeDelegate:(id)object{
    @synchronized(self) {
        if (object) {
            switch (_delegateTargetsType) {
                case MuiltipleProxyManagerDelegateTargetsTypeDictionary:
                    [self removeSomeDelegateWithAnObject:object];
                    break;
                case MuiltipleProxyManagerDelegateTargetsTypeArray:
                    [self removeSomeDelegateWithObject:object];
                    break;
                default:
                    break;
            }
 
        }
    }
}
-(void)removeDelegates:(id)objects{
    @synchronized(self) {
        if (objects) {
            if ([objects isKindOfClass:[NSArray class]]) {
                switch (_delegateTargetsType) {
                    case MuiltipleProxyManagerDelegateTargetsTypeDictionary:
                    {
                        [objects enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                            [self removeSomeDelegateWithAnObject:obj];
                        }];
                       
                        _delegateTargets = (id)[self.delegateRefTargets dictionaryRepresentation];
                    }
                        break;
                    case MuiltipleProxyManagerDelegateTargetsTypeArray:
                    {
                        [objects enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                            [self removeSomeDelegateWithObject:obj];
                            
                        }];
                      
                        _delegateTargets = (id)[self.weakRefTargets allObjects];
                    }
                        break;
                    default:
                        break;
                }
                
            }else if ([objects isKindOfClass:[NSDictionary class]]){
                switch (_delegateTargetsType) {
                    case MuiltipleProxyManagerDelegateTargetsTypeArray:
                    {
                        [objects enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
                            [self removeSomeDelegateWithObject:obj];
                            
                        }];
                      
                        _delegateTargets = (id)[self.weakRefTargets allObjects];
                    }
                        break;
                    case MuiltipleProxyManagerDelegateTargetsTypeDictionary:
                    {
                        [objects enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
                            [self removeSomeDelegateWithAnObject:obj];
                        }];
                        
                        _delegateTargets = (id)[self.delegateRefTargets dictionaryRepresentation];
                    }
                        break;
                    default:
                        break;
                }
            }
            
        }
    }
}
-(void)addDelegate:(id)object andRefreshDelegateBlock:(MuiltipleProxyManagerRefreshDelegateBlock)block{
    @synchronized(self) {
        if (object) {
            switch (_delegateTargetsType) {
                case MuiltipleProxyManagerDelegateTargetsTypeDictionary:
                {
                    id key = [NSString stringWithFormat:@"%p",object];
                    [self removeSomeDelegateWithAnObject:object];
                    [self.delegateRefTargets setObject:object forKey:key];
                     _delegateTargets = (id)[self.delegateRefTargets dictionaryRepresentation];
                }
                    break;
                case MuiltipleProxyManagerDelegateTargetsTypeArray:
                {
                    [self removeSomeDelegateWithObject:object];
                    [self.weakRefTargets addPointer:(__bridge void *)object];
                    _delegateTargets = (id)[self.weakRefTargets allObjects];
                }
                    break;
                default:
                    break;
            }
            if(block)block();
        }

    }
    
}
-(void)addDelegates:(id)objects andRefreshDelegateBlock:(MuiltipleProxyManagerRefreshDelegateBlock)block{
    @synchronized(self) {
        if (objects) {
            if ([objects isKindOfClass:[NSArray class]]) {
                switch (_delegateTargetsType) {
                    case MuiltipleProxyManagerDelegateTargetsTypeDictionary:
                    {
                        [objects enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                            [self removeSomeDelegateWithAnObject:obj];
                          
                        }];
                        [objects enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                            id key = [NSString stringWithFormat:@"%p",obj];
                            [self.delegateRefTargets setObject:obj forKey:key];
                        }];
                         _delegateTargets = (id)[self.delegateRefTargets dictionaryRepresentation];
                    }
                        break;
                    case MuiltipleProxyManagerDelegateTargetsTypeArray:
                    {
                        [objects enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                            [self removeSomeDelegateWithObject:obj];
                          
                        }];
                        [objects enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                           
                            [self.weakRefTargets addPointer:(__bridge void *)obj];
                        }];
                        _delegateTargets = (id)[self.weakRefTargets allObjects];
                    }
                        break;
                    default:
                        break;
                }
               
            }else if ([objects isKindOfClass:[NSDictionary class]]){
                switch (_delegateTargetsType) {
                    case MuiltipleProxyManagerDelegateTargetsTypeArray:
                    {
                      [objects enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
                          [self removeSomeDelegateWithObject:obj];
                       
                      }];
                      [objects enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
                        
                            [self.weakRefTargets addPointer:(__bridge void *)obj];
                       }];
                        
                        _delegateTargets = (id)[self.weakRefTargets allObjects];
                    }
                        break;
                    case MuiltipleProxyManagerDelegateTargetsTypeDictionary:
                    {
                        [objects enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
                            [self removeSomeDelegateWithAnObject:obj];
                        }];
                        
                        [objects enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
                            [self.delegateRefTargets setObject:obj forKey:key];
                        }];
                        
                        _delegateTargets = (id)[self.delegateRefTargets dictionaryRepresentation];
                    }
                        break;
                    default:
                        break;
                }
            }
         
            if (block) {
           
                block();
            }
        }
    }
}

- (BOOL)respondsToSelector:(SEL)aSelector{
    if ([super respondsToSelector:aSelector]) {
        return YES;
    }
    switch (_delegateTargetsType) {
     
        case MuiltipleProxyManagerDelegateTargetsTypeDictionary:
            for (id key in self.delegateRefTargets) {
                id obj = [self.delegateRefTargets objectForKey:key];
                if ([obj respondsToSelector:aSelector]) {
                    return YES;
                }
            }
            break;
            
        case MuiltipleProxyManagerDelegateTargetsTypeArray:
            for (id target in self.weakRefTargets) {
                if ([target respondsToSelector:aSelector]) {
                    return YES;
                }
            }
            break;
            
        default:
            break;
    }
  
    
    return NO;
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector{
    NSMethodSignature *sig = [super methodSignatureForSelector:aSelector];
    if (!sig) {
        switch (_delegateTargetsType) {
            case MuiltipleProxyManagerDelegateTargetsTypeArray:
                for (id target in self.weakRefTargets) {
                    if ((sig = [target methodSignatureForSelector:aSelector])) {
                        break;
                    }
                }
                break;
            case MuiltipleProxyManagerDelegateTargetsTypeDictionary:
                for (id key in self.delegateRefTargets) {
                    sig = [[self.delegateRefTargets objectForKey:key] methodSignatureForSelector:aSelector];
                    if (sig) {
                        break;
                    }
                }
                break;
            default:
                break;
        }
       
    }
    
    return sig;
}


- (void)forwardInvocation:(NSInvocation *)anInvocation{
    switch (_delegateTargetsType) {
        case MuiltipleProxyManagerDelegateTargetsTypeDictionary:
            for (id key in self.delegateRefTargets) {
                id target = [self.delegateRefTargets objectForKey:key];
                if ([target respondsToSelector:anInvocation.selector]) {
                    [anInvocation invokeWithTarget:target];
                }
            }
            break;
        case MuiltipleProxyManagerDelegateTargetsTypeArray:
            for (id target in self.weakRefTargets) {
                if ([target respondsToSelector:anInvocation.selector]) {
                    [anInvocation invokeWithTarget:target];
                }
            }
            break;
        default:
            break;
    }
   
}

@end
