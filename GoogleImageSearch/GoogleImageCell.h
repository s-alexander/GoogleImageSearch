//
//  GoogleImageCell.h
//  GoogleImageSearch
//
//  Created by Alexander on 10/03/14.
//  Copyright (c) 2014 Alexander. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GoogleSearchResult;

@interface GoogleImageCell : UITableViewCell
@property (nonatomic, strong) GoogleSearchResult * googleItem;
@end
