//
//  XHBVirtualFaceViewController.m
//  FaceTracking
//
//  Created by 谢海邦 on 2018/9/25.
//  Copyright © 2018 XHB. All rights reserved.
//

#import "XHBVirtualFaceViewController.h"
#import "XHBMeshFaceNode.h"
#import "XHBMaskFaceNode.h"
#import "XHBRobotFaceNode.h"
#import "XHBVirtualFaceManager.h"

#import <SceneKit/SceneKit.h>
#import <ARKit/ARKit.h>


@interface XHBVirtualFaceViewController () <ARSessionDelegate, ARSCNViewDelegate, UIGestureRecognizerDelegate>
@property (nonatomic, assign) XHBVirtualFaceType virtualFaceType;           /**< 虚拟面部的类型 */
@property (nonatomic, strong) ARSCNView *sceneView;                         /**< 场景视图 */
@property (nonatomic, weak) ARSession *trackingSession;                     /**< 追踪会话 */
@property (nonatomic, strong) SCNNode *virtualFaceNode;                     /**< 虚拟模型面部节点 */
@property (nonatomic, strong) SCNNode *faceNode;                            /**< 真实世界面部节点 */
@property (nonatomic, strong) SCNNode *axesNode;                            /**< 人脸坐标轴节点 */
@property (nonatomic, strong) XHBMeshFaceNode *meshFaceNode;              /**< 面部拓扑的网格 */
@property (nonatomic, strong) XHBMaskFaceNode *maskFaceNode;                /**< 面具 */
@property (nonatomic, strong) XHBRobotFaceNode *robotFaceNode;              /**< 机器人 */
@property (nonatomic, copy) NSDictionary *contentTypeDictionary;
@end

@implementation XHBVirtualFaceViewController

#pragma mark -
#pragma mark -------------------- Life Cycle --------------------
- (void)dealloc {
    NSLog(@"XHBVirtualFaceViewController 已销毁");
}

- (instancetype)initWithVirtualFaceType:(XHBVirtualFaceType)virtualFaceType {
    self = [super init];
    if (self) {
        _virtualFaceType = virtualFaceType;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self p_drawView];
    
    [self p_setupFaceNode];
    [self p_setupTrackingSession];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    [self.trackingSession pause];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark -------------------- Draw --------------------
- (void)p_drawView {
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
    
    [self.view addSubview:self.sceneView];
}

#pragma mark -
#pragma mark -------------------- Setup --------------------
/** 设置面部节点 */
- (void)p_setupFaceNode {
    // fillMesh 设置为NO，会空出眼睛和嘴巴的区域
    ARSCNFaceGeometry *faceGeometry = [ARSCNFaceGeometry faceGeometryWithDevice:self.sceneView.device fillMesh:NO];
    
    switch (self.virtualFaceType) {
        case XHBVirtualFaceTypeMesh:
            self.meshFaceNode = [[XHBMeshFaceNode alloc] initWithFaceGeometry:faceGeometry];
            self.virtualFaceNode = (SCNNode *)self.meshFaceNode;
            // 更改场景的背景内容
            self.sceneView.scene.background.contents = [UIColor blackColor];
            //            self.sceneView.scene.background.contents = [UIImage imageNamed:@"head"];
            break;
        case XHBVirtualFaceTypeMask:
            self.maskFaceNode = [[XHBMaskFaceNode alloc] initWithFaceGeometry:faceGeometry];
            self.virtualFaceNode = (SCNNode *)self.maskFaceNode;
            break;
        case XHBVirtualFaceTypeRobot:
            self.robotFaceNode = [[XHBRobotFaceNode alloc] init];
            self.virtualFaceNode = (SCNNode *)self.robotFaceNode;
            self.sceneView.scene.background.contents = [UIColor lightGrayColor];
            break;
    }
}

/** 设置追踪会话 */
- (void)p_setupTrackingSession {
    // 是否可以使用面部追踪
    if (!ARFaceTrackingConfiguration.isSupported) { return; }
    
    // 禁用系统的“空闲计时器”，防止屏幕进入屏幕变暗的睡眠状态
    [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
    
    ARFaceTrackingConfiguration *configuration = [[ARFaceTrackingConfiguration alloc] init];
    // YES，为 trackingSession 中捕获的 ARFrame 对象的 lightEstimate 属性提供场景照明信息
    [configuration setLightEstimationEnabled:YES];
    [self.trackingSession runWithConfiguration:configuration
                                       options:ARSessionRunOptionResetTracking | ARSessionRunOptionRemoveExistingAnchors];
}

/** 设置现实面部节点的内容 */
- (void)p_setupFaceNodeContent {
    if (!self.faceNode) { return; }
    
    if (self.virtualFaceNode) {
        [self.faceNode addChildNode:self.virtualFaceNode];
    }
    
    // 添加人脸坐标轴
//        [self.faceNode addChildNode:self.axesNode];
}

#pragma mark -
#pragma mark -------------------- ARSCNViewDelegate --------------------
- (void)renderer:(id<SCNSceneRenderer>)renderer didAddNode:(SCNNode *)node forAnchor:(ARAnchor *)anchor {
    self.faceNode = node;
    [self p_setupFaceNodeContent];
    
//    ARFaceAnchor *faceAnchor = (ARFaceAnchor *)anchor;
//    NSLog(@"拓扑结构的三角形数量：%@", @(faceAnchor.geometry.triangleCount));
//    NSLog(@"拓扑结构的顶点坐标数量：%@", @(faceAnchor.geometry.vertexCount));
//    NSLog(@"拓扑结构的纹理坐标数量：%@", @(faceAnchor.geometry.textureCoordinateCount));
}

- (void)renderer:(id<SCNSceneRenderer>)renderer didUpdateNode:(SCNNode *)node forAnchor:(ARAnchor *)anchor {
    if (!anchor) { return; }
    
    switch (self.virtualFaceType) {
        case XHBVirtualFaceTypeMesh:
            [self.meshFaceNode updateWithFaceAnchor:(ARFaceAnchor *)anchor];
            break;
        case XHBVirtualFaceTypeMask:
            [self.maskFaceNode updateWithFaceAnchor:(ARFaceAnchor *)anchor];
            break;
        case XHBVirtualFaceTypeRobot:
            [self.robotFaceNode updateWithFaceAnchor:(ARFaceAnchor *)anchor];
            break;
    }
}

#pragma mark -
#pragma mark -------------------- Setter --------------------
- (void)setVirtualFaceNode:(SCNNode *)virtualFaceNode {
    _virtualFaceNode = virtualFaceNode;
    
    [self p_setupFaceNodeContent];
}

#pragma mark -
#pragma mark -------------------- Getter --------------------
- (ARSCNView *)sceneView {
    if (!_sceneView) {
        _sceneView = [[ARSCNView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
//        _sceneView.scene.background.contents = [UIColor lightGrayColor];
        _sceneView.delegate = self;
        _sceneView.automaticallyUpdatesLighting = YES;
    }
    return _sceneView;
}

- (ARSession *)trackingSession {
    return self.sceneView.session;
}

- (SCNNode *)axesNode {
    if (!_axesNode) {
        _axesNode = [[XHBVirtualFaceManager sharedInstance] getVirtualContentNodeWithResourceName:@"coordinateOrigin"];
    }
    return _axesNode;
}

@end
