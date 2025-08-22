//
//  MGHttpMacros.h
//  Magina
//
//  Created by mac on 2025/8/12.
//

#ifndef MGHttpMacros_h
#define MGHttpMacros_h

//登录接口改为login.long.tv, 普通域名调整为longtv.long.tv；

/** IP */

#define HTTP_ENVIROMENT_TYPE  1 //1 正式服务器 0 测试服务器
#define Http_LongMal_enviroment_Type 1 //1正式情况 0 测试商城(使用dist2文件)

#if HTTP_ENVIROMENT_TYPE  ==  1  // 正式环境
//login.long.tv(估计后面用这个)
#define kHttpTotalService @"http://longtv.long.tv" //总后台  对应的IP: 103.82.219.46
//myzen得带后缀 统一在添加的时候都去掉
#define kDynamicSubService [LSUserCenter shareInstance].selectIptvModel.domainName
#define kUpdateLongmallDomain @"http://upgrade.long.tv" //商城升级
#define kMallService @"https://mall.long.tv" //http://mall.long.tv
//新增两个
#define kHttpLoginService @"http://login.long.tv" //登录/注册域名接口使用
#define kCommonDomainService @"http://longtv.long.tv" //普通域名接口
#define kLongMallUrl @"https://mall.long.tv/" //商城的Url链接 //之前用的http://mall.long.tv/mall/
//大会员
#define kBigMembershipService @"https://memberlevel.long.tv/"

//longPartner
#define kLongPartnerService @"http://api.partner.long.tv"

//新版LongTV新增的服务器地址
#define kNewAddedLongTVService @"https://api-video.long.tv"

///////////////////////////////// enjoy
#define kQwyEnjoyShortsService @"https://video-api.enjoyshorts.com"
#define kQwyEnjoyUserService   @"https://user.enjoyshorts.com"

#define kLjwEnjoyTaskService @"https://task.enjoyshorts.com"
#define kLjwEnjoyJoysService @"https://points.enjoyshorts.com"

#define kLxcEnjoyCommentService @"https://comment.enjoyshorts.com" //专门评论用
#define kLxcEnjoyRecordService  @"https://record.enjoyshorts.com"
#define kLxcEnjoyUploadService  @"https://upload.enjoyshorts.com" //上报、点赞、收藏
#define kLxcEnjoySharedService  @"https://enjoyshorts.com" //分享、下载
/////////////////////////////////

///////////////////////////////// magina
#define kMaginaService @"https://user.magina.net"
#define kLjwMaginaService @"https://points.magina.net"
/////////////////////////////////

#elif HTTP_ENVIROMENT_TYPE == 0 // 测试环境
#define kHttpTotalService @"http://10.20.63.215:39036"
#define kDynamicSubService [LSUserCenter shareInstance].selectIptvModel.domainName
#define kUpdateLongmallDomain @"http://tt.lemmovie.com"
#define kMallService @"http://103.82.219.42:39050"
//新增两个
#define kHttpLoginService @"http://10.20.63.215:39036"
#define kCommonDomainService @"http://10.20.63.215:39036"
#define kLongMallUrl @"http://10.20.63.130:39050/mall/"
//大会员
//http://10.20.63.215:39036
#define kBigMembershipService @"http://103.82.219.42:39334/" //测试环境改为http://103.82.219.42:39334

//longPartner
#define kLongPartnerService @"http://10.11.89.106:39223"

//新版LongTV新增的服务器地址
#define kNewAddedLongTVService @"http://23.237.60.122:39225"

///////////////////////////////// enjoy
#define kQwyEnjoyShortsService @"http://23.237.232.226:39148"
#define kQwyEnjoyUserService   @"http://23.237.232.226:39148"

#define kLjwEnjoyTaskService @"http://103.82.219.73:39133"
#define kLjwEnjoyJoysService @"http://103.82.219.73:39133"

#define kLxcEnjoyCommentService @"http://103.82.219.73:39132"
#define kLxcEnjoyRecordService  @"http://103.82.219.73:39132"
#define kLxcEnjoyUploadService  @"http://103.82.219.73:39132"
/////////////////////////////////

//////////////////////////////////// magina
#define kMaginaService @"https://user.magina.ai"
#define kLjwMaginaService @"https://points.magina.net"
/////////////////////////////////

#endif


#define api_ip_baseOffice [NSString stringWithFormat:@"%@/api/",kHttpTotalService]
//http://api.snaca.com/
//#define api_ip_baseOffice_update [NSString stringWithFormat:@"%@/",kHttpTotalService]
//当前http://api.lemmovie.com/ 是通的 之前用的http://api.snaca.com
#define kAppUpdateApi @"http://upgrade.long.tv/"
#define kAppUpdateService @"http://upgrade.long.tv"



//**html相关界面
#define kHtmlNormalQuestionPage @"http://api.snaca.com/api/customer/Phone_Page/Aboutus" //vip购买常见问题
#define kHtmlVipProtocolPage @"http://api.snaca.com/api/customer/Phone_Page/Aboutus"
//**end

//***固定的iptv
//大会员iptv
#define kBigMembershipHost @"vip.cp.long.tv"
#define kBigMembershipIptvUrl @"http://vip.cp.long.tv"
//***end

////longPartner
//#define kLongPartnerTestService @"http://10.11.89.106:39223"

#endif /* MGHttpMacros_h */
