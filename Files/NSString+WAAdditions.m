//
//  NSString+WAAdditions.m
//  PPRevealSample
//
//  Created by Marian Paul on 03/09/2015.
//  Copyright (c) 2015 Wasappli. All rights reserved.
//

#import "NSString+WAAdditions.h"

@implementation NSString (WAAdditions)

- (NSString *)waapp_stringByAddingPercentEscapes {
    NSString *result = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(
                                                                                             kCFAllocatorDefault,
                                                                                             (CFStringRef)self,
                                                                                             NULL,
                                                                                             CFSTR(":/?#[]@!$&’()*+,;="),
                                                                                             kCFStringEncodingUTF8) );
    return result;
}

@end
