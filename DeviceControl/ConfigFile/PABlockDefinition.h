//
//  PABlockDefinition.h
//  TimeHomeApp
//
//  Created by WangKeke on 2018/3/24.
//  Copyright © 2018年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "AppType.h"

#ifndef PABlockDefinition_h
#define PABlockDefinition_h

/**
 *  网络请求完成后调用的Block
 *
 *  @param data     data 处理后数据回传
 *  @param response response 返回响应对象
 *  @param error    error 处理过程中发生的错误信息
 */
typedef void (^TaskCompleteBlock)(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error);

/**
 *  命令执行结果完成后返回结果
 *
 *  @param data       data 处理后数据回传
 *  @param resultCode resultCode 处理成功或失败码
 *  @param Error      Error 处理过程中发生的错误信息
 */
typedef void (^CommandCompleteBlock)(id  _Nullable data,ResultCode resultCode,NSError * _Nullable Error);

/**
 *  命令执行结果完成后更新Views
 *
 *  @param data  data 处理后数据回传
 *  @param resultCode resultCode 处理成功或失败码
 */
typedef void (^UpDateViewsBlock)(id  _Nullable data,ResultCode resultCode);

/**
 *  视图事件回调
 *
 *  @param data  data 回传数据
 *  @param view  view 处发事件iew
 *  @param index index 处发事件索引或列表索引
 */
typedef void (^ViewsEventBlock)(id _Nullable data,UIView *_Nullable view,NSInteger index);

/**
 *  列表视图事件回调
 *
 *  @param data     data 回传数据
 *  @param view  view 处发事件iew
 *  @param index index 处发事件索引或列表索引
 */
typedef void (^CellEventBlock)(id _Nullable data,UIView *_Nullable view,NSIndexPath *_Nullable index);

/**
 *  @param data     data 处理后数据回传
 *  @param bluetoothCode    bluetoothCode 处理事件码
 */
typedef void (^BluetoothEventBlock)(id  _Nullable data,BluetoothCode bluetoothCode);

/**
 *  @param data     data 处理后数据回传
 *  @param bluetoothCode    bluetoothCode 处理事件码
 */
typedef void (^PAWaterBluetoothEventBlock)(id  _Nullable data,PAWaterResponseType bluetoothCode);

/**
 *  弹框点击事件处理回调
 *  @param index  alert弹出框的按钮序号
 *
 */

typedef void (^AlertBlock)(NSInteger index);

/*YTKNetwork请求使用的block*/

@class PABaseRequest;
@class PABaseResponseModel;

typedef void(^requestSuccessBlock)(PABaseResponseModel *   _Nullable responseModel, PABaseRequest * _Nullable request);
typedef void(^requestFailedBlock)(NSError * _Nullable error, PABaseRequest * _Nullable request);


#endif /* PABlockDefinition_h */
