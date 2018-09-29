//
//  XHBVirtualFaceViewController.h
//  FaceTracking
//
//  Created by 谢海邦 on 2018/9/25.
//  Copyright © 2018 XHB. All rights reserved.
//

#import <UIKit/UIKit.h>

/** 虚拟面部节点的类型 */
typedef NS_ENUM(NSInteger, XHBVirtualFaceType) {
    XHBVirtualFaceTypeMesh,     /**< 面部拓扑的网格 */
    XHBVirtualFaceTypeMask,     /**< 面具 */
    XHBVirtualFaceTypeRobot     /**< 机器人 */
};

NS_ASSUME_NONNULL_BEGIN

@interface XHBVirtualFaceViewController : UIViewController

- (instancetype)initWithVirtualFaceType:(XHBVirtualFaceType)virtualFaceType;

@end

NS_ASSUME_NONNULL_END
