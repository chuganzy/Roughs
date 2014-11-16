//
//  ProjectListTableViewCell.m
//  Roughs
//
//  Created by Takeru Chuganji on 11/16/14.
//  Copyright (c) 2014 Takeru Chuganji. All rights reserved.
//

#import "ProjectListTableViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface ProjectListTableViewCell ()
@property (nonatomic, weak) IBOutlet UIImageView *iconImageView;
@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
@property (nonatomic, weak) IBOutlet UILabel *creatorLabel;
@end

@implementation ProjectListTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    UIImage *maskImage = [UIImage imageNamed:@"mask_app_icon_52"];
    CALayer *mask = [CALayer layer];
    mask.frame = CGRectMake(0, 0, maskImage.size.width, maskImage.size.height);
    mask.contents = (__bridge id)[maskImage CGImage];
    self.iconImageView.layer.mask = mask;
}

- (UIEdgeInsets)layoutMargins {
    return UIEdgeInsetsZero;
}

- (void)setProject:(NSDictionary *)project {
    if (_project == project) {
        return;
    }
    _project = [project copy];
    self.titleLabel.text = project[@"title"];
    self.creatorLabel.text = [project[@"creators"] componentsJoinedByString:@" / "];
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:project[@"icon_url"]]];
}

@end
