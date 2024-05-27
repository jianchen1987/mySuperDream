source 'ssh://git@code.kh-super.net:7999/mob/chaos-specs.git'
source "https://sambo:ycfXmxxRbyzEmozY9z6n@gitlab.nbc.gov.kh/khqr/khqr-ios-pod.git"
source 'https://github.com/aliyun/aliyun-specs.git'
#source 'https://github.com/CocoaPods/Specs.git'
source 'https://gitee.com/mirrors/CocoaPods-Specs.git'


# Comment the next line if you don't want to use dynamic frameworks
use_frameworks!
platform :ios, '11.0'
inhibit_all_warnings!
# install! 'cocoapods', generate_multiple_pod_projects: true

def debug_pods
    pod 'LookinServer', :configurations => ['Debug']
    pod 'DoraemonKit/Core', :configurations => ['Debug']
#     pod 'JCLeaksFinder', :configurations => ['Debug']
#    pod 'MLeaksFinder', :git => "https://github.com/Tencent/MLeaksFinder.git"
    pod 'Bagel', :configurations => ['Debug']
end

# 引入部分组件使用 :subspecs => ['HDMediator', 'ScanCode']

def cj_local_pods
  pod 'HDKitCore', :path => '/Users/seeu/Documents/myProject/hdkitcore'
  pod 'HDUIKit', :path => '/Users/seeu/Documents/myProject/hduikit'
  pod 'HDServiceKit', :path => '/Users/seeu/Documents/myProject/hdservicekit'
  pod 'HDVendorKit', :path => '/Users/seeu/Documents/myProject/hdvendorkit'
  pod 'KSInstantMessagingKit'
end

def liwj_local_pods
  pod 'HDKitCore', :path => '/Users/xixi/wownow/HDKit/hdkitcore'
  pod 'HDUIKit', :path => '/Users/xixi/wownow/HDKit/hduikit'
  pod 'HDServiceKit', :path => '/Users/xixi/wownow/HDKit/HDServiceKit'
  pod 'HDVendorKit', :path => '/Users/xixi/wownow/HDKit/hdvendorkit'
  pod 'KSInstantMessagingKit'
end

def remote_pods
  pod 'HDKitCore'
  pod 'HDUIKit'
  pod 'HDServiceKit'
  pod 'HDVendorKit'
  pod 'KSInstantMessagingKit'
end

def pods
   pod 'Firebase/Core'
   pod 'Firebase/RemoteConfig'
   pod 'Stinger'
   pod 'MJRefresh'
   pod 'YYText'
   pod 'HXPhotoPicker/SDWebImage'
   pod 'WechatOpenSDK'
   pod 'FBSDKLoginKit'
   pod 'FBSDKShareKit'
   pod 'Bugly'
   pod 'YYModel', '~> 1.0.4'
   pod 'YBPopupMenu', '~> 1.1.6'
   pod 'JJStockView'
   pod "BakongKHQR", '1.0.0.12'
   pod 'lottie-ios', '~> 2.5.3'
   pod 'UICountingLabel'
   pod 'AlicloudHTTPDNS', '2.0.6'
end

target 'SuperApp' do
  
  # Pods for SuperApp
   debug_pods
   remote_pods
#   liwj_local_pods
   pods
end

target 'SuperAppTests' do
#  remote_pods
#  liwj_local_pods
#  pods
end


post_install do |installer|
  installer.aggregate_targets.each do |target|
    target.xcconfigs.each do |variant, xcconfig|
      xcconfig_path = target.client_root + target.xcconfig_relative_path(variant)
      IO.write(xcconfig_path, IO.read(xcconfig_path).gsub("DT_TOOLCHAIN_DIR", "TOOLCHAIN_DIR"))
    end
  end
  
  installer.pods_project.targets.each do |target|
    
    #适配xcode14.3 产生 Command PhaseScriptExecution failed with a nonzero exit code
    shell_script_path = "Pods/Target Support Files/#{target.name}/#{target.name}-frameworks.sh"
    if File::exists?(shell_script_path)
      shell_script_input_lines = File.readlines(shell_script_path)
      shell_script_output_lines = shell_script_input_lines.map { |line| line.sub("source=\"$(readlink \"${source}\")\"", "source=\"$(readlink -f \"${source}\")\"") }
      File.open(shell_script_path, 'w') do |f|
        shell_script_output_lines.each do |line|
          f.write line
        end
      end
    end
    
    target.build_configurations.each do |config|
      config.build_settings['CLANG_WARN_OBJC_IMPLICIT_RETAIN_SELF'] = 'NO'
      config.build_settings['EXPANDED_CODE_SIGN_IDENTITY'] = ""
      config.build_settings['CODE_SIGNING_REQUIRED'] = "NO"
      config.build_settings['CODE_SIGNING_ALLOWED'] = "NO"
      config.build_settings['ENABLE_STRICT_OBJC_MSGSEND'] = "NO"
      config.build_settings.delete 'IPHONEOS_DEPLOYMENT_TARGET'
      config.build_settings["EXCLUDED_ARCHS[sdk=iphonesimulator*]"] = "arm64"
      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '11.0'
      if config.base_configuration_reference.is_a? Xcodeproj::Project::Object::PBXFileReference
        xcconfig_path = config.base_configuration_reference.real_path
        IO.write(xcconfig_path, IO.read(xcconfig_path).gsub("DT_TOOLCHAIN_DIR", "TOOLCHAIN_DIR"))
      end
    end
  end
end


#post_install do |installer|
#
#  installer.pods_project.targets.each do |target|
#    #适配xcode14.3 产生 Command PhaseScriptExecution failed with a nonzero exit code
#    shell_script_path = "Pods/Target Support Files/#{target.name}/#{target.name}-frameworks.sh"
#    if File::exists?(shell_script_path)
#      shell_script_input_lines = File.readlines(shell_script_path)
#      shell_script_output_lines = shell_script_input_lines.map { |line| line.sub("source=\"$(readlink \"${source}\")\"", "source=\"$(readlink -f \"${source}\")\"") }
#      File.open(shell_script_path, 'w') do |f|
#        shell_script_output_lines.each do |line|
#          f.write line
#        end
#      end
#    end
#    
#    
#    target.build_configurations.each do |config|
#      config.build_settings['CLANG_WARN_OBJC_IMPLICIT_RETAIN_SELF'] = 'NO'
#      config.build_settings['EXPANDED_CODE_SIGN_IDENTITY'] = ""
#      config.build_settings['CODE_SIGNING_REQUIRED'] = "NO"
#      config.build_settings['CODE_SIGNING_ALLOWED'] = "NO"
#      config.build_settings['ENABLE_STRICT_OBJC_MSGSEND'] = "NO"
#      config.build_settings["EXCLUDED_ARCHS[sdk=iphonesimulator*]"] = "arm64"
#      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '11.0'
#    end
#  end
#end



def find_and_replace(dir, findstr, replacestr)

  Dir[dir].each do |name|

      text = File.read(name)

      replace = text.gsub(findstr,replacestr)

      if text != replace

          puts "Fix: " + name

          File.open(name, "w") { |file| file.puts replace }

          STDOUT.flush

      end

  end

  Dir[dir + '*/'].each(&method(:find_and_replace))

end
