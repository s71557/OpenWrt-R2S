#!/bin/bash

# 移除 openwrt feeds 自带的核心包
rm -rf feeds/packages/net/{xray-core,v2ray-core,v2ray-geodata,sing-box}
git clone https://github.com/sbwml/openwrt_helloworld package/helloworld

# 更新 golang 1.22 版本
rm -rf feeds/packages/lang/golang
git clone https://github.com/sbwml/packages_lang_golang -b 22.x feeds/packages/lang/golang

#删除冲突插件
rm -rf $(find ./feeds/luci/ -type d -regex ".*\(argon\|argon\).*")

#修改默认主题
git clone -b 18.06 https://github.com/jerrykuku/luci-theme-argon.git ./package/lean/luci-theme-argon 
git clone -b 18.06 https://github.com/jerrykuku/luci-app-argon-config.git ./package/lean/luci-app-argon-config

#修改默认IP地址
sed -i "s/192\.168\.[0-9]*\.[0-9]*/$OpenWrt_IP/g" ./package/base-files/files/bin/config_generate

#修改默认主机名
sed -i "s/hostname='.*'/hostname='$OpenWrt_NAME'/g" ./package/base-files/files/bin/config_generate

#修改默认时区
sed -i "s/timezone='.*'/timezone='CST-8'/g" ./package/base-files/files/bin/config_generate
sed -i "/timezone='.*'/a\\\t\t\set system.@system[-1].zonename='Asia/Shanghai'" ./package/base-files/files/bin/config_generate

#编译6.1内核
#sed -i 's/5.15/6.1/g' ./target/linux/rockchip/Makefile
#sed -i 's/6.1/6.6/g' ./target/linux/x86/Makefile

#加入编译作者信息
new_name="StoneOS $(date +"%Y-%m-%d")"
sed -i "s/OpenWrt /$new_name/g" package/lean/default-settings/files/zzz-default-settings

#修改ssh登录信息
>package/base-files/files/etc/banner
echo -e '███████╗████████╗ ██████╗ ███╗   ██╗███████╗ ██████╗ ███████╗' >> package/base-files/files/etc/banner
echo -e '██╔════╝╚══██╔══╝██╔═══██╗████╗  ██║██╔════╝██╔═══██╗██╔════╝' >> package/base-files/files/etc/banner
echo -e '███████╗   ██║   ██║   ██║██╔██╗ ██║█████╗  ██║   ██║███████╗' >> package/base-files/files/etc/banner
echo -e '╚════██║   ██║   ██║   ██║██║╚██╗██║██╔══╝  ██║   ██║╚════██║' >> package/base-files/files/etc/banner
echo -e '███████║   ██║   ╚██████╔╝██║ ╚████║███████╗╚██████╔╝███████║' >> package/base-files/files/etc/banner
echo -e '╚══════╝   ╚═╝    ╚═════╝ ╚═╝  ╚═══╝╚══════╝ ╚═════╝ ╚══════╝\n' >> package/base-files/files/etc/banner
                                                             
#根据源码来修改
if [[ $OpenWrt_URL == *"lede"* ]] ; then
  #修改默认时间格式
  sed -i 's/os.date()/os.date("%Y-%m-%d %H:%M:%S %A")/g' $(find ./package/*/autocore/files/ -type f -name "index.htm")
fi
