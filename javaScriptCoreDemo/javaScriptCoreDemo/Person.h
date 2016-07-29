//
//  Person.h
//  javaScriptCoreDemo
//
//  Created by Mac on 16/7/29.
//  Copyright © 2016年 wutong. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <JavaScriptCore/JavaScriptCore.h>

@protocol JSPersonProtocol <JSExport>

@property (nonatomic, copy)NSString * name;
- (NSString *)whatYouName;
@end

@interface Person : NSObject<JSPersonProtocol>

@property (nonatomic, copy)NSString * name;
- (NSString *)whatYouName;

@end