//
//  ViewController.m
//  GoogleImageSearch
//
//  Created by Alexander on 10/03/14.
//  Copyright (c) 2014 Alexander. All rights reserved.
//

#import "ViewController.h"
#import "GoogleSearchResult.h"
#import "GoogleSearchRequest.h"
#import "GoogleImageLoader.h"
#import "GoogleImageCell.h"

@interface ViewController () {
  NSArray * _tableData;

}

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return _tableData.count;
}

-(GoogleSearchResult *) objectForIndexPath:(NSIndexPath * )indexPath {
  return [_tableData objectAtIndex:indexPath.row];
}


-(void)configureCell:(GoogleImageCell *) cell
           forObject:(GoogleSearchResult *) object
         atIndexPath:(NSIndexPath *) indexPath {
  
  [cell setGoogleItem:object];
  [cell.textLabel setNumberOfLines:3];
  [cell.textLabel setText:nil];
  [cell.imageView setHidden:NO];
  UIImage * img = [[GoogleImageLoader sharedGoogleImageLoader] imageForURL:object.imageUrl onLoad:^(UIImage *image) {
    if (cell.googleItem == object) { // Required due to reuse
      [[cell imageView] setImage:image];
      
      [[self tableView] beginUpdates];
      [[self tableView] reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
      [[self tableView] endUpdates];
    }
  } onError:^(NSError *error) {
    [cell.textLabel setText:[NSString stringWithFormat:@"Can't load image %@", [object.imageUrl absoluteString]]];
    [cell.imageView setHidden:YES];
  }];
  
  [cell.imageView setImage:img];
}

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  NSString * cellIdentifier = @"GoogleImageCell";
  GoogleImageCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
  if (nil == cell) {
    cell = [[GoogleImageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
  }
  
  [self configureCell:cell forObject:[self objectForIndexPath:indexPath] atIndexPath:indexPath];
  return cell;
}


-(void) _doSearch:(NSMutableArray *) buffer
             text:(NSString *)text {
  [[[GoogleSearchRequest alloc] init] startRequest:text page:buffer.count successCallBack:^(NSArray *results) {
    [buffer addObjectsFromArray:results];
    if (buffer.count < [self maxSearchResult] && results.count > 0) {
      [self _doSearch:buffer text:text];
    } else {
      _tableData = [buffer copy];
      [self.tableView reloadData];
    }
  }];
}

-(NSUInteger) maxSearchResult {
  return 40;
}

-(void) startNewSearch:(NSString *) text {
  NSMutableArray * buffer = [[NSMutableArray alloc] init];
  [self _doSearch:buffer text:text];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
  [self startNewSearch:searchBar.text];
  [searchBar endEditing:NO];
}

@end
