plugins {
    // These two plugins are for JVM/Kotlin plugin development
    `java-gradle-plugin`
    id("org.jetbrains.kotlin.jvm") version "1.5.0"
}

repositories {
    mavenCentral()
}

dependencies {
    implementation(platform("org.jetbrains.kotlin:kotlin-bom"))
    implementation("org.jetbrains.kotlin:kotlin-stdlib-jdk8")
    testImplementation("org.jetbrains.kotlin:kotlin-test")
    testImplementation("org.jetbrains.kotlin:kotlin-test-junit")
}

gradlePlugin {
    plugins.create("iosPlugin") {
        id = "com.rrm.ios"
        implementationClass = "com.rrm.ios.IosPlugin"
    }
}

val functionalTestSourceSet: SourceSet = sourceSets.create("functionalTest")

gradlePlugin.testSourceSets(functionalTestSourceSet)
configurations["functionalTestImplementation"].extendsFrom(configurations["testImplementation"])

val functionalTest by tasks.registering(Test::class) {
    testClassesDirs = functionalTestSourceSet.output.classesDirs
    classpath = functionalTestSourceSet.runtimeClasspath
}

tasks.check {
    dependsOn(functionalTest)
}
