//
//  GoogleImageLoader.h
//  GoogleImageSearch
//
//  Created by Alexander on 10/03/14.
//  Copyright (c) 2014 Alexander. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GoogleImageLoader : NSObject

typedef void (^ImageRequestCallback)(UIImage * image);
typedef void (^ImageRequestErrorCallback)(NSError * error);

+(GoogleImageLoader *) sharedGoogleImageLoader;
-(UIImage *) imageForURL:(NSURL *) url
          onLoad:(ImageRequestCallback)onLoad
                 onError:(ImageRequestErrorCallback) onError;
@end
