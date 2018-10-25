//
//  MyTableViewCell.m
//  ScrollToTable
//
//  Created by  Tmac on 2017/11/8.
//  Copyright © 2017年 Tmac. All rights reserved.
//

#import "MyTableViewCell.h"

@implementation MyTableViewCell

- (id)init
{
    if(self = [super init])
    {
        [self createView];
    }
    
    return self;
}

- (void)createView
{
    _titleLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height)];
    _titleLab.font = [UIFont systemFontOfSize:16];
    [self addSubview:_titleLab];
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    
    _titleLab.frame = CGRectMake(16, 0, self.bounds.size.width, self.bounds.size.height);
}

@end
