//
//  Sigt.h
//  Sigteprofil
//
//  Created by coneits on 10/11/16.
//  Copyright © 2016 masterteam. All rights reserved.
//

#ifndef Sigt_h
#define Sigt_h


#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Sigt : NSManagedObject

@property (nonatomic, retain) NSString * navn;
@property (nonatomic, retain) NSString * date;
@property (nonatomic, retain) NSString * note;
@property (nonatomic, retain) NSString * under_percent;
@property (nonatomic, retain) NSString * middle_percent;
@property (nonatomic, retain) NSString * over_percent;
@end


#endif /* Sigt_h */
