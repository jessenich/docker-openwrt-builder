# Compiling OpenWRT Firmware from Source

## Links

[Rock PI E Wiki Link (https://wiki.radxa.com/RockpiE/OpenWRT#Compiling_OpenWrt_for_ROCK_Pi_E)](https://wiki.radxa.com/RockpiE/OpenWRT#Compiling_OpenWrt_for_ROCK_Pi_E)

[GitHub Source](https://github.com/jayanta525/rk3328-rock-pi-e)

## Compiling OpenWrt for ROCK Pi E

```bash
## Skip to 2nd section
## Performed by docker build
git clone --depth 1 [https://github.com/jayanta525/rock-pi-e.git](https://github.com/jayanta525/rock-pi-e.git) openwrt/
cd openwrt/


## START HERE! 
./scripts/feeds update -a
./scripts/feeds install -a


## Start build process within container, select device and required packages here
make menuconfig

## Compile sources
make -j$(nproc)
```

## Selecting device in menuconfig

```text
   Target System > Rockchip

   Subtarget > RK33xx boards (64 bit)

   Target Profile > Radxa Rock Pi E
```

## Selecting web-interface in menuconfig

For installing web-interface in OpenWrt during compilation, select the packages in menuconfig

```text
   LuCi > Collection > luci
```

## Selecting i2c in menuconfig

For using i2c in OpenWrt during compilation, select the packages in menuconfig

```text
   Kernel Modules > kmod-i2c-core

   Kernel Modules > kmod-i2c-gpio

   Kernel Modules > kmod-i2c-gpio-custom

   Utilities > i2c-tools
```

## Selecting python in menuconfig

For installing python in OpenWrt during compilation, select the packages in menuconfig

```text
   Languages > Python > python

   Languages > Python > python-dev
```

## Changelog

2020.07.28

**\[download [https://jayanta525.gitlab.io/openwrt-rockpie/](https://jayanta525.gitlab.io/openwrt-rockpie/)\]**

* Updated to latest master
* Boost up to 1.5GHz
* Separate feed repository
* opkg install support
