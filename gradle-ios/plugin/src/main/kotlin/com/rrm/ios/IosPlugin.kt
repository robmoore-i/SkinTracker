package com.rrm.ios

import org.gradle.api.Project
import org.gradle.api.Plugin

@Suppress("unused" /* Used as a plugin implementation class */)
class IosPlugin: Plugin<Project> {
    override fun apply(project: Project) {
        project.tasks.register("greeting") { task ->
            task.doLast {
                println("Hello from plugin 'com.rrm.ios.greeting'")
            }
        }
    }
}
