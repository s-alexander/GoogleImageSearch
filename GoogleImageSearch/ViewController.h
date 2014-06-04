//
//  ViewController.h
//  GoogleImageSearch
//
//  Created by Alexander on 10/03/14.
//  Copyright (c) 2014 Alexander. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController <UITableViewDataSource,
UITableViewDelegate, UISearchBarDelegate>

@property (nonatomic, strong) IBOutlet UITableView * tableView;
@end
