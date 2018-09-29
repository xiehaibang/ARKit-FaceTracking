//
//  XHBVirtualFaceManager.m
//  FaceTracking
//
//  Created by 谢海邦 on 2018/9/16.
//  Copyright © 2018 XHB. All rights reserved.
//

#import "XHBVirtualFaceManager.h"

@implementation XHBVirtualFaceManager

#pragma mark -
#pragma mark -------------------- Life Cycle --------------------
+ (instancetype)sharedInstance {
    static XHBVirtualFaceManager *virtualFaceManager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        virtualFaceManager = [[XHBVirtualFaceManager alloc] init];
    });
    return virtualFaceManager;
}

#pragma mark -
#pragma mark -------------------- Publick Method --------------------
- (SCNNode *)getVirtualContentNodeWithResourceName:(NSString *)resouceName {
    NSURL *url = [[NSBundle mainBundle] URLForResource:resouceName withExtension:@"scn" subdirectory:@"Models.scnassets"];
    // 参照节点
    SCNReferenceNode *node = [[SCNReferenceNode alloc] initWithURL:url];
    [node load];
    return node;
}

@end
