//
//  ViewController.m
//  ProjectDemo
//
//  Created by zzf on 2018/12/4.
//  Copyright © 2018 wozaijia. All rights reserved.
//

#import "ViewController.h"
#import "Test1ViewController.h"
#import "Test2ViewController.h"
#import "DiskCacheTestViewController.h"

@interface ViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

/**
 key : class_name  value : NSString
 key : title_Name  value : NSString
 */
@property (nonatomic, strong) NSArray<NSDictionary<NSString *, NSString *> *> *sourceArray;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.sourceArray = @[@{@"title_Name" : @"text 1",
                           @"class_name" : @"Test1ViewController"},
                         @{@"title_Name" : @"text 2",
                           @"class_name" : @"Test2ViewController"},
                         @{@"title_Name" : @"disk cache",
                           @"class_name" : @"DiskCacheTestViewController"},
                         ];

    [self.view addSubview:self.tableView];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];

    CGRect frame = [UIApplication sharedApplication].delegate.window.frame;
    self.tableView.frame = CGRectMake(0.0f, 88.0f, frame.size.width, frame.size.height);
}

#pragma mark - UITableViewDataSource Methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.sourceArray.count;
}

//子类自定义
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Hello_World"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Hello_World"];
    }

    NSDictionary *sourceDict = self.sourceArray[indexPath.row];
    cell.textLabel.text = sourceDict[@"title_Name"];

    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *) indexPath {
    return 44.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *sourceDict = self.sourceArray[indexPath.row];
    NSString *className = sourceDict[@"class_name"];
    NSString *titleName = sourceDict[@"title_Name"];
    NSLog(@"\ntitle_name %@\nclass_name %@", sourceDict[@"title_Name"], sourceDict[@"class_name"]);

    UIViewController *vc = [[NSClassFromString(className) alloc] init];
    vc.title = titleName;
    [self.navigationController pushViewController:vc animated:YES];
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}

@end
