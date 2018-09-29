//
//  XHB3DMeshFaceNode.m
//  FaceTracking
//
//  Created by 谢海邦 on 2018/9/26.
//  Copyright © 2018 XHB. All rights reserved.
//

#import "XHBMeshFaceNode.h"

@implementation XHBMeshFaceNode

#pragma mark -
#pragma mark -------------------- Life Cycle --------------------
- (instancetype)initWithFaceGeometry:(ARSCNFaceGeometry *)faceGeometry {
    self = [super init];
    if (self) {
        SCNMaterial *material = faceGeometry.firstMaterial;
        // 更改材料的填充模型为线条
        material.fillMode = SCNFillModeLines;
        // 漫反射的内容颜色
        material.diffuse.contents = [UIColor whiteColor];
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
