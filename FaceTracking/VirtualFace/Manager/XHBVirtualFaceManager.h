//
//  XHBVirtualFaceManager.h
//  FaceTracking
//
//  Created by 谢海邦 on 2018/9/16.
//  Copyright © 2018 XHB. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SceneKit/SceneKit.h>
#import <ARKit/ARKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface XHBVirtualFaceManager : NSObject

+ (instancetype)sharedInstance;

/**
 * 获取虚拟内容节点
 */
- (SCNNode *)getVirtualContentNodeWithResourceName:(NSString *)resouceName;

@end

NS_ASSUME_NONNULL_END
