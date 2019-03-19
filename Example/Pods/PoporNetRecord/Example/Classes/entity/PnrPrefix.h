
//
//  PnrPrefix.h
//  PoporNetRecord
//
//  Created by apple on 2019/3/11.
//  Copyright © 2019 wangkq. All rights reserved.
//

#ifndef PnrPrefix_h
#define PnrPrefix_h

#import "PnrEntity.h"

typedef void(^PnrBlockPVoid) (void);
typedef void(^PnrBlockPPnrEntity) (PnrEntity * pnrEntity);
typedef void(^PnrBlockFeedback) (NSString * feedback);
typedef void(^PnrBlockResubmit) (PnrEntity * pnrEntity, NSDictionary * formDic, PnrBlockFeedback _Nonnull blockFeedback);

#endif /* PnrPrefix_h */
