<a href='https://github.com/popor/mybox'> MyBox </a>

# PoporNetRecord

[![CI Status](https://img.shields.io/travis/wangkq/PoporNetRecord.svg?style=flat)](https://travis-ci.org/wangkq/PoporNetRecord)
[![Version](https://img.shields.io/cocoapods/v/PoporNetRecord.svg?style=flat)](https://cocoapods.org/pods/PoporNetRecord)
[![License](https://img.shields.io/cocoapods/l/PoporNetRecord.svg?style=flat)](https://cocoapods.org/pods/PoporNetRecord)
[![Platform](https://img.shields.io/cocoapods/p/PoporNetRecord.svg?style=flat)](https://cocoapods.org/pods/PoporNetRecord)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

思路模仿自LLDebugTool, https://github.com/HDB-Li/LLDebugTool.git ,但是我只需要监测所有的网络请求,另外其他需求也不一致,所以有了本framework.

```
若想在Web页面显示 WIFI 名称，需要针对iOS12在Xcode中设置。
参考详情:https://www.jianshu.com/p/751625d4d282

选择Target，在Capabilities中，激活Access WiFi Infomation项。
```
<p>
<img src="https://github.com/popor/PoporNetRecord/blob/master/Example/PoporNetRecord/image/AccessWifiInformation.png" width="100%" height="100%">

</p>

## Requirements

## Installation

PoporNetRecord is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'PoporNetRecord'
```

```
修改弹出方式

PnrConfig * config = [PnrConfig share];
config.presentNCBlock = ^(UINavigationController *nc) {
    // ... other
    nc.modalPresentationStyle = UIModalPresentationFullScreen;
}

```

<p>
<img src="https://github.com/popor/PoporNetRecord/blob/master/Example/PoporNetRecord/image/root.png" width="30%" height="30%">
<img src="https://github.com/popor/PoporNetRecord/blob/master/Example/PoporNetRecord/image/list.png" width="30%" height="30%">
<img src="https://github.com/popor/PoporNetRecord/blob/master/Example/PoporNetRecord/image/detail.png" width="30%" height="30%">

</p>

```
电脑浏览器访问,假如使用chrome或者QQ浏览器,安装json-handle插件,可以点击[数据返回]进行更好的查看json数据
```
<p>
<img src="https://github.com/popor/PoporNetRecord/blob/master/Example/PoporNetRecord/image/web1.png" width="100%" height="100%">
<img src="https://github.com/popor/PoporNetRecord/blob/master/Example/PoporNetRecord/image/web2.png" width="100%" height="100%">
<img src="https://github.com/popor/PoporNetRecord/blob/master/Example/PoporNetRecord/image/web3.png" width="100%" height="100%">
</p>

1.07
详情页面增加再次转发功能

1.09
增加PnrBlockPVoid viewDidloadBlock; 方便设定ballBT属性

1.10
防止iPhoneX屏幕, bt位于屏幕正上方无法点击
autoFixIphoneXFrame : 默认为YES, 防止ballBT位于在屏幕上方出现, iPhoneX机型可能无法点击到ballBT.

1.11
参数属性修改,不然假如传递来的参数是NSMutableString,会造成不知名的修改数据.
来自:https://github.com/ChenYilong/iOSInterviewQuestions/blob/master/01%E3%80%8A%E6%8B%9B%E8%81%98%E4%B8%80%E4%B8%AA%E9%9D%A0%E8%B0%B1%E7%9A%84iOS%E3%80%8B%E9%9D%A2%E8%AF%95%E9%A2%98%E5%8F%82%E8%80%83%E7%AD%94%E6%A1%88/%E3%80%8A%E6%8B%9B%E8%81%98%E4%B8%80%E4%B8%AA%E9%9D%A0%E8%B0%B1%E7%9A%84iOS%E3%80%8B%E9%9D%A2%E8%AF%95%E9%A2%98%E5%8F%82%E8%80%83%E7%AD%94%E6%A1%88%EF%BC%88%E4%B8%8A%EF%BC%89.md

```
摘自上面网页注释
下面做下解释： copy 此特质所表达的所属关系与 strong 类似。然而设置方法并不保留新值，而是将其“拷贝” (copy)。 当属性类型为 NSString 时，经常用此特质来保护其封装性，因为传递给设置方法的新值有可能指向一个 NSMutableString 类的实例。这个类是 NSString 的子类，表示一种可修改其值的字符串，此时若是不拷贝字符串，那么设置完属性之后，字符串的值就可能会在对象不知情的情况下遭人更改。所以，这时就要拷贝一份“不可变” (immutable)的字符串，确保对象中的字符串值不会无意间变动。只要实现属性所用的对象是“可变的” (mutable)，就应该在设置新属性值时拷贝一份。

用 @property 声明 NSString、NSArray、NSDictionary 经常使用 copy 关键字，是因为他们有对应的可变类型：NSMutableString、NSMutableArray、NSMutableDictionary，他们之间可能进行赋值操作，为确保对象中的字符串值不会无意间变动，应该在设置新属性值时拷贝一份。
```

@property (nonatomic, strong) NSString => @property (nonatomic, copy  ) NSString

## Author

wangkq, 908891024@qq.com

## License

PoporNetRecord is available under the MIT license. See the LICENSE file for more info.
