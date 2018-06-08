//
//  partAutolayoutOfCellFromXib.m
//  UITableView+MDKAutoLayoutHeight
//
//  Created by mikun on 2018/6/8.
//  Copyright © 2018年 mdk. All rights reserved.
//

#import "partAutolayoutOfCellFromXib.h"
#import "UITableView+MDKAutoLayoutHeightDiskCache.h"
@interface partAutolayoutOfCellFromXib()<MDKTableviewCellCacheHeightDelegate>

@end
@implementation partAutolayoutOfCellFromXib
+(void)initialize{
	MDKAutoLayoutRegisterHeight(self, bottomView)
}
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
