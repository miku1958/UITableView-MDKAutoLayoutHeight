//
//  MDKAutoLayoutHeightConstContent.h
//  UITableView+MDKAutoLayoutHeight
//
//  Created by mikun on 2018/6/8.
//  Copyright © 2018年 mdk. All rights reserved.
//

#ifndef MDKAutoLayoutHeightConstContent_h
#define MDKAutoLayoutHeightConstContent_h

typedef NSMutableDictionary<id<NSCopying>,NSMutableDictionary<id<NSCopying>,NSNumber *> *> MDKHeightCacheDic;

@interface MDKAutoLayoutHeight()
@property (nonatomic,weak)__kindof UITableView *table;
@property (nonatomic,strong)NSDictionary *lastCachedDecisionView;
@property (nonatomic,strong)MDKHeightCacheDic *cellHeightCacheDic;
- (void)removeAllCacheWithDisk:(BOOL)withDisk;
@end
@interface MDKAutoLayoutHeight(cache)
- (NSDictionary *)getHeightCacheForKey:(NSString *)cellClass;
- (void)diskCacheHeights:(NSDictionary *)heights forKey:(NSString *)cellClass;
- (void)removeAllDiskCache;
@end
#endif /* MDKAutoLayoutHeightConstContent_h */
