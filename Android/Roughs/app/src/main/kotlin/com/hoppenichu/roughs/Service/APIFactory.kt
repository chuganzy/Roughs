package com.hoppenichu.roughs.Service

import android.util.Base64
import com.hoppenichu.roughs.BuildConfig
import retrofit.RestAdapter

/**
 * Created by Takeru on 11/1/15.
 */
class APIFactory private constructor() {

    private val _adapter: RestAdapter

    init {
        val builder = RestAdapter.Builder()
        val name = BuildConfig.ROUGHS_BASIC_AUTH_USERNAME
        val pass = BuildConfig.ROUGHS_BASIC_AUTH_PASSWORD
        if (0 < name.length() && 0 < pass.length()) {
            val credentials = ("$name:$pass" as java.lang.String).getBytes()
            val basic = "Basic " + Base64.encodeToString(credentials, Base64.NO_WRAP)
            builder.setRequestInterceptor { request ->
                request.addHeader("Authorization", basic)
            }
        }
        val host = BuildConfig.ROUGHS_BASE_URL
        builder.setEndpoint("$host/api/1")
        _adapter = builder.build()
        BuildConfig.APPLICATION_ID
    }

    fun <T> createAPI(service: Class<T>) : T {
        return _adapter.create(service)
    }

    companion object {
        val instance = APIFactory()
    }
}
