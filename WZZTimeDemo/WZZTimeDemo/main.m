//
//  main.m
//  WZZTimeDemo
//
//  Created by 王泽众 on 2018/9/28.
//  Copyright © 2018年 王泽众. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WZZTimeHandler.h"

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        WZZTimeHandler * time = [WZZTimeHandler timeWithTimeStr:@"2019-10-31"];
        NSLog(@"%@", time);
        NSLog(@"%@", time.addMonth(-8));
        NSLog(@"%@", time.addDay(30));
    }
    return 0;
}
