//
//  UITableView+AutoLayoutHeight.h
//  mdk
//
//  Created by mikun on 2018/5/16.
//  Copyright © 2018年 mdk. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol MDKTableviewCellCacheHeightDelegate
@property (nonatomic,readonly)NSString *MDKModelHash;
@end

#define MDKAutoLayoutRegisterHeight(CellClass,decisionView)\
[[CellClass new] decisionView];\
[MDKAutoLayoutHeight registerHeight:[CellClass class]  _decisionView: @#decisionView];
//there was used to have a parameter to determine the decisionView is kind of UIView,but I remenber it is always nil if you put this view in xib ,so I have to temporary add line to help input code

@interface MDKAutoLayoutHeight: NSObject
+(void)registerHeight:(Class)cellClass _decisionView:(NSString *)decisionView;

- (CGFloat)heightForRowAtIndexPath:(NSIndexPath *)indexPath;
- (CGFloat)heightForRowAtIndexPath:(NSIndexPath *)indexPath  handle:(CGFloat (^)(__kindof UITableViewCell *cell,CGFloat height))handleHeightBlock;
@end

@interface UITableView (_MDKAutoLayoutHeight)
@property (nonatomic,readonly)MDKAutoLayoutHeight *autoLayoutHeight;
@end
