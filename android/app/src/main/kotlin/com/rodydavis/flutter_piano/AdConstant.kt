package piano.keyboard.pianomusic

import android.content.Context
import android.content.pm.PackageManager
import android.util.Log
import com.google.firebase.database.BuildConfig
import com.google.firebase.database.DatabaseReference
import com.google.firebase.database.ktx.database
import com.google.firebase.ktx.Firebase
import io.flutter.plugin.common.MethodChannel

object AdConstant {

    fun init(context: Context, result: MethodChannel.Result,dbName:String) {

        val database: DatabaseReference = Firebase.database.reference
        val jsonConfigKey = if (BuildConfig.DEBUG) "testAds" else "androidLiveAds"
        database.child(dbName).child("Ads").child(jsonConfigKey).get().addOnSuccessListener {
            println(it)
            Log.i("firebase123", "Got value ${it.child("app_id").value}")
            val applicationInfo = context.packageManager.getApplicationInfo(
                    context.packageName, PackageManager.GET_META_DATA
            )
            val bundle = applicationInfo.metaData
            val id = bundle.getString("com.google.android.gms.ads.APPLICATION_ID")
            println(id)
            try {
                println("Old Id IS" +bundle.getString("com.google.android.gms.ads.APPLICATION_ID"))
                applicationInfo.metaData.putString("com.google.android.gms.ads.APPLICATION_ID", it.child("app_id").value.toString())
                println("New Id IS" +bundle.getString("com.google.android.gms.ads.APPLICATION_ID"))
                result.success("Success")

            }catch (e: Exception) {
                println(e)
                result.error("UNAVAILABLE", "Some thing Went Worng", null)
            }
        }.addOnFailureListener{
            Log.e("firebase", "Error getting data", it)
            result.error("UNAVAILABLE", "Some thing Went Worng", null)

        }
        /*val remoteConfig = FirebaseRemoteConfig.getInstance()
        val configSettings =
                FirebaseRemoteConfigSettings.Builder().setMinimumFetchIntervalInSeconds(0)
                        .build()
        remoteConfig.setConfigSettingsAsync(configSettings)
        val jsonConfigKey = if (BuildConfig.DEBUG) "AdIds" else "AdIds"
        remoteConfig.fetchAndActivate()
                .addOnCompleteListener { task ->
                    if (task.isSuccessful) {

                        val json = remoteConfig.getString(jsonConfigKey)
                        val gson = Gson()
                        val adModel = gson.fromJson(json, MainActivity.AdModel::class.java)
                        val applicationInfo = context.packageManager.getApplicationInfo(
                                context.packageName, PackageManager.GET_META_DATA
                        )
                        val bundle = applicationInfo.metaData
                        val id = bundle.getString("com.google.android.gms.ads.APPLICATION_ID")
                        println(id)
                        try {
                            println("Old Id IS" +bundle.getString("com.google.android.gms.ads.APPLICATION_ID"))
                            applicationInfo.metaData.putString("com.google.android.gms.ads.APPLICATION_ID",adModel.appId)
                            println("New Id IS" +bundle.getString("com.google.android.gms.ads.APPLICATION_ID"))

                        }catch (e: Exception) {
                            println(e)
                            result.error("UNAVAILABLE", "Battery level not available.", null)
                        }
                    }

                }*/

    }

}