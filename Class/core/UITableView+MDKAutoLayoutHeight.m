//
//  UITableView+AutoLayoutHeight.m
//  mdk
//
//  Created by mikun on 2018/5/16.
//  Copyright © 2018年 mdk. All rights reserved.
//

#import "UITableView+MDKAutoLayoutHeight.h"
#import "MDKAutoLayoutHeightConstContent.h"
#import <objc/message.h>
#import <objc/runtime.h>



static NSMutableDictionary<NSString *,NSString *> *MDKAutoLayoutHeight_decisionViewsDic;
static MDKHeightCacheDic *MDKAutoLayoutHeight_cellHeightCacheDic;
static NSLock *MDKAutoLayoutHeightMemoryWarningLock;

@implementation UITableView (_MDKAutoLayoutHeight)
-(MDKAutoLayoutHeight *)autoLayoutHeight{
	@synchronized(self){
		MDKAutoLayoutHeight *autoHeight = objc_getAssociatedObject(self, @selector(autoLayoutHeight));
		if (!autoHeight) {
			autoHeight = [MDKAutoLayoutHeight new];
			autoHeight.table = self;

			NSString *objectName = @"autoLayoutHeight";
			[self willChangeValueForKey:objectName];

			objc_setAssociatedObject(self, @selector(autoLayoutHeight),
									 autoHeight, OBJC_ASSOCIATION_RETAIN_NONATOMIC);

			[self didChangeValueForKey:objectName];
		}

		return autoHeight;
	}
}
-(NSString *)existingViewControllerClassName{
	NSString *existing = objc_getAssociatedObject(self, @selector(existingViewControllerClassName));
	if (!existing) {
		UIViewController *existingCtr = self.nextResponder;
		while (existingCtr) {
			if ([existingCtr isKindOfClass:UIViewController.class]) {
				existing = NSStringFromClass(existingCtr.class);
				break;
			}
			existingCtr = existingCtr.nextResponder;
		}

		NSString *objectName = @"existingViewControllerClassName";
		[self willChangeValueForKey:objectName];

		objc_setAssociatedObject(self, @selector(existingViewControllerClassName),
								 existing, OBJC_ASSOCIATION_COPY);

		[self didChangeValueForKey:objectName];
	}

	return existing;
}
- (NSMutableDictionary <NSString *, NSMutableSet<NSNumber *> *>*)MDKAutoLayoutFastHeightCache{
	id cache = objc_getAssociatedObject(self, @selector(MDKAutoLayoutFastHeightCache));
	if (!cache) {
		cache = [NSMutableDictionary dictionary];

		NSString *objectName = @"MDKAutoLayoutFastHeightCache";
		[self willChangeValueForKey:objectName];

		objc_setAssociatedObject(self, @selector(MDKAutoLayoutFastHeightCache),
								 cache, OBJC_ASSOCIATION_RETAIN);

		[self didChangeValueForKey:objectName];
	}

	return cache;
}
@end

@implementation MDKAutoLayoutHeight
+(void)load{//ensure these object had initialize, so I put them in +load but not +initialize
	if (MDKAutoLayoutHeight_cellHeightCacheDic) { return; }
	MDKAutoLayoutHeight_cellHeightCacheDic = @{}.mutableCopy;
	MDKAutoLayoutHeight_decisionViewsDic = @{}.mutableCopy;
	MDKAutoLayoutHeightMemoryWarningLock = [[NSLock alloc]init];
}
+ (void)initialize{

}
- (instancetype)init{
	self = [super init];
	if (self) {
		_cellHeightCacheDic = @{}.mutableCopy;
		[NSNotificationCenter.defaultCenter addObserver:self selector:@selector(handleMemoryWarning) name:UIApplicationDidReceiveMemoryWarningNotification object:nil];
	}
	return self;
}

+(void)registerHeight:(Class)cellClass _decisionView:(NSString *)decisionView{
	if ([decisionView isEqualToString:@"contentView"]) { return; }
	if (!MDKAutoLayoutHeight_decisionViewsDic) {
		[self load];
	}
	MDKAutoLayoutHeight_decisionViewsDic[NSStringFromClass(cellClass)] = decisionView;
}



- (CGFloat)heightForRowAtIndexPath:(NSIndexPath *)indexPath cacheKey:(NSString *)_cacheKey{
	if (_cacheKey.length && _table.MDKAutoLayoutFastHeightCache[_cacheKey].count == 1) {
		return _table.MDKAutoLayoutFastHeightCache[_cacheKey].anyObject.doubleValue;
	}
	UITableViewCell<MDKTableviewCellCacheHeightDelegate> *cell = (id)[_table.dataSource tableView:_table cellForRowAtIndexPath:indexPath];

	NSString *cellClass = NSStringFromClass(cell.class);
	NSString *decisionVIew = _lastCachedDecisionView[cellClass];
	if (!decisionVIew) {
		decisionVIew = MDKAutoLayoutHeight_decisionViewsDic[cellClass];
		if (decisionVIew) {
			_lastCachedDecisionView = @{cellClass:decisionVIew};
		}
	}

	NSArray *cellContetntWidthCons;
	CGFloat height = 0;

	NSString *cacheKey;
	if (cell) {
#ifdef DEBUG
		NSAssert(cell.reuseIdentifier, @"please use UITableViewCell reuse function");
#endif
		NSMutableDictionary<NSString *,NSMutableArray *> *_reusableTableCells = [_table valueForKey:@"_reusableTableCells"];
		if (!_reusableTableCells[cell.reuseIdentifier]) {
			_reusableTableCells[cell.reuseIdentifier] = @[cell].mutableCopy;
		}else if (![_reusableTableCells[cell.reuseIdentifier] containsObject:cell]) {
			[_reusableTableCells[cell.reuseIdentifier] addObject:cell];
		}
		[UIView performWithoutAnimation:^{// remove Implicit animation after iOS 11
			[CATransaction begin];
			[CATransaction setDisableActions:YES];

			[_table layoutIfNeeded];

			[CATransaction commit];

		}];


		if ([cell.class isEqual:UITableViewCell.class]) {
			return [cell sizeThatFits:CGSizeMake(_table.frame.size.width, MAXFLOAT)].height;
		}


		cacheKey = _cacheKey;

		if (cacheKey.length) {
			cacheKey = [NSString stringWithFormat:@"%@-%@-%@-%@",_table.existingViewControllerClassName,@(_table.frame.size.width), cellClass ,cacheKey];
			if (!_cellHeightCacheDic[cellClass]) {//try to get cache from RAM
				_cellHeightCacheDic[cellClass] = MDKAutoLayoutHeight_cellHeightCacheDic[cellClass];
				if (!_cellHeightCacheDic[cellClass]) {//try to get cache from Disk
					if ([self respondsToSelector:@selector(getHeightCacheForKey)]) {
						_cellHeightCacheDic[cellClass] = (id)[self getHeightCacheForKey:cellClass];
					}
				}
			}
			NSNumber *height = _cellHeightCacheDic[cellClass][cacheKey];
			if (height) {
				if (!_table.MDKAutoLayoutFastHeightCache[_cacheKey]) {
					_table.MDKAutoLayoutFastHeightCache[_cacheKey] = [NSMutableSet set];
				}
				[_table.MDKAutoLayoutFastHeightCache[_cacheKey] addObject:height];
				return height.doubleValue;
			}
		}


		CGRect cellFrame = (CGRect){{0, 0}, _table.bounds.size.width, _table.bounds.size.height};
		if (cellFrame.size.width == 0) {
			cellFrame.size.width = UIScreen.mainScreen.bounds.size.width;
#ifdef DEBUG
			NSLog(@"%@ , %@",
				  @"if you want to use RAM cache , table may need width>0",
				  @"auto fix width to UIScreen.mainScreen.bounds.size.width");
#endif
		}
		if (cellFrame.size.height == 0) {
			cellFrame.size.height = UIScreen.mainScreen.bounds.size.height;
#ifdef DEBUG
			NSLog(@"%@ , %@",
				  @"if you want to use RAM cache , table may need height>0",
				  @"auto fix height to UIScreen.mainScreen.bounds.size.height");
#endif
		}
		cell.frame = cellFrame;

		if (decisionVIew.length) {
			[cell.contentView layoutIfNeeded];
			[cell layoutSubviews];
		}else{
			[cell layoutSubviews];//prevent handle contentView in layoutSuvies

			/*
			 this code come from UITableView+FDTemplateLayoutCell ,they are do well than me
			 */
			CGFloat contentViewWidth = CGRectGetWidth(_table.frame);

			CGFloat rightSystemViewsWidth = 0.0;
			for (UIView *view in _table.subviews) {
				if ([view isKindOfClass:NSClassFromString(@"UITableViewIndex")]) {
					rightSystemViewsWidth = CGRectGetWidth(view.frame);
					break;
				}
			}

			if (cell.accessoryView) {
				rightSystemViewsWidth += 16 + CGRectGetWidth(cell.accessoryView.frame);
			} else {
				static const CGFloat systemAccessoryWidths[] = {
					[UITableViewCellAccessoryNone] = 0,
					[UITableViewCellAccessoryDisclosureIndicator] = 34,
					[UITableViewCellAccessoryDetailDisclosureButton] = 68,
					[UITableViewCellAccessoryCheckmark] = 40,
					[UITableViewCellAccessoryDetailButton] = 48
				};
				rightSystemViewsWidth += systemAccessoryWidths[cell.accessoryType];
			}

			if (rightSystemViewsWidth > 0 && [UIScreen mainScreen].scale >= 3 && [UIScreen mainScreen].bounds.size.width >= 414) {
				rightSystemViewsWidth += 4;
			}

			contentViewWidth -= rightSystemViewsWidth;

			/* reference finish*/


			NSDictionary *metrics = @{
									  @"width" : @(contentViewWidth).description,
									  };
			NSDictionary *views = @{
									@"contentView":cell.contentView,
									};
			cellContetntWidthCons = [NSLayoutConstraint constraintsWithVisualFormat:@"H:[contentView(width)]" options:NSLayoutFormatAlignAllBaseline metrics:metrics views:views];
			[cell.contentView addConstraints:cellContetntWidthCons];
		}
	}

	if (decisionVIew.length) {
		UIView *view = [cell valueForKey:decisionVIew];
		height = CGRectGetMaxY(view.frame) + cell.contentView.frame.origin.y;
	}

	if (height<1) {
		height = [cell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height + cell.contentView.frame.origin.y;
	}
	if (height<1) {
		height = [cell intrinsicContentSize].height;
	}

	if (_table.separatorStyle != UITableViewCellSeparatorStyleNone) {
		height += 1.0 / UIScreen.mainScreen.scale;
	}


	if (cacheKey.length) {
		id heightObj = @(height);
		if (!_cellHeightCacheDic[cellClass]) {
			_cellHeightCacheDic[cellClass] = @{}.mutableCopy;
		}
		_cellHeightCacheDic[cellClass][cacheKey] = heightObj;

		if (_cacheKey.length) {
			if (!_table.MDKAutoLayoutFastHeightCache[_cacheKey]) {
				_table.MDKAutoLayoutFastHeightCache[_cacheKey] = [NSMutableSet set];
			}
			[_table.MDKAutoLayoutFastHeightCache[_cacheKey] addObject:heightObj];
		}
	}

	if (cellContetntWidthCons) {
		[cell.contentView removeConstraints:cellContetntWidthCons];
	}
	[cell prepareForReuse];
	return height;

}
- (void)removeAllCacheWithDisk:(BOOL)withDisk{
	[_cellHeightCacheDic removeAllObjects];

	if ([MDKAutoLayoutHeightMemoryWarningLock tryLock]) {
		[MDKAutoLayoutHeight_cellHeightCacheDic removeAllObjects];
		if ([self respondsToSelector:@selector(removeAllDiskCache)]) {
			[self removeAllDiskCache];
		}
		[MDKAutoLayoutHeightMemoryWarningLock unlock];
	}
}
- (void)handleMemoryWarning{
	@autoreleasepool{
		[self removeAllCacheWithDisk:NO];
	}
}

-(void)dealloc{
	[_cellHeightCacheDic enumerateKeysAndObjectsUsingBlock:^(NSObject<NSCopying> *key, NSMutableDictionary<id<NSCopying> ,NSNumber *> *obj, BOOL *stop) {
		MDKAutoLayoutHeight_cellHeightCacheDic[key] = obj;
		if ([self respondsToSelector:@selector(diskCacheHeights:forKey:)]) {
			[self diskCacheHeights:obj forKey:[key description]];
		}
	}];

	[NSNotificationCenter.defaultCenter removeObserver:self];
}
@end




