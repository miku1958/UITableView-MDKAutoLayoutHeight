//
//  ViewController.m
//  UITableView+MDKAutoLayoutHeight
//
//  Created by mikun on 2018/6/8.
//  Copyright © 2018年 mdk. All rights reserved.
//

#import "ViewController.h"
#import "UITableView+MDKAutoLayoutHeightDiskCache.h"

#import "partAutolayoutOfCellFromXib.h"
#import "cellWithoutXib.h"
@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)UITableView *table;
@end

@implementation ViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	_table = [[UITableView alloc]init];
	[self.view addSubview:_table];

	_table.dataSource = self;
	_table.delegate = self;

	[_table registerNib:[UINib nibWithNibName:@"fullContentCellFromXib" bundle:nil] forCellReuseIdentifier:@"fullContentCellFromXib"];
	[_table registerNib:[UINib nibWithNibName:@"partAutolayoutOfCellFromXib" bundle:nil] forCellReuseIdentifier:@"partAutolayoutOfCellFromXib"];
	[_table registerClass:cellWithoutXib.class forCellReuseIdentifier:@"cellWithoutXib"];
}
-(void)viewDidLayoutSubviews{
	_table.frame = self.view.bounds;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
	return 3;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
	return [tableView.autoLayoutHeight heightForRowAtIndexPath:indexPath handle:^CGFloat(__kindof UITableViewCell *cell, CGFloat height) {
		return height + 20;
	}];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

	UITableViewCell *cell;

	switch (indexPath.row%3) {
		case 0:
			cell = [tableView dequeueReusableCellWithIdentifier:@"fullContentCellFromXib"];
			break;
		case 1:
			cell = [tableView dequeueReusableCellWithIdentifier:@"partAutolayoutOfCellFromXib"];
			break;
		case 2:
			cell = [tableView dequeueReusableCellWithIdentifier:@"cellWithoutXib"];
			break;
		default:
			break;
	}


	return cell;

}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
}


@end
