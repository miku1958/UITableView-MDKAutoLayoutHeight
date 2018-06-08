//
//  cellWithoutXib.m
//  UITableView+MDKAutoLayoutHeight
//
//  Created by mikun on 2018/6/8.
//  Copyright © 2018年 mdk. All rights reserved.
//

#import "cellWithoutXib.h"
#import "UITableView+MDKAutoLayoutHeightDiskCache.h"
@interface cellWithoutXib()<MDKTableviewCellCacheHeightDelegate>
@property (nonatomic,strong)UIImageView *headerImgview;
@property (nonatomic,strong)UILabel *headerTitleLabel;
@property (nonatomic,strong)UILabel *headerDescriptionLabel;
@end
@implementation cellWithoutXib
+(void)initialize{
	MDKAutoLayoutRegisterHeight(self, headerDescriptionLabel);
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
	self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
	if (self) {
		[self addSubview:(_headerImgview = [UIImageView new])];
		[self addSubview:(_headerTitleLabel = [UILabel new])];
		[self addSubview:(_headerDescriptionLabel = [UILabel new])];

		[_headerImgview setImage:[UIImage imageNamed:@"9DF408FF813B4E96DE2F9E88DB4D113A"]];

		[_headerTitleLabel setText:@"title"];
		[_headerDescriptionLabel setText:@"description"];
	}
	return self;
}

- (void)layoutSubviews{
	[super layoutSubviews];

	[_headerImgview sizeToFit];
	[_headerTitleLabel sizeToFit];
	[_headerDescriptionLabel sizeToFit];

	CGRect frame  = _headerImgview.frame;
	frame.origin.x = 15;
	frame.origin.y = 20;
	_headerImgview.frame = frame;

	frame = _headerTitleLabel.frame;
	frame.origin.x = 50;
	frame.origin.y = CGRectGetMaxY(_headerImgview.frame) + 10;
	_headerTitleLabel.frame = frame;


	frame = _headerDescriptionLabel.frame;
	frame.origin.x = 80;
	frame.origin.y = CGRectGetMaxY(_headerTitleLabel.frame) + 20;
	_headerDescriptionLabel.frame = frame;
}
-(NSString *)MDKModelHash{
	return NSStringFromClass(self.class);
}
@end
