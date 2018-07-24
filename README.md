# UITableView-MDKAutoLayoutHeight
A high performance, low invasive height calculation and Cache Tool for UITableview

If you like it ,please give me a star

如果你喜欢这个工具,请点一下星星支持


## What is this ?

This is a height calculation and Cache Tool for UITableview which is fully automatic and bacisly non-invasive



Features
==============
- **High performance**: As less as possible recalculate the cell's height ,provide cache in RAM and DISK.
- **Automatic update**: it will update when cell's content and tableview's width had changed base on dataModel's Hash.
- **RAM manage**: automatic clear RAM when system notifiy run out of RAM.
- **Low-intrusive**: basicly no need to change any code structure to use this library ，not like FDTemplateLayoutCell.
- **Lightwight**: The core of This library contains only 1 files with 1 class and 1 extension.
- **Easy to use**: just 1 line of code than you can enjoy fully automatic height calculation.


功能
==============
- **高性能**: 尽可能少的计算cell的高度，并且提供内存和磁盘缓存.
- **自动更新**: 基于数据模型hash的更新，当数据源或者tableview宽度有变化时会自动更新缓存.
- **内存管理**: 当系统提示内存不够的时候自动清理内存缓存.
- **低侵入性**: 基本上不需要改动任何代码结构就能使用这个框架，不像FDTemplateLayoutCell要根据他们的设计改动大量原有代码（还不好用）.
- **轻量级**: 这个库的核心组件只有一个文件，一个类和一个tableview分类.
- **容易使用**: 只需要一行代码就能享受完全自动化的高度计算.


中文文档:[简书](https://www.jianshu.com/p/d1af093d3bda) [掘金](https://juejin.im/post/5b1c9a0d6fb9a01e8b782357) 


## Usage
	

	#import "UITableView+MDKAutoLayoutHeight.h"

	-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
		return [tableView.autoLayoutHeight heightForRowAtIndexPath:indexPath];
	}

### That is it !  Simple, right?

#

If you need to handle the result height,you can use this

	-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
	   return [tableView.autoLayoutHeight heightForRowAtIndexPath:indexPath handle:^CGFloat(__kindof UITableViewCell *cell, CGFloat height) {
		   return height + 20;
	   }];
	}

---

#### If your cell does‘nt have fully constraint in cententView(which is not a self-satisfie cell), you can use `MDKAutoLayoutRegisterHeight` to tell me which view is in the bottom,like this:

	#import "UITableView+MDKAutoLayoutHeight.h"
	
	@interface PartOfAutolayoutCell()
	@proterty(nonatomic,strong)UIView *bottomView;
	@end
	
	@implementation PartOfAutolayoutCell
	+(void)initialize{
		MDKAutoLayoutRegisterHeight(self, bottomView)
	}
	@end

If you implement this, it also apply to those cell that use frame to config cell's layout in layoutSubview,or in other ~~magical~~ method ~~(I am not not 100% confident)~~ , if you find that you set frame in some place that this tool doesn't work ,please tell me where

> MDKAutoLayoutRegisterHeight() is base on C language Macro,if you using swift ,you may use MDKAutoLayoutHeight.(registerHeight:_decisionView:) to fill the property name of the View in bottom manually

#

## cache cell height in RAM 

Introduce `<MDKTableviewCellCacheHeightDelegate>` in your cell ,implement `-MDKModelHash method` ,return something is unique like the dataModel's ID ,like:

	-(NSString *)MDKModelHash{
		return @(_model.ID).description;
	}
	
If you are not use cell to handle model but in VieController you can easily transport model id to the cell And return it,etc

If your cell may change dataModel's content, you can return the id and some identifier like:

	-(NSString *)MDKModelHash{
		return [NSString stringWithFormat:@"%@%@",@(_model.ID),@(_model.isDelete)];
	}

And so on.....

#

## Installation

    pod 'UITableView-MDKAutoLayoutHeight'
    
### If you need to cache height to disk and RAM

    pod 'UITableView-MDKAutoLayoutHeight/diskCache'
 
The cache will write to disk when tableview is dealloc  
I provide these method to manage disk's cache

~import UITableView+MDKAutoLayoutHeightDiskCache.h~ for easy to change ,It is no need to change header File now
    
    - (void)updateDiskCache;//use to those tableview that is always alive
    - (void)removeCacheFor:(Class)cell;
    - (void)removeAllCache;

# Known Issues

If you dequeue cell like this:

	- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

		return [tableView dequeueReusableCellWithIdentifier:@"Identifier" forIndexPath:indexPath];	
	}

It will crash because of I get the cell by using this datasource method,and `-dequeueReusableCellWithIdentifier:forIndexPath:` will call `table.delegate -heightForRowAtIndexPath` so it will get into an endless loop then crash , the solution is use the `table -dequeueReusableCellWithIdentifier:` rather than the forIndexPath one.  I counldn‘t find a reason why I need to use this method ,if you have to use this method to dequeue cell,please tell me the reason ,and I try to find a way to avoid it


# Thanks
Some code I use to determine the contentView's width is come from UITableView-FDTemplateLayoutCell

