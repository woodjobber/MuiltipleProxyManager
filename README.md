# MuiltipleProxyManager
##多重代理实现
###什么是多重代理？
多重代理即代理集，是指用一个对象去实现多个对象的不同功能。普通（传统）的代理的实现方式，都是一对一的，而多重代理是一对多的。
###多重代理的原理是什么？
代理集的原理是通过Object-C消息转发机制实现。我们都知道，在OC中，调用一个对象的方法，其实是给这个对象发送一条消息，当这条消息（或者这个方法）在它的类中，没有找到这个方法，则继续向父类寻找，一旦找到这个方法，就去执行对应的方法实现IMP，如果，还是没有找到，就会去执行其他步骤，
step：1，动态方法解析，如果你是动态的实现了这个方法，就不会去执行下面的步骤即2，否则，执行步骤2；2，消息转发，又要分两小步；具体见图片，
![image](https://github.com/woodjobber/MuiltipleProxyManager/blob/master/消息转发.png)

###怎样使用'MuiltipleProxyManager'中的方法

`+ (MuiltipleProxyManager *)manager` 是一个单例对象，

`-(void)addDelegate:(id)object andRefreshDelegateBlock:(MuiltipleProxyManagerRefreshDelegateBlock)block;`增加一个对象到代理集中，如果这个对象，在代理集中存在，或者是`[object isKindOfClass:[value class]]`为真，将会移除代理集中的对象，把这个对象添加进去。始终让代理集中存储最新的对象。

`-(void)addDelegates:(id)objects andRefreshDelegateBlock:(MuiltipleProxyManagerRefreshDelegateBlock)block;`增加一组对象到代理集中，'objects'可以是`NSArray`,`NSMutableArray`,`NSDictionary`,`NSMutableDictionary`,注意，如果是 `字典`，键值 必须是 `id key = [NSString stringWithFormat:@"%p",obj];`

`-(void)removeDelegate:(id)object;`  从代理集中移除一个object，

`-(void)removeDelegates:(id)objects;` 从代理集中移除多个objects

`-(void)removeAllDelegates;` 从代理集中全部移除对象。

默认的存储方式是`MuiltipleProxyManagerDelegateTargetsTypeArray`,如果要改变存储方式，可以通过设置属性'delegateTargetsType'.
注意，在向集合中添加对象时，需要更新代理，拿本例说明,

   __block MuiltipleProxyManager *__weak weakProxy = proxy;

    [weakProxy addDelegates:dic andRefreshDelegateBlock:^{
        scrollView.delegate = nil;//必须这样，不知道原因,否者有bugs
        scrollView.delegate = (id)weakProxy;
    }];
## 总结

如果有什么错误，请联系作者 woodjobber@outlook.com
