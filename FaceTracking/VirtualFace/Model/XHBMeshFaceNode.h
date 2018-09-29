//
//  XHB3DMeshFaceNode.h
//  FaceTracking
//
//  Created by 谢海邦 on 2018/9/26.
//  Copyright © 2018 XHB. All rights reserved.
//

#import <SceneKit/SceneKit.h>
#import <ARKit/ARKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface XHBMeshFaceNode : SCNNode

- (instancetype)initWithFaceGeometry:(ARSCNFaceGeometry *)faceGeometry;
- (void)updateWithFaceAnchor:(ARFaceAnchor *)faceAnchor;

@end

NS_ASSUME_NONNULL_END
