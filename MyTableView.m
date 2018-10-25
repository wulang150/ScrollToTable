//
//  MyTableView.m
//  ScrollToTable
//
//  Created by  Tmac on 2017/11/8.
//  Copyright © 2017年 Tmac. All rights reserved.
//

#import "MyTableView.h"

@interface MyTableView()
<UIScrollViewDelegate>
{
    NSMutableSet *_visiblePages, *_recycledPages;
    NSInteger firstIndex;
    NSInteger lastIndex;
}
@end

@implementation MyTableView

- (id)initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame])
    {
        [self createView];
    }
    
    return self;
}

- (void)createView
{
    _visiblePages = [NSMutableSet new];
    _recycledPages = [NSMutableSet new];
    self.cellHeight = 44;
    self.delegate = self;
    self.showsVerticalScrollIndicator = NO;
    self.showsHorizontalScrollIndicator = NO;
    
    //点击事件
    UITapGestureRecognizer *singleTap =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(tap:)];
    singleTap.numberOfTapsRequired = 1;
    singleTap.numberOfTouchesRequired = 1;
    [self addGestureRecognizer:singleTap];
}

- (void)tap:(UITapGestureRecognizer *)sender
{
    CGPoint point = [sender locationInView:self];
//    NSLog(@"handleSingleTap!pointx:%f,y:%f",point.x,point.y);
    
    NSInteger index = (NSInteger)floorf(point.y/_cellHeight);
    if(index<firstIndex)
        index = firstIndex;
    if(index>lastIndex)
        index = lastIndex;
    
    if([self.myDelegate respondsToSelector:@selector(MyTableView:didSelectedCell:forIndex:)])
    {
        MyTableViewCell *cell = [self gainCellByIndex:index];
        [self.myDelegate MyTableView:self didSelectedCell:cell forIndex:index];
    }
}

- (void)setMyDelegate:(id<MyTableViewDelegate>)myDelegate
{
    _myDelegate = myDelegate;
    
    self.contentSize = CGSizeMake(self.bounds.size.width, _cellHeight*[self.myDelegate numOfTableView:self]);
}

- (void)willMoveToSuperview:(UIView *)newSuperview
{
    NSLog(@"willMoveToSuperview");
    [self tilePages];
}

//复用函数
- (void)tilePages
{
    NSInteger num = [self.myDelegate numOfTableView:self];
    firstIndex = (NSInteger)floorf(CGRectGetMinY(self.bounds)/_cellHeight);
    lastIndex = (NSInteger)floorf((CGRectGetMaxY(self.bounds)-1)/_cellHeight);
    if(firstIndex<0)
        firstIndex = 0;
    if(firstIndex>num-1)
        firstIndex = num - 1;
    if(lastIndex<0)
        lastIndex = 0;
    if(lastIndex>num-1)
        lastIndex = num - 1;
    
    //回收
    for(MyTableViewCell *page in _visiblePages)
    {
        if(page.index<firstIndex||page.index>lastIndex)
        {
            [_recycledPages addObject:page];
            [page removeFromSuperview];
        }
    }
    
    [_visiblePages minusSet:_recycledPages];
    while (_recycledPages.count > 2) // Only keep 2 recycled pages
        [_recycledPages removeObject:[_recycledPages anyObject]];
    
    //添加新的page
    for(NSInteger index = firstIndex;index<=lastIndex;index++)
    {
        //如果不在显示队列中，就加入新的cell
        if(![self isDisplayingPageForIndex:index])
        {
            MyTableViewCell *page = [self dequeueRecyclePage];
            if(!page)
            {
                page = [[MyTableViewCell alloc] init];
                NSLog(@"创建新的page%ld",index);
            }
            [_visiblePages addObject:page];
            //重新设置page的位置
            [self configurePage:page forIndex:index];
            
            if([self.myDelegate respondsToSelector:@selector(MyTableView:willDisplayCell:forIndex:)])
            {
                [self.myDelegate MyTableView:self willDisplayCell:page forIndex:index];
            }
            
            [self addSubview:page];
        }
    }
    
}

- (MyTableViewCell *)dequeueRecyclePage
{
    MyTableViewCell *page = [_recycledPages anyObject];
    if(page)
        [_recycledPages removeObject:page];
    
    return page;
}
- (BOOL)isDisplayingPageForIndex:(NSInteger)index {
    for (MyTableViewCell *page in _visiblePages)
        if (page.index == index) return YES;
    return NO;
}

- (void)configurePage:(MyTableViewCell *)page forIndex:(NSInteger)index {
    page.frame = CGRectMake(0, _cellHeight*index, self.bounds.size.width, _cellHeight);
    page.index = index;
}

- (MyTableViewCell *)gainCellByIndex:(NSInteger)index
{
    for(MyTableViewCell *page in _visiblePages)
    {
        if(page.index==index)
            return page;
    }
    
    return nil;
}

#pragma -mark UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
//    NSLog(@"scrollView.y = %f",scrollView.contentOffset.y);
    
    [self tilePages];
}
@end
