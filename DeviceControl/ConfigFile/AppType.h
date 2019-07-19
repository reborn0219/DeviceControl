//
//  AppType.h
//  TimeHomeApp
//
//  Created by us on 16/1/4.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//
/**
 定义新类型或枚举，所有新类型或枚举都在此定义
 **/
///房产认证状态枚举定义
typedef NS_ENUM(NSInteger,CertificationType)
{
    CertificationTypeThrough = 0,// 已通过并已授权
    CertificationTypeThroughNotAuthorized,//已通过未授权
    CertificationTypeNotThrough,// 未通过
    CertificationTypeInReview,// 审核中
    CertificationTypeAuthorized,// 已被授权
    CertificationTypeHidden,//马上认证
};

#ifndef AppType_h
#define AppType_h



//-----------------------枚举类型--------------------------------
//设备类型
//设备分类：-2 高清摄像头 -1 红外1 开关 2 多路开关 3 机械手类(31 窗帘 32 机械臂) 4 亮度调节类() 5 传感器() 6 报警类设备(61 红外报警器 62烟雾报警器 63 燃气报警器) 100电视遥控 101空调遥控

typedef enum
{
    ///高清摄像头
    DEVCamera=-2,
    ///红外
    DEVInfrared=-1,
    ///开关
    DEVSwith=1,
    ///多路开关
    DEVMultiwaySwitch=2,
    ///窗帘
    DEVCurtain=31,
    ///机械臂
    DEVManipulator=32,
    ///亮度调节类
    DEVBrightness=4,
    ///温湿度传感器
    DEVWenShi=51,
    ///温湿光传感器
    DEVWenShiGuang=52,
    ///红外报警器
    DEVInfraredAlarm=61,
    ///烟雾报警器
    DEVSmokeAlarm=62,
    ///燃气报警器
    DEVGasAlarm=63,
    ///电视遥控
    DEVTVRemoteControl=100,
    ///空调遥控
    DEVKongTiaoControl=101,
    ///扫地机器人遥控
    DEVSweepRobotControl=102,
    
}DevType;



//网络错误码
typedef NS_ENUM(NSInteger,NETWorkErrorCode)
{
    ///没有数据
    NETNothingData=-2,
    ///Token失效 -1
    NETTokenInvalidErrorCode,
    ///服务器响应错误 0
    NETServerErrorCode,
    ///网络响应成功 1
    NETSucceedErrorCode,
    ///网络无数据返回 2
    NETNoDataErrorCode,
    ///无网络 3
    NETNoWorkErrorCode,
    ///网络连接错误处理 4
    NETConnErrorCode,
    ///httpcode错误处理500,404等 5
    NETHttpCodeErrorCode,
};
///蓝牙事件处理码
typedef NS_ENUM(NSInteger,BluetoothCode)
{
 
    ///搜索蓝牙
    SearchBluetooth=1000,
    ///连接蓝牙
    ConntectBluetooth,
    ///蓝牙状态
    BluetoothState,
    ///发送指令
    SendCommd,
    ///测试
    SendTest,
    ///打开成功
    OpenOk,
    ///验证成功
    autoOk,
    ///创建成功
    initOk,
    ///获取定位广播成功
    advertisementOk,
    ///返回成功
    backOk,
    ///打开失败
    OpenError,
    ///没有设备权限
    NOAuthorize,
    ///没找到设备
    NoFindDev,
    ///找到的设备信息
    DevInfo,
    ///找到新设备
    DevNew,
};

// 无数据占位图的类型
typedef NS_ENUM(NSInteger, NoContentType) {
    /** 无数据 */
    NoContentTypeData   = 0,
    /** 无网络 */
    NoContentTypeNetwork = 1,
    /** 暂未发表 */
    NoContentTypePublish = 2,
    /** 二轮车管理--默认图标 */
    NoContentTypeBikeManager = 3,
    /** 车位详情_没有可管理的车位 */
    NoContentTypeCarManager = 4,
    /** 业主认证--空视图 */
    NoContentTypeCertify = 5,
    /** 有关兑换券图标 */
    NoContentTypeShopExchange = 6,
    /** 还没有关注朋友图标 */
    NoContentTypeAttentionFriends = 7,
    /** 无房产 */
    NoContentTypeHouseManager = 8,
    /** 无访客 */
    NoContentTypeVisitors = 9,
    /** 无收藏 */
    NoContentTypeCollections = 10,
    /**一键锁车无数据 */
    NoContentTypeSpeedyLock = 11,
    /**报修记录无数据 */
    NoContentTypeOnlineService = 12,
    /**我的红包列表无数据 */
    NoContentTypeMyRedList = 13,
    /**我的券列表无数据 */
    NoContentTypeMyCouponList = 14,
    /**无关联车辆*/
    NoAssociatedVehicle = 15,
    /**无新公告信息*/
    NoNewNoticeData = 16,
    /**无新房产信息*/
    NoNewHouseData = 17,
};


// 无数据占位图的类型
typedef NS_ENUM(NSInteger, PAResponseCodeType) {
    PAResponseCodeTypeSuccess = 0,//成功
    PAResponseCodeTypeTokenInvalid = 10000,//登录失效
    PAResponseCodeTypeServerInnerError = 98,//服务器内部错误
};

// 智能水机蓝牙返回结果类型
typedef NS_ENUM(NSInteger, PAWaterResponseType) {
    PAWaterLinkSuccess = 0,//连接成功 可进入下步消费买水
    PAWaterLinkFail, //连接失败
    PAWaterLinkException,//连接成功 出水未完成无法进行下步消费
    PAWaterBuySuccess,//投币成功
    PAWaterBluetoothException,  //手机蓝牙未打开或者其他问题不可用
    PAWaterPayResponseTimeOut, //投币支付指令超时
    PAWaterFindDeviceTimeOut, //搜索蓝牙超时
    PAWaterRepeatCoinOrder, //重复投币指令
    PAWaterDisConnect, //断开连接
};

#endif /* AppType_h */
