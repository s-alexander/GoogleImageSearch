//
//  GoogleImageLoader.m
//  GoogleSearchResults2
//
//  Created by Alexander on 10/03/14.
//  Copyright (c) 2014 Alexander. All rights reserved.
//

#import "GoogleImageLoader.h"
#import "AFNetworking.h"

@interface GoogleImageLoader () {
  NSOperationQueue * _imagesLoadQueue;
  NSCache * _imagesCache;
}

@end

@implementation GoogleImageLoader

typedef void (^ImageRequestCallback)(UIImage * image);

-(id) init {
  self = [super init];
  if (self) {
    _imagesCache = [NSCache new];
    _imagesLoadQueue = [NSOperationQueue new];
    [_imagesLoadQueue setMaxConcurrentOperationCount:2];
  }
  return self;
}

-(UIImage *) imageForURL:(NSURL *) url
                  onLoad:(ImageRequestCallback)onLoad
                 onError:(ImageRequestErrorCallback) onError {
  id image = [_imagesCache objectForKey:url];
  // UIImage - result
  // NSError - error
  // NSNull - unknown error
  // AFHTTPRequestOperation - request in progress
  
  if (nil == image) {
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [_imagesCache setObject:op forKey:url];
    
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
      UIImage * image = [UIImage imageWithData:responseObject];
      if (image) {
        [_imagesCache setObject:image forKey:url];
      } else {
        [_imagesCache setObject:[NSNull null] forKey:url];
      }
      onLoad(image);
      
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
      [_imagesCache setObject:[NSNull null] forKey:url];
      if (onError) {
        onError(error);
      }
    }];
    
    [_imagesLoadQueue addOperation:op];
    
  } else {
    if ([image isKindOfClass:[UIImage class]]) {
      return image;
    } else if (image == [NSNull null]) {
      if (onError) {
        onError(nil);
      }
      return nil;
    }
  }
  return nil;
}


+(GoogleImageLoader *) sharedGoogleImageLoader {
  static GoogleImageLoader * result;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    result = [GoogleImageLoader new];
  });
  return result;
}
@end
