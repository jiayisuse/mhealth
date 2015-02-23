//
//  WebService.h
//  mhealth
//
//  Created by jiayi on 2/22/15.
//  Copyright (c) 2015 jiayi. All rights reserved.
//

#ifndef mhealth_WebService_h
#define mhealth_WebService_h

#import <Foundation/Foundation.h>

@protocol WebServiceProtocol <NSObject>

- (void)dataDownloaded:(NSData *)data;

@end

@interface WebService : NSObject <NSURLConnectionDataDelegate>

@property (nonatomic, weak) id <WebServiceProtocol> delegate;

- (id)initWithPHPFile:(NSString *)aPhpFile;
- (void)setPostData:(NSDictionary *)postDataDict;
- (BOOL)sendRequest;

@end

#endif
