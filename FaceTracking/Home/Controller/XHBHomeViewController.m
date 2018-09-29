//
//  XHBHomeViewController.m
//  FaceTracking
//
//  Created by 谢海邦 on 2018/9/25.
//  Copyright © 2018 XHB. All rights reserved.
//

#import "XHBHomeViewController.h"
#import "XHBVirtualFaceViewController.h"
#import "XHBHomeCell.h"

static NSString *cellIdentifier = @"XHBHomeCell";

@interface XHBHomeViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, copy) NSArray *menuArray;
@property (nonatomic, strong) UITableView *tableView;
@end

@implementation XHBHomeViewController

#pragma mark -
#pragma mark -------------------- Life Cycle --------------------
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self p_drawView];
}

#pragma mark -
#pragma mark -------------------- Draw --------------------
- (void)p_drawView {
    self.title = @"首页";
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.tableView];
}

#pragma mark -
#pragma mark -------------------- UITableViewDataSource --------------------
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.menuArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    XHBHomeCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    [cell configCellWithTitle:self.menuArray[indexPath.row]];
    return cell;
}

#pragma mark -
#pragma mark -------------------- UITableViewDelegate --------------------
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    XHBVirtualFaceViewController *virtualFaceVC = [[XHBVirtualFaceViewController alloc] initWithVirtualFaceType:indexPath.row];
    [self.navigationController pushViewController:virtualFaceVC animated:YES];
}

#pragma mark -
#pragma mark -------------------- Getter --------------------
- (NSArray *)menuArray {
    return @[@"面部拓扑的网格", @"面具", @"机器人"];
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerClass:[XHBHomeCell class] forCellReuseIdentifier:cellIdentifier];
    }
    return _tableView;
}

@end
