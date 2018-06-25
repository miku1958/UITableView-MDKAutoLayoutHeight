//
//  UITableView+MDKAutoLayoutHeightCache.m
//  UITableView+MDKAutoLayoutHeight
//
//  Created by mikun on 2018/6/8.
//  Copyright © 2018年 mdk. All rights reserved.
//

#import "UITableView+MDKAutoLayoutHeightDiskCache.h"
#import "UITableView+MDKAutoLayoutHeight.h"
#import "MDKAutoLayoutHeightConstContent.h"
#import <YYCache/YYCache.h>

static YYCache *MDKAutoLayoutHeightDiskCache;


@implementation MDKAutoLayoutHeight(cache)
+(void)initialize{
	MDKAutoLayoutHeightDiskCache = [YYCache cacheWithName:@"MDKAutoLayoutHeights"];
}
- (NSDictionary *)getHeightCacheForKey:(NSString *)cellClass{
	return (id)[MDKAutoLayoutHeightDiskCache objectForKey:cellClass];
}
- (void)diskCacheHeights:(NSDictionary *)heights forKey:(NSString *)cellClass{
	[MDKAutoLayoutHeightDiskCache setObject:heights forKey:cellClass];
}
- (void)updateDiskCache{
	[self.cellHeightCacheDic enumerateKeysAndObjectsUsingBlock:^(NSObject<NSCopying> *key, NSMutableDictionary<id<NSCopying> ,NSNumber *> *obj, BOOL *stop) {
		[self diskCacheHeights:obj forKey:[key description]];
	}];
}
- (void)removeCacheFor:(Class)cell{
	NSString *cellClass = NSStringFromClass(cell);
	self.cellHeightCacheDic[cellClass] = nil;
	[MDKAutoLayoutHeightDiskCache removeObjectForKey:cellClass];
}
- (void)removeAllCache{
	[self removeAllCacheWithDisk:YES];
}
- (void)removeAllDiskCache{
	[MDKAutoLayoutHeightDiskCache removeAllObjects];
}
@end
