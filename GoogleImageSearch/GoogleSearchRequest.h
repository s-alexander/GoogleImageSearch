//
//  GoogleSearchRequest.h
//  GoogleImageSearch
//
//  Created by Alexander on 10/03/14.
//  Copyright (c) 2014 Alexander. All rights reserved.
//

#import <Foundation/Foundation.h>

@class GoogleSearchResult;

typedef void (^GoogleSearchRequestSuccess)(NSArray * results); // array of GoogleSearchResult

@interface GoogleSearchRequest : NSObject

-(void) startRequest:(NSString *) requestText
                page:(NSUInteger)page
     successCallBack:(GoogleSearchRequestSuccess)onSuccess;
@end
