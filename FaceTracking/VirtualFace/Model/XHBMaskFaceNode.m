//
//  XHBVirtualFaceMask.m
//  FaceTracking
//
//  Created by 谢海邦 on 2018/9/16.
//  Copyright © 2018 XHB. All rights reserved.
//

#import "XHBMaskFaceNode.h"
#import "XHBVirtualFaceManager.h"

@implementation XHBMaskFaceNode

#pragma mark -
#pragma mark -------------------- Life Cycle --------------------
- (instancetype)initWithFaceGeometry:(ARSCNFaceGeometry *)faceGeometry {
    self = [super init];
    if (self) {
        SCNMaterial *material = faceGeometry.firstMaterial;
        // 漫反射的内容颜色
        material.diffuse.contents = [UIImage imageNamed:@"head2"];
        // 基于物理的阴影，包含了真实世界灯光和材料之间相互作用的光照模型
        material.lightingModelName = SCNLightingModelPhysicallyBased;
        
        self.geometry = faceGeometry;
    }
    return self;
}

#pragma mark -
#pragma mark -------------------- Public Method --------------------
- (void)updateWithFaceAnchor:(ARFaceAnchor *)faceAnchor {
    [(ARSCNFaceGeometry *)self.geometry updateFromFaceGeometry:faceAnchor.geometry];
}

@end
