import com.rrm.ios.IosTest

plugins {
    id("com.rrm.ios")
}

tasks.register<IosTest>("test") {
    group = "xcode"
    scheme = "Tests"
}

tasks.register<IosTest>("uiTest") {
    group = "xcode"
    scheme = "UITests"
}