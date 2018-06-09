# UITableView-MDKAutoLayoutHeight
A high performance, low invasive height calculation and Cache Tool for UITableview

If you like it ,please give me a star;if you hate it ,please hit me a issue tell me why

如果你喜欢这个工具,请点一下星星支持,如果你不喜欢的话,请给我一个isuue告诉我为什么


中文文档请看下方

## what is this ?

this is a height calculation and Cache Tool for UITableview which is fully automatic and bacisly non-invasive

## usage
	

	#import "UITableView+MDKAutoLayoutHeightDiskCache.h"

	-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
		return [tableView.autoLayoutHeight heightForRowAtIndexPath:indexPath];
	}

### That is it ! No extra cell config ,no extra identifier,you even don't need to change your code structure.
### Simple, right?

#

if you need to handle the result height,you can use the extend method like this

	-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
	   return [tableView.autoLayoutHeight heightForRowAtIndexPath:indexPath handle:^CGFloat(__kindof UITableViewCell *cell, CGFloat height) {
		   return height + 20;
	   }];
	}

---

#### if your cell has no fully constraint in cententView, you can use ++MDKAutoLayoutRegisterHeight++ to tell me which view is in the bottom,like this:

	#import "UITableView+MDKAutoLayoutHeightDiskCache.h"
	
	@implementation AutolayoutPartOfCellFromXib
	+(void)initialize{
		MDKAutoLayoutRegisterHeight(self, bottomView)
	}
	@end

if you implement this, it will apply to those cell that use frame to config cell's layout in layoutSubview,or in other ~~magical~~ method ~~(I am not not 100% confident)~~ , if you find that you set frame in some place that this tool doesn't work ,please hit me a issue

> MDKAutoLayoutRegisterHeight() is base on C language Macro,if you using swift ,you may use MDKAutoLayoutHeight.(registerHeight:_decisionView:) to fill the property name of the bottomView manually

#

## cache cell height in RAM 

introduce ==<MDKTableviewCellCacheHeightDelegate>== in your cell ,implement -MDKModelHash method in your cell ,return something is unique like the dataModel's id if have ,like:
	-(NSString *)MDKModelHash{
		return @(_model.id).description;
	}

if your cell will change dataModel's content, you can return the id and some identifier like:

	-(NSString *)MDKModelHash{
		return [NSString stringWithFormat:@"%@%@",@(_model.id),@(_model.isDelete)];
	}


and so on.....

#

## Installation

    pod 'UITableView-MDKAutoLayoutHeight'
    
### if you need to cache height to disk and RAM

    pod 'UITableView-MDKAutoLayoutHeight/diskCache'
 
the cache will write to disk when tableview is dealloc  
I provide these extra method to manager disk's cache

    - (void)updateDiskCache;//use to those tableview that is always alive
    - (void)removeCacheFor:(Class)cell;
    - (void)removeAllCache;

## Known Issues

if you dequeue cell like this:

	- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

		return [tableView dequeueReusableCellWithIdentifier:@"fullContentCellFromXib" forIndexPath:indexPath];	
	}

it will crash because of I get the cell by using this ,and ==-dequeueReusableCellWithIdentifier:forIndexPath:== will call ==table.delegate -heightForRowAtIndexPath== so it will into an endless loop and crash , the solution is use the ==table -dequeueReusableCellWithIdentifier:== I counld find a reason why I need to use this method ,if you have to use this method to dequeue cell,please hit me a issue and tell me the reason ,and I try to find a way to avoid it


# statement
some code I use to determine the contentView's width is come from UITableView-FDTemplateLayoutCell:

https://github.com/forkingdog/UITableView-FDTemplateLayoutCell


# 中文文档

# UITableView-MDKAutoLayoutHeight
高性能,低侵入性的UITableviewCell高度计算和缓存工具


## 这是什么 ?

这是一个UITableview高度计算和缓存的工具,并且是全自动和基本没有入侵性的,是不是很感兴趣啊


## 使用方法


	#import "UITableView+MDKAutoLayoutHeightDiskCache.h"

	-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
		return [tableView.autoLayoutHeight heightForRowAtIndexPath:indexPath];
	}

### 没了,就这样,不用设置cell,不用提供额外的id,你甚至不用改变任何的代码,超级简单对吧


#

如果你需要在计算完高度后,对高度做什么事情(比如加个间距啊),你可以用这个方法获取行高

	-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
		return [tableView.autoLayoutHeight heightForRowAtIndexPath:indexPath handle:^CGFloat(__kindof UITableViewCell *cell, CGFloat height) {
		  return height + 20;
		}];
	}

---

#### 如果你cell不是完全填充contentView的约束,你可以用++MDKAutoLayoutRegisterHeight++设置哪个view是最底部的view:

	#import "UITableView+MDKAutoLayoutHeightDiskCache.h"

	@implementation AutolayoutPartOfCellFromXib
	+(void)initialize{
		MDKAutoLayoutRegisterHeight(self, bottomView)
	}
	@end

并且如果你实现了这个方法,那这套工具就能适用于用frame布局的cell,只要你是用layoutSubview的方式(其他方式如放在sizeThatFit之类的应该也能用吧..大概),如果你遇到哪些地方用frame设置cell的控件位置后无效的,请提交issue告诉我

> 顺便一提,MDKAutoLayoutRegisterHeight() 是用C语言的宏实现的,如果你是用swift的话名,需要用MDKAutoLayoutHeight.(registerHeight:_decisionView:) 手动填入最底部的view对应的属性名

#

## 在内存中缓存高度

如果你需要缓存cell的高度到内存,只需要在cell中引入 ==<MDKTableviewCellCacheHeightDelegate>== ,实现 ==-MDKModelHash== 方法,返回一个具有唯一性的字符串给我就行,比如:
	-(NSString *)MDKModelHash{
		return @(_model.id).description;
	}

如果是可能改变cell内容的话,可以把id和决定cell内容是否有变化的标志符传给我,比如:

	-(NSString *)MDKModelHash{
		return [NSString stringWithFormat:@"%@%@",@(_model.id),@(_model.isDelete)];
	}


等等等等.....


## 安装

    pod 'UITableView-MDKAutoLayoutHeight'
    
### 如果需要把高度缓存到磁盘的话

    pod 'UITableView-MDKAutoLayoutHeight/diskCache'

当tableview dealloc的时候就会把内存中的缓存写入磁盘
我提供了下面这些方法用来管理磁盘的缓存

    - (void)updateDiskCache;//用于某些会一直活着的tableview
    - (void)removeCacheFor:(Class)cell;
    - (void)removeAllCache;
    
## 已知问题

如果你dequeue cell的时候是这样的:

	- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

		return [tableView dequeueReusableCellWithIdentifier:@"fullContentCellFromXib" forIndexPath:indexPath];	
	}

app就会crash,因为我是通过这个datasource方法获取cell的,而==-dequeueReusableCellWithIdentifier:forIndexPath:== 这个方法会调用==table.delegate -heightForRowAtIndexPath== 所以就会陷入无限循环......解决办法是不用这个方法,改成==-dequeueReusableCellWithIdentifier:==

我实在没有想到一定要用这个方法的理由,如果有遇到什么情况是一定要用这个dequeue cell的话,请提issue告诉我一下谢谢

# 声明

部分用来确定contentView的代码来自UITableView-FDTemplateLayoutCell:

https://github.com/forkingdog/UITableView-FDTemplateLayoutCell
