//
//  NSString+STFrame.m
//  STLocation
//
//  Created by 梁志云 on 16/6/23.
//  Copyright © 2016年 梁志运. All rights reserved.
//

#import "NSString+STFrame.h"

@implementation NSString (STFrame)

- (CGSize)sizeWithFont:(UIFont *)font maxSize:(CGSize)maxSize
{
    NSDictionary *attrs = @{NSFontAttributeName : font};
    return [self boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
}

@end
