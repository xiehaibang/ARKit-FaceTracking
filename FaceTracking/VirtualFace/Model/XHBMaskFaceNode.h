//
//  XHBVirtualFaceMask.h
//  FaceTracking
//
//  Created by 谢海邦 on 2018/9/16.
//  Copyright © 2018 XHB. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SceneKit/SceneKit.h>
#import <ARKit/ARKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface XHBMaskFaceNode : SCNNode

- (instancetype)initWithFaceGeometry:(ARSCNFaceGeometry *)faceGeometry;
- (void)updateWithFaceAnchor:(ARFaceAnchor *)faceAnchor;

@end

NS_ASSUME_NONNULL_END
