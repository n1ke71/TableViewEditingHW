//
//  Student.h
//  TableViewEditingHW
//
//  Created by Ivan Kozaderov on 26.06.2018.
//  Copyright © 2018 n1ke71. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Student : NSObject

@property (strong, nonatomic) NSString *firstName;
@property (strong, nonatomic) NSString *lastName;
@property (assign, nonatomic) CGFloat   averageGrage;
@property (strong, nonatomic) UIColor *averageGrageColor;

+ (Student *)randomStudent;

@end
