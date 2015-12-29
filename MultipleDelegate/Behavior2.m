//
//  Behavior2.m
//  MultipleDelegate
//
//  Created by chengbin on 15/12/28.
//  Copyright © 2015年 chengbin. All rights reserved.
//

#import "Behavior2.h"

@implementation Behavior2

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    NSLog(@"%s",__PRETTY_FUNCTION__);

}
- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView{
    NSLog(@"%s",__PRETTY_FUNCTION__);
}
@end
