//
//  Student.m
//  TableViewEditingHW
//
//  Created by Ivan Kozaderov on 26.06.2018.
//  Copyright © 2018 n1ke71. All rights reserved.
//

#import "Student.h"

@implementation Student

static NSString *firstNames[] = { @"Tran",@"Lenore",@"Bud",@"Fredda",@"Katrise",
    @"Hildegard",@"Vernell",@"Nellie",@"Rupert",@"Billie",
    @"Tamica",@"Crystle",@"Kandy",@"Caridad",@"Vanetta"};


static NSString *lastNames[] = { @"Farrah",@"Laviolette",@"Heal",@"Sechrest",@"Roots",
    @"Prill",@"Lush",@"Piedra",@"Yocum",@"Warnock",
    @"Vanderlinden",@"Simms",@"Gilroy",@"Brann",@"Bodden"};

+ (Student *)randomStudent{
    
    Student *student = [[Student alloc]init];
    student.firstName    = firstNames[arc4random_uniform(15)];
    student.lastName     = lastNames [arc4random_uniform(15)];
    student.averageGrage = (arc4random() % 301 + 200) / 100;
    
    
    if (student.averageGrage > 4.) {
        
        student.averageGrageColor = [UIColor greenColor];
        
    }
    else if (student.averageGrage > 3.){
        
        student.averageGrageColor = [UIColor yellowColor];
        
    }
    else if (student.averageGrage <= 3.){
        
        student.averageGrageColor = [UIColor redColor];
        
    }
    return student;
}


@end
