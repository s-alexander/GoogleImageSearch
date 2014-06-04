//
//  GoogleSearchRequest.m
//  GoogleImageSearch
//
//  Created by Alexander on 10/03/14.
//  Copyright (c) 2014 Alexander. All rights reserved.
//

#import "GoogleSearchRequest.h"
#import "AFNetworking.h"
#import "AFHTTPRequestOperation.h"
#import "GoogleSearchResult.h"

@implementation GoogleSearchRequest


+(NSOperationQueue *) googleRequestsQueue {
  static dispatch_once_t onceToken;
  static NSOperationQueue * result;
  dispatch_once(&onceToken, ^{
    result = [[NSOperationQueue alloc] init];
  });
  return result;
}

-(NSURL *) googleImageSearchURLForText:(NSString *)text page:(NSUInteger) page {
  NSURL * url = [NSURL URLWithString:[NSString stringWithFormat:@"https://ajax.googleapis.com/ajax/services/search/images?v=1.0&q=%@&start=%u", [text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding], (unsigned int)page]];
  return url;
}

-(void) startRequest:(NSString *) requestText
                page:(NSUInteger)page
     successCallBack:(GoogleSearchRequestSuccess)onSuccess {
  
  NSURLRequest *request = [NSURLRequest requestWithURL:[self googleImageSearchURLForText:requestText page:page]];
  
  AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
  op.responseSerializer = [AFJSONResponseSerializer serializer];
  
  [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
    NSLog(@"JSON: %@", responseObject);
    NSDictionary * responseData = [responseObject objectForKey:@"responseData"];
    NSArray * results = [responseData objectForKey:@"results"];
    NSMutableArray * googleResult = [[NSMutableArray alloc] initWithCapacity:results.count];
    for (NSDictionary * dict in results) {
      NSString * url = [dict objectForKey:@"url"];
      GoogleSearchResult * googleData = [GoogleSearchResult new];
      [googleData setImageUrl:[NSURL URLWithString:url]];
      [googleResult addObject:googleData];
    }
    
    if (onSuccess) {
      onSuccess(googleResult);
    }
    
  } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    NSLog(@"Error: %@", error);
    onSuccess(nil);
  }];
  
  [[[self class] googleRequestsQueue] addOperation:op];

}
@end
