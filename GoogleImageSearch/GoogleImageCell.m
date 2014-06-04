//
//  GoogleImageCell.m
//  GoogleImageSearch
//
//  Created by Alexander on 10/03/14.
//  Copyright (c) 2014 Alexander. All rights reserved.
//

#import "GoogleImageCell.h"

@implementation GoogleImageCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
      [self.imageView setContentMode:UIViewContentModeScaleAspectFit];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void) layoutSubviews {
  [super layoutSubviews];
  [[self imageView] setFrame:[self.imageView superview].bounds];
}

@end
