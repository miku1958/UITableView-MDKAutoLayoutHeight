# UITableView-MDKAutoLayoutHeight
A high performance, low invasive height calculation and Cache Tool for UITableview

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

#### if you need to cache cell height ,you can introduce ==<MDKTableviewCellCacheHeightDelegate>== in your cell ,implement -MDKModelHash method in your cell ,return something is unique like the dataModel's id if have ,like:
-(NSString *)MDKModelHash{
return @(_model.id).description;
}

if your cell will change dataModel's content, you can return the id and some identifier like:

-(NSString *)MDKModelHash{
return [NSString stringWithFormat:@"%@%@",@(_model.id),@(_model.isDelete)];
}


and so on.....



# Known Issues

if you dequeue cell like this:

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

return [tableView dequeueReusableCellWithIdentifier:@"fullContentCellFromXib" forIndexPath:indexPath];
break;	
}

it will crash because of I get the cell by using this ,and ==-dequeueReusableCellWithIdentifier:forIndexPath:== will call ==table.delegate -heightForRowAtIndexPath== so it will into an endless loop and crash , the solution is don't use the ==table -dequeueReusableCellWithIdentifier:forIndexPath:== I counld find a reason why I need to use this method ,if you have to use this method to dequeue cell,please hit me a issue and tell me the reason ,and I try to find a way to avoid it



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

并且如果你实现了这个方法,那这套工具就能适用于用frame布局的cell,只要你	
if you implement this, it will apply to those cell that use frame to config cell's layout in layoutSubview,or in other ~~magical~~ method ~~(I am not not 100% confident)~~ , if you find that you set frame in some place that this tool doesn't work ,please hit me a issue

> MDKAutoLayoutRegisterHeight() is base on C language Macro,if you using swift ,you may use MDKAutoLayoutHeight.(registerHeight:_decisionView:) to fill the property name of the bottomView manually

#

#### if you need to cache cell height ,you can introduce ==<MDKTableviewCellCacheHeightDelegate>== in your cell ,implement -MDKModelHash method in your cell ,return something is unique like the dataModel's id if have ,like:
-(NSString *)MDKModelHash{
return @(_model.id).description;
}

if your cell will change dataModel's content, you can return the id and some identifier like:

-(NSString *)MDKModelHash{
return [NSString stringWithFormat:@"%@%@",@(_model.id),@(_model.isDelete)];
}


and so on.....



# Known Issues

if you dequeue cell like this:

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

return [tableView dequeueReusableCellWithIdentifier:@"fullContentCellFromXib" forIndexPath:indexPath];
break;	
}

it will crash because of I get the cell by using this ,and ==-dequeueReusableCellWithIdentifier:forIndexPath:== will call ==table.delegate -heightForRowAtIndexPath== so it will into an endless loop and crash , the solution is don't use the ==table -dequeueReusableCellWithIdentifier:forIndexPath:== I counld find a reason why I need to use this method ,if you have to use this method to dequeue cell,please hit me a issue and tell me the reason ,and I try to find a way to avoid it
