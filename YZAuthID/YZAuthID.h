/************************************************************
 Class    : YZAuthID.h
 Describe : TouchID/FaceID 认证方法
 Company  : Micyo
 Author   : Yanzheng
 Date     : 2018-07-26
 Version  : 2.0
 Declare  : Copyright © 2018 Yanzheng. All rights reserved.
 ************************************************************/

#import <LocalAuthentication/LocalAuthentication.h>

/**
 *  TouchID/FaceID 状态
 */
typedef NS_ENUM(NSUInteger, YZAuthIDState){
    
    /**
     *  当前设备不支持TouchID/FaceID
     */
    YZAuthIDStateNotSupport = 0,
    /**
     *  TouchID/FaceID 验证成功
     */
    YZAuthIDStateSuccess = 1,
    
    /**
     *  TouchID/FaceID 验证失败
     */
    YZAuthIDStateFail = 2,
    /**
     *  TouchID/FaceID 被用户手动取消
     */
    YZAuthIDStateUserCancel = 3,
    /**
     *  用户不使用TouchID/FaceID,选择手动输入密码
     */
    YZAuthIDStateInputPassword = 4,
    /**
     *  TouchID/FaceID 被系统取消 (如遇到来电,锁屏,按了Home键等)
     */
    YZAuthIDStateSystemCancel = 5,
    /**
     *  TouchID/FaceID 无法启动,因为用户没有设置密码
     */
    YZAuthIDStatePasswordNotSet = 6,
    /**
     *  TouchID/FaceID 无法启动,因为用户没有设置TouchID/FaceID
     */
    YZAuthIDStateTouchIDNotSet = 7,
    /**
     *  TouchID/FaceID 无效
     */
    YZAuthIDStateTouchIDNotAvailable = 8,
    /**
     *  TouchID/FaceID 被锁定(连续多次验证TouchID/FaceID失败,系统需要用户手动输入密码)
     */
    YZAuthIDStateTouchIDLockout = 9,
    /**
     *  当前软件被挂起并取消了授权 (如App进入了后台等)
     */
    YZAuthIDStateAppCancel = 10,
    /**
     *  当前软件被挂起并取消了授权 (LAContext对象无效)
     */
    YZAuthIDStateInvalidContext = 11,
    /**
     *  系统版本不支持TouchID/FaceID (必须高于iOS 8.0才能使用)
     */
    YZAuthIDStateVersionNotSupport = 12
};


@interface YZAuthID : LAContext

typedef void (^YZAuthIDStateBlock)(YZAuthIDState state, NSError *error);

/**
 * 启动TouchID/FaceID进行验证
 * @param describe TouchID/FaceID显示的描述
 * @param block 回调状态的block
 */
- (void)yz_showAuthIDWithDescribe:(NSString *)describe block:(YZAuthIDStateBlock)block;

@end
