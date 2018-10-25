//
//  MyTableView.h
//  ScrollToTable
//
//  Created by  Tmac on 2017/11/8.
//  Copyright © 2017年 Tmac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyTableViewCell.h"
@class MyTableView;

@protocol MyTableViewDelegate <NSObject>

- (NSInteger)numOfTableView:(MyTableView *)tableView;

@optional
- (void)MyTableView:(MyTableView *)tableView willDisplayCell:(MyTableViewCell *)cell forIndex:(NSInteger)index;

- (void)MyTableView:(MyTableView *)tableView didSelectedCell:(MyTableViewCell *)cell forIndex:(NSInteger)index;
@end

@interface MyTableView : UIScrollView

@property(nonatomic,weak) id<MyTableViewDelegate> myDelegate;
@property(nonatomic) CGFloat cellHeight;
@end
