# UITableView-MDKAutoLayoutHeight
A high performance, low invasive height calculation and Cache Tool for UITableview

If you like it ,please give me a star;if you don't ,please  tell me why

如果你喜欢这个工具,请点一下星星支持,如果你不喜欢的话,请给我一个isuue告诉我为什么


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

中文文档请看下方

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

	import UITableView+MDKAutoLayoutHeightDiskCache.h
    - (void)updateDiskCache;//use to those tableview that is always alive
    - (void)removeCacheFor:(Class)cell;
    - (void)removeAllCache;

# Known Issues

If you dequeue cell like this:

	- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

		return [tableView dequeueReusableCellWithIdentifier:@"Identifier" forIndexPath:indexPath];	
	}

It will crash because of I get the cell by using this datasource method,and `-dequeueReusableCellWithIdentifier:forIndexPath:` will call `table.delegate -heightForRowAtIndexPath` so it will get into an endless loop then crash , the solution is use the `table -dequeueReusableCellWithIdentifier:` rather than the forIndexPath one.  I counld find a reason why I need to use this method ,if you have to use this method to dequeue cell,please tell me the reason ,and I try to find a way to avoid it


# Thanks
Some code I use to determine the contentView's width is come from UITableView-FDTemplateLayoutCell



# 中文文档

# UITableView-MDKAutoLayoutHeight
高性能,低侵入性的UITableviewCell高度计算和缓存工具


## 这是什么 ?
这是一个UITableview高度计算和缓存的工具,并且是全自动和基本没有入侵性的!


## 使用方法

	#import "UITableView+MDKAutoLayoutHeight.h"

	-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
		return [tableView.autoLayoutHeight heightForRowAtIndexPath:indexPath];
	}

### 没了,就这样,超级简单对吧


#

如果需要对高度做什么事情(比如加个间距啊)，可以用这个方法重新计算行高

	-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
		return [tableView.autoLayoutHeight heightForRowAtIndexPath:indexPath handle:^CGFloat(__kindof UITableViewCell *cell, CGFloat height) {
		  return height + 20;
		}];
	}

---

#### 如果你cell不是完全填充contentView的约束,你可以用`MDKAutoLayoutRegisterHeight`设置哪个view是最底部的view:

	#import "UITableView+MDKAutoLayoutHeight.h"
	
	@interface PartOfAutolayoutCell()
	@proterty(nonatomic,strong)UIView *bottomView;
	@end
	
	@implementation PartOfAutolayoutCell
	+(void)initialize{
		MDKAutoLayoutRegisterHeight(self, bottomView)
	}
	@end

并且如果实现了这个方法,那这套工具也能适用于用frame布局的cell,只要你是在layoutSubview中布局的(其他方式如放在sizeThatFit之类的应该也能用吧..大概),如果你遇到哪些地方用frame设置cell的控件位置后无效的,请告诉我

> 顺便一提,MDKAutoLayoutRegisterHeight() 是用C语言的宏实现的,如果你是用swift的话,需要用MDKAutoLayoutHeight.(registerHeight:_decisionView:) 手动填入最底部的view对应的属性名

#

## 在内存中缓存高度

如果你需要缓存cell的高度到内存,只需要在cell中引入 `<MDKTableviewCellCacheHeightDelegate>` ,实现 `-MDKModelHash` 方法,返回一个具有唯一性的字符串给我就行,比如:

	-(NSString *)MDKModelHash{
		return @(_model.ID).description;
	}

如果是可能改变cell内容的话,可以把ID和决定cell内容是否有变化的标志符传给我,比如:

	-(NSString *)MDKModelHash{
		return [NSString stringWithFormat:@"%@%@",@(_model.ID),@(_model.isDelete)];
	}


等等等等.....


## 安装

    pod 'UITableView-MDKAutoLayoutHeight'
    
### 如果需要把高度缓存到磁盘的话

    pod 'UITableView-MDKAutoLayoutHeight/diskCache'

当tableview dealloc的时候就会把内存中的缓存写入磁盘
我提供了下面这些方法用来管理磁盘的缓存

	import UITableView+MDKAutoLayoutHeightDiskCache.h
    - (void)updateDiskCache;//用于某些会一直活着的tableview
    - (void)removeCacheFor:(Class)cell;
    - (void)removeAllCache;
    
# 已知问题

如果你dequeue cell的时候是这样的:

	- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

		return [tableView dequeueReusableCellWithIdentifier:@"Identifier" forIndexPath:indexPath];	
	}

app就会crash,因为我是通过这个datasource方法获取cell的,而`-dequeueReusableCellWithIdentifier:forIndexPath:` 这个方法会调用 `table.delegate -heightForRowAtIndexPath` 所以就会陷入无限循环......解决办法是不用这个方法,改成`-dequeueReusableCellWithIdentifier:`qeueu cell

我实在没有想到一定要用这个方法的理由,如果有遇到什么情况是一定要用这个dequeue cell的话,请告诉我原因谢谢，我试试看有没有办法避开这个问题

# 感谢

部分用来确定contentView宽度的代码来自UITableView-FDTemplateLayoutCell

