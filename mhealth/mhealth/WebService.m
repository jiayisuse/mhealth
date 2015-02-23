//
//  WebService.m
//  mhealth
//
//  Created by jiayi on 2/22/15.
//  Copyright (c) 2015 jiayi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Global.h"
#import "WebService.h"

@interface WebService () {
    NSMutableData *_downloadedData;
    NSString *phpFile;
    NSMutableString *postString;
}
@end

@implementation WebService

- (id)initWithPHPFile:(NSString *)aPhpFile {
    if (self = [super init]) {
        phpFile = aPhpFile;
        postString = [NSMutableString new];
    }
    return self;
}

- (void)setPostData:(NSDictionary *)postDataDict {
    for (NSString *key in postDataDict) {
        NSLog(@"key = %@, value = %@", key, postDataDict[key]);
        [postString appendFormat:@"%@=%@&", key, postDataDict[key]];
    }
    [postString deleteCharactersInRange:NSMakeRange([postString length] - 1, 1)];
    NSLog(@"post data: %@", postString);
}

- (BOOL)sendRequest {
    NSData *postData = [postString dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%d",[postData length]];
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/%@", DOMAIN_URL, phpFile]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setHTTPBody:postData];
    NSURLConnection *conn = [[NSURLConnection alloc]initWithRequest:request delegate:self];
    
    if (conn)
        NSLog(@"oh yeah");
    else
        NSLog(@"nonono");
    
    return YES;
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    NSLog(@"didReceiveResponse");
    _downloadedData = [[NSMutableData alloc] init];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    NSLog(@"didReceiveData");
    [_downloadedData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    NSLog(@"connectionDidFinishLoading, %@", self.delegate);
    if (self.delegate)
        [self.delegate dataDownloaded:_downloadedData];
}

@end