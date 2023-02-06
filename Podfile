# Uncomment the next line to define a global platform for your project
platform :ios, '13.0'

workspace 'StoixithanApp.xcworkspace'

def unit_test_pods
  # RxTest and RxBlocking make the most sense in the context of unit/integration tests
  pod 'RxBlocking', '6.5.0'
  pod 'RxTest', '6.5.0'
  
  # Alamofier mocking library By WeTransfer
  pod 'Mocker', '~> 2.5.4'
end

# ====================================
#
# DOMAIN PODS
#
# ====================================
def domain_pods
  
end

target 'Domain' do
  project './Domain/Domain.project'
  use_frameworks!
  domain_pods
end


# ====================================
#
# DATA PODS
#
# ====================================
def data_pods
  # Alamofire
  pod 'Alamofire', '~> 5.4'
  pod 'AlamofireImage', '~> 4.1'
  pod 'AlamofireNetworkActivityLogger', '~> 3.4'

  # Realm Swift
  pod 'RealmSwift', '10.25.0'
end

target 'Data' do
  project './Data/Data.project'
  use_frameworks!
  data_pods
  
  target 'DataTests' do
    inherit! :search_paths
    # Pods for testing
    data_pods
    unit_test_pods
  end
end

# ====================================
#
# PRESENTATION PODS
#
# ====================================
def presentation_pods
  # Rx pods
  pod 'RxSwift', '6.5.0'
  pod 'RxCocoa', '6.5.0'
  pod 'RxDataSources', '~> 5.0'
  
  # TextStyling
  pod 'BonMot'
  
  # Lottie
  pod 'lottie-ios', '3.3.0'
end

target 'Presentation' do
  project './Presentation/Presentation.project'
  use_frameworks!
  presentation_pods
end

# ====================================
#
# SPORTS PODS
#
# ====================================

target 'Sports' do
  project './Sports/Sports.project'
  use_frameworks!
  presentation_pods
  
  target 'SportsTests' do
    inherit! :search_paths
    # Pods for testing
    presentation_pods
    unit_test_pods
  end
end

# ====================================
#
# APPLICATION TARGET
#
# ====================================
target 'StoixithanApp' do
  project './StoixithanApp.xcodeproj'

  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!
  # Pods for StoixithanApp

  # Framework Pods
  domain_pods
  data_pods
  presentation_pods
  
  target 'StoixithanAppTests' do
    inherit! :search_paths
    # Pods for testing
    unit_test_pods
  end

  target 'StoixithanAppUITests' do
    # Pods for testing
  end

end
