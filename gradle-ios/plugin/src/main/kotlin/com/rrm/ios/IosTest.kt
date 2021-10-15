package com.rrm.ios

import org.gradle.api.DefaultTask
import org.gradle.api.tasks.Input
import org.gradle.api.tasks.TaskAction
import java.io.ByteArrayInputStream
import java.io.ByteArrayOutputStream

public abstract class IosTest : DefaultTask() {

    @get:Input
    abstract var scheme: String

    @TaskAction
    fun runTests() {
        val xcodeProjectName = "SkinTracker"
        val schemeFile =
            "${xcodeProjectName}.xcodeproj/xcshareddata/xcschemes/${xcodeProjectName}${scheme}.xcscheme"
        val reportOutputPath = "build/reports/tests.html"
        val sdk: String = sdks()[0]
        this.logger.quiet("Using sdk '$sdk'")
        val device: IPhoneDevice = devices()[0]
        this.logger.quiet("Using device '$device'")
        val lsResult = this.project.exec {
            it.isIgnoreExitValue = true
            it.commandLine = listOf("ls", schemeFile)
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
                "-scheme ${xcodeProjectName}${scheme} " +
                "-sdk ${sdk} " +
                "-destination platform=iOS,id=${device.deviceId} " +
                "test"
        this.logger.quiet("Running command '$xcodebuildCommand'")
        this.project.exec {
            it.commandLine = xcodebuildCommand.split(" ")
            it.standardOutput = xcodebuildOutput
            it.errorOutput = xcodebuildOutput
            it.isIgnoreExitValue = true
        }
        val xcprettyCommand = "xcpretty -r html -o ${reportOutputPath}"
        this.logger.quiet("Running command '$xcprettyCommand'")
        this.project.exec {
            it.standardInput = ByteArrayInputStream(xcodebuildOutput.toString().toByteArray())
            it.commandLine = xcprettyCommand.split(" ")
        }
        this.logger.quiet("HTML test report written to $reportOutputPath")
    }

    private fun devices(): List<IPhoneDevice> {
        val output = ByteArrayOutputStream()
        this.project.exec {
            it.workingDir(".")
            it.commandLine("xcrun", "xctrace", "list", "devices")
            it.standardOutput = output
        }
        val stdout = output.toString()
        val physicalDevices: List<String> = stdout.lines().takeWhile { !it.contains("Simulators") }.drop(1)
        return physicalDevices.filter { it.startsWith("iPhone") }.map {
            val split = it.split(" ")
            IPhoneDevice(split[0], split[1].drop(1).dropLast(1), split[2].drop(1).dropLast(1))
        }
    }

    private fun sdks(): List<String> {
        val output = ByteArrayOutputStream()
        this.project.exec {
            it.workingDir(".")
            it.commandLine("xcodebuild", "-showsdks")
            it.standardOutput = output
        }

        val stdout = output.toString()
        return stdout.lines()
            .filter { it.contains("iphoneos") }
            .map { it.substring(it.indexOf("iphoneos")) }
    }
}