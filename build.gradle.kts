import java.io.ByteArrayInputStream
import java.io.ByteArrayOutputStream

val xcodeProjectName = "SkinTracker"

data class IPhoneDevice(val name: String, val iOSVersion: String, val deviceId: String)

fun devices(): List<IPhoneDevice> {
    val output = ByteArrayOutputStream()
    exec {
        workingDir(".")
        commandLine("xcrun", "xctrace", "list", "devices")
        standardOutput = output
    }
    val stdout = output.toString()
    val physicalDevices: List<String> = stdout.lines().takeWhile { !it.contains("Simulators") }.drop(1)
    return physicalDevices.filter { it.startsWith("iPhone") }.map {
        val split = it.split(" ")
        IPhoneDevice(split[0], split[1].drop(1).dropLast(1), split[2].drop(1).dropLast(1))
    }
}

fun sdks(): List<String> {
    val output = ByteArrayOutputStream()
    exec {
        workingDir(".")
        commandLine("xcodebuild", "-showsdks")
        standardOutput = output
    }

    val stdout = output.toString()
    return stdout.lines()
        .filter { it.contains("iphoneos") }
        .map { it.substring(it.indexOf("iphoneos")) }
}

val testScheme = "Tests"

val test = tasks.register("test") {
    group = "xcode"

    doFirst {
        val schemeFile = "${xcodeProjectName}.xcodeproj/xcshareddata/xcschemes/${xcodeProjectName}${testScheme}.xcscheme"
        val reportOutputPath = "build/reports/tests.html"
        val sdk: String = sdks()[0]
        logger.quiet("Using sdk '$sdk'")
        val device: IPhoneDevice = devices()[0]
        logger.quiet("Using device '$device'")
        val lsResult = exec {
            isIgnoreExitValue = true
            commandLine = listOf("ls", schemeFile)
        }
        if (lsResult.exitValue != 0) {
            throw RuntimeException(
                "Couldn't find expected scheme file $schemeFile. To create it, follow these instructions:\n" +
                        "    1. Open the project in XCode\n" +
                        "    2. Go to Product > Scheme > Manage Schemes\n" +
                        "    3. Click the '+' in the bottom left\n" +
                        "    4. Select the Tests target, and give it the same name as the target\n" +
                        "    5. Verify that the file $schemeFile has been created\n"
            )
        }
        val xcodebuildOutput = ByteArrayOutputStream()
        val xcodebuildCommand = "xcodebuild " +
                "-project ${xcodeProjectName}.xcodeproj " +
                "-scheme ${xcodeProjectName}${testScheme} " +
                "-sdk ${sdk} " +
                "-destination platform=iOS,id=${device.deviceId} " +
                "test"
        logger.quiet("Running command '$xcodebuildCommand'")
        exec {
            commandLine = xcodebuildCommand.split(" ")
            standardOutput = xcodebuildOutput
            errorOutput = xcodebuildOutput
            isIgnoreExitValue = true
        }
        val xcprettyCommand = "xcpretty -r html -o ${reportOutputPath}"
        logger.quiet("Running command '$xcprettyCommand'")
        exec {
            standardInput = ByteArrayInputStream(xcodebuildOutput.toString().toByteArray())
            commandLine = xcprettyCommand.split(" ")
        }
        logger.quiet("HTML test report written to $reportOutputPath")
    }
}