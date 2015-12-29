//
//  ViewController.m
//  MultipleDelegate
//
//  Created by chengbin on 15/12/28.
//  Copyright © 2015年 chengbin. All rights reserved.
//

#import "ViewController.h"
#import "Behavior.h"
#import "MuiltipleProxyManager.h"
#import "Behavior2.h"
@interface ViewController ()<UIScrollViewDelegate>
{
    UIScrollView *scrollView;
}
@property (nonatomic, strong)Behavior2 *be2;
@property (nonatomic, strong)MuiltipleProxyManager *proxy;
@property (nonatomic, strong)Behavior *be;
@end

@implementation ViewController
@synthesize proxy;
@synthesize be;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view, typically from a nib.
    [self.view setBackgroundColor:[UIColor whiteColor]];
    scrollView =[[UIScrollView alloc]initWithFrame:self.view.frame];
    scrollView.contentSize = CGSizeMake(self.view.bounds.size.width, self.view.bounds.size.height *2);
    [self.view addSubview:scrollView];
    proxy = [MuiltipleProxyManager manager];
    be = [[Behavior alloc]init];
    scrollView.delegate = (id)proxy;

   // proxy.delegateTargets = [NSDictionary dictionaryWithObjectsAndKeys:self,[NSString stringWithFormat:@"%p",self],be,[NSString stringWithFormat:@"%p",be],nil];
    proxy.delegateTargetsType = MuiltipleProxyManagerDelegateTargetsTypeDictionary;

    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.backgroundColor =[UIColor redColor];
    [button addTarget:self action:@selector(add:) forControlEvents:UIControlEventTouchUpInside];
    button.frame = CGRectMake(30, 100, 40, 40);
    [self.view addSubview:button];
    
    UIButton *button1 = [UIButton buttonWithType:UIButtonTypeSystem];
    button1.backgroundColor =[UIColor redColor];
    [button1 addTarget:self action:@selector(remove:) forControlEvents:UIControlEventTouchUpInside];
    button1.frame = CGRectMake(30, 300, 40, 40);
    [self.view addSubview:button1];
}

- (void)remove:(id)sender{
    [proxy removeDelegate:_be2];
    _be2 = nil;
}
- (void)add:(id)sender{
    _be2 = [[Behavior2 alloc]init];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:self,[NSString stringWithFormat:@"%p",self],_be2,[NSString stringWithFormat:@"%p",_be2],nil];
    __block MuiltipleProxyManager *__weak weakS = proxy;
    [weakS addDelegates:dic andRefreshDelegateBlock:^{
        scrollView.delegate = nil;//必须这样
        scrollView.delegate = (id)proxy;
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    NSLog(@"%s",__PRETTY_FUNCTION__);
}
@end
