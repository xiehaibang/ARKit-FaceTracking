//
//  XHBRobotFaceNode.m
//  FaceTracking
//
//  Created by 谢海邦 on 2018/9/23.
//  Copyright © 2018 XHB. All rights reserved.
//

#import "XHBRobotFaceNode.h"
#import "XHBVirtualFaceManager.h"

@interface XHBRobotFaceNode ()
@property (nonatomic, strong) SCNNode *jawNode;                                             /**< 下巴节点 */
@property (nonatomic, strong) SCNNode *leftEyeNode;                                         /**< 左边眼睛节点 */
@property (nonatomic, strong) SCNNode *rightEyeNode;                                        /**< 右边眼睛节点 */
@property (nonatomic, assign) CGFloat jawOriginY;                                           /**< 下巴的位置 */
@property (nonatomic, assign) CGFloat jawHeight;                                            /**< 下巴的高度 */
@property (nonatomic, strong) NSDictionary<ARBlendShapeLocation, NSNumber *> *blendShapes;  /**< 五官运动系数的字典 */
@end

@implementation XHBRobotFaceNode

#pragma mark -
#pragma mark -------------------- Life Cycle --------------------
- (instancetype)init {
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"robotHead" withExtension:@"scn" subdirectory:@"Models.scnassets"];
    if (!url) { return nil; }
    self = [super initWithURL:url];
    if (self) {
        [self load];

        _jawNode = [self childNodeWithName:@"jaw" recursively:YES];
        _leftEyeNode = [self childNodeWithName:@"eyeLeft" recursively:YES];
        _rightEyeNode = [self childNodeWithName:@"eyeRight" recursively:YES];
        _jawOriginY = _jawNode.position.y;
    }
    return self;
}

#pragma mark -
#pragma mark -------------------- Public Method --------------------
- (void)updateWithFaceAnchor:(ARFaceAnchor *)faceAnchor {
    self.blendShapes = faceAnchor.blendShapes;
    
//    SCNNode *leftAxesNode = [[XHBVirtualFaceManager sharedInstance] getVirtualContentNodeWithResourceName:@"coordinateOrigin"];
//    [self.leftEyeNode addChildNode:leftAxesNode];
//    
//    SCNNode *rightAxesNode = [[XHBVirtualFaceManager sharedInstance] getVirtualContentNodeWithResourceName:@"coordinateOrigin"];
//    [self.rightEyeNode addChildNode:rightAxesNode];
}

#pragma mark -
#pragma mark -------------------- Setter --------------------
- (void)setBlendShapes:(NSDictionary<ARBlendShapeLocation,NSNumber *> *)blendShapes {
    _blendShapes = blendShapes;
    
    // 左眼表情系数
    CGFloat leftEyeBlink = [blendShapes[ARBlendShapeLocationEyeBlinkLeft] floatValue];
    CGFloat leftEyeLookLeft = [blendShapes[ARBlendShapeLocationEyeLookOutLeft] floatValue];
    CGFloat leftEyeLookRight = [blendShapes[ARBlendShapeLocationEyeLookInLeft] floatValue];
    
    SCNVector3 leftEyeScale = self.leftEyeNode.scale;
    // 当其中一个表情系数有值时，其他表情系数为0
    if (leftEyeLookLeft > 0) {
        leftEyeScale.x = 1 - leftEyeLookLeft;
    }else {
        leftEyeScale.x = 1 - leftEyeLookRight;
    }
    leftEyeScale.z = 1 - leftEyeBlink;
    self.leftEyeNode.scale = leftEyeScale;
    
    // 右眼表情系数
    CGFloat rightEyeBlink = [blendShapes[ARBlendShapeLocationEyeBlinkRight] floatValue];
    CGFloat rightEyeLookLeft = [blendShapes[ARBlendShapeLocationEyeLookInRight] floatValue];
    CGFloat rightEyeLookRight = [blendShapes[ARBlendShapeLocationEyeLookOutRight] floatValue];
    
    SCNVector3 rightEyeScale = self.rightEyeNode.scale;
    if (rightEyeLookLeft > 0) {
        rightEyeScale.x = 1 - leftEyeLookLeft;
    }else {
        rightEyeScale.x = 1 - rightEyeLookRight;
    }
    rightEyeScale.z = 1 - rightEyeBlink;
    self.rightEyeNode.scale = rightEyeScale;
    
    // 下巴开口表情系数
    CGFloat jawOpen = [blendShapes[ARBlendShapeLocationJawOpen] floatValue];
    self.jawNode.position = (SCNVector3){self.jawNode.position.x, self.jawOriginY - self.jawHeight*jawOpen, self.jawNode.position.z};
}

#pragma mark -
#pragma mark -------------------- Getter --------------------
- (CGFloat)jawHeight {
    SCNVector3 min = (SCNVector3){0, 0, 0};
    SCNVector3 max = (SCNVector3){0, 0, 0};
    [self getBoundingBoxMin:&min max:&max];
    return max.y - min.y;
}

@end
