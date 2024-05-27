fastlane documentation
----

# Installation

Make sure you have the latest version of the Xcode command line tools installed:

```sh
xcode-select --install
```

For _fastlane_ installation instructions, see [Installing _fastlane_](https://docs.fastlane.tools/#installing-fastlane)

# Available Actions

## iOS

### ios snap

```sh
[bundle exec] fastlane ios snap
```

截图

### ios test

```sh
[bundle exec] fastlane ios test
```



### ios develop

```sh
[bundle exec] fastlane ios develop
```

打包 development 包

### ios upload_to_pgy

```sh
[bundle exec] fastlane ios upload_to_pgy
```

打包+上传到蒲公英平台 development 包

### ios jenkinsDev

```sh
[bundle exec] fastlane ios jenkinsDev
```

jenkins 打包 development 包

### ios ad_hoc

```sh
[bundle exec] fastlane ios ad_hoc
```

打包ad-hoc包

### ios release

```sh
[bundle exec] fastlane ios release
```

打包正式包

### ios package

```sh
[bundle exec] fastlane ios package
```

打包函数

### ios pgy

```sh
[bundle exec] fastlane ios pgy
```

打包到蒲公英函数

### ios tf

```sh
[bundle exec] fastlane ios tf
```

上传testflight

### ios all

```sh
[bundle exec] fastlane ios all
```



----

This README.md is auto-generated and will be re-generated every time [_fastlane_](https://fastlane.tools) is run.

More information about _fastlane_ can be found on [fastlane.tools](https://fastlane.tools).

The documentation of _fastlane_ can be found on [docs.fastlane.tools](https://docs.fastlane.tools).
