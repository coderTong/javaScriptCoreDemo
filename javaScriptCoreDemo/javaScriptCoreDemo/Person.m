//
//  Person.m
//  javaScriptCoreDemo
//
//  Created by Mac on 16/7/29.
//  Copyright © 2016年 wutong. All rights reserved.
//

#import "Person.h"

@implementation Person

- (NSString *)name
{
    return @"wutong";
}

- (NSString *)whatYouName
{
    NSLog(@"来了没?~~~~");
    return [NSString stringWithFormat:@"我的名字:%@", self.name];
}

@end