//
//  DataModel.h
//  TableViewLinkageDemo
//
//  Created by 思 彭 on 2017/7/25.
//  Copyright © 2017年 思 彭. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataModel : NSObject

@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *name;

@end

@interface CategoryModel : NSObject

@property (nonatomic, copy) NSString *categoryName;
@property (nonatomic, strong) NSArray *list;

@end

