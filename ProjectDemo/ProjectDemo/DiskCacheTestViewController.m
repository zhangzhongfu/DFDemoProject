//
//  DiskCacheTestViewController.m
//  ProjectDemo
//
//  Created by zzf on 2018/12/4.
//  Copyright © 2018 wozaijia. All rights reserved.
//

#import "DiskCacheTestViewController.h"
#import <DiskCacheHeader.h>
#import <BDBSDiskCacheManager.h>

@interface DiskCacheTestViewController ()

@end

@implementation DiskCacheTestViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self test];
    });
}

- (void)test {
    for (int i = 1; i <= 5; i++) {
        NSString *queueName = [NSString stringWithFormat:@"com.wozaijia.diskCache.test%d", i];
        dispatch_queue_t concurrentQueue = dispatch_queue_create([queueName UTF8String], DISPATCH_QUEUE_CONCURRENT);
        dispatch_async(concurrentQueue, ^{
            for (int j = 0; j < 100; j++) {
                NSString *key = [NSString stringWithFormat:@"key_%d_%d",i, j];
                int random = rand() % 20;
                NSMutableString *value = [NSMutableString string];
                for(int k = 0; k < random; k++) {
                    [value appendFormat:@"%@random%d", value, k];
                }
                NSDictionary *dict = @{key : value};
                [[BDBSDiskCacheManager sharedInstance] saveObject:dict
                                                              key:key
                                                       expireTime:(2 * rand() % 10)
                                                         complete:^(BOOL completed, id object, NSError *cacheError, NSString *filepath) {
                                                             DiskCacheLog(@"completed %@ \nerrorMessage %@\nfilePath %@", completed ? @"写入成功" : @"写入失败", cacheError, filepath);
                                                         }];
            }
        });
    }
    for (int i = 0; i < 1; i++) {
        NSString *key = [NSString stringWithFormat:@"key_%d", i];
        NSDictionary *dict = @{key : [NSString stringWithFormat:@"value_%d", i]};
        [[BDBSDiskCacheManager sharedInstance] saveObject:dict
                                                      key:key
                                               expireTime:(2 * rand() % 10)
                                                 complete:^(BOOL completed, id object, NSError *cacheError, NSString *filepath) {
                                                     DiskCacheLog(@"completed %@ \nerrorMessage %@\nfilePath %@", completed ? @"写入成功" : @"写入失败", cacheError, filepath);
                                                 }];
    }

    //    [BDBSDiskCacheManager removeObjectWithKey:@"test_dict" complete:^(BOOL completed, id object, NSError *cacheError, NSString *filepath) {
    //        DiskCacheLog(@"\ncacheError %@\ncompleted %@", cacheError, completed ? @"删除成功" : @"删除失败");
    //    }];
    [[BDBSDiskCacheManager sharedInstance] saveObject:@"StringTest" key:@"UIViewControllerKey"];

    //    self.title = @"hello test";
    //    [[BDBSDiskCacheManager sharedInstance] saveObject:self key:@"UIViewControllerKey"];

    [[BDBSDiskCacheManager sharedInstance] readObjectWithKey:@"UIViewControllerKey"
                                                    complete:^(BOOL completed, UIViewController *object, NSError *cacheError, NSString *filepath) {
                                                        DiskCacheLog(@"object %@", object);
                                                    }];

    [[BDBSDiskCacheManager sharedInstance] removeObjectWithKey:@"UIViewControllerKey"
                                                      complete:^(BOOL completed, id object, NSError *cacheError, NSString *filepath) {
                                                          NSLog(@"cacheError %@ filepath %@", cacheError, filepath);
                                                      }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
