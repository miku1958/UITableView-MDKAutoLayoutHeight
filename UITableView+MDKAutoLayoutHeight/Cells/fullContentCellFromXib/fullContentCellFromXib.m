//
//  fullContentCellFromXib.m
//  UITableView+MDKAutoLayoutHeight
//
//  Created by mikun on 2018/6/8.
//  Copyright © 2018年 mdk. All rights reserved.
//

#import "fullContentCellFromXib.h"
#import "UITableView+MDKAutoLayoutHeightDiskCache.h"
@interface fullContentCellFromXib()<MDKTableviewCellCacheHeightDelegate>

@end
@implementation fullContentCellFromXib

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(NSString *)MDKModelHash{
	return NSStringFromClass(self.class);
}
@end
