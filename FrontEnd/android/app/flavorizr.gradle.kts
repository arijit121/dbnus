import com.android.build.gradle.AppExtension

val android = project.extensions.getByType(AppExtension::class.java)

android.apply {
    flavorDimensions("flavor-type")

    productFlavors {
        create("prod") {
            dimension = "flavor-type"
            applicationId = "com.dbnus.app"
            resValue(type = "string", name = "app_name", value = "Dbnus")
        }
        create("stg") {
            dimension = "flavor-type"
            applicationId = "com.dbnus.app.stg"
            resValue(type = "string", name = "app_name", value = "Stg Dbnus")
        }
        create("dev") {
            dimension = "flavor-type"
            applicationId = "com.dbnus.app.dev"
            resValue(type = "string", name = "app_name", value = "Dev Dbnus")
        }
    }
}