//
//  UITableView+MDKAutoLayoutHeightCache.h
//  UITableView+MDKAutoLayoutHeight
//
//  Created by mikun on 2018/6/8.
//  Copyright © 2018年 mdk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UITableView+MDKAutoLayoutHeight.h"

@interface MDKAutoLayoutHeight(cacheMethod)
- (void)updateDiskCache;
- (void)removeCacheFor:(Class)cell;
- (void)removeAllCache;
@end
