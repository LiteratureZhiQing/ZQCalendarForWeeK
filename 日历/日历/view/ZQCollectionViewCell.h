//
//  CollectionViewCell.h
//  日历
//
//  Created by zhiqing on 16/7/21.
//  Copyright © 2016年 asdfghj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZQCalendarModel.h"
@interface ZQCollectionViewCell : UICollectionViewCell
@property(nonatomic,strong)  ZQCalendarModel*dateModel;
@end
