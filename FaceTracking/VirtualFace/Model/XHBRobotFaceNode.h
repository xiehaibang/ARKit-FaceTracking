//
//  XHBRobotFaceNode.h
//  FaceTracking
//
//  Created by 谢海邦 on 2018/9/23.
//  Copyright © 2018 XHB. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SceneKit/SceneKit.h>
#import <ARKit/ARKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface XHBRobotFaceNode : SCNReferenceNode
- (void)updateWithFaceAnchor:(ARFaceAnchor *)faceAnchor;
@end

NS_ASSUME_NONNULL_END
