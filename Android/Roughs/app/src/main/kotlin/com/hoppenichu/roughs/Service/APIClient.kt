package com.hoppenichu.roughs.Service

import android.util.Base64
import retrofit.RestAdapter

/**
 * Created by Takeru on 11/1/15.
 */
class APIClient private constructor() {

    private val _adapter: RestAdapter

    init {
        val builder = RestAdapter.Builder()
        val name = ""
        val pass = ""
        val credentials = ("$name:$pass" as java.lang.String).getBytes()
        val basic = "Basic " + Base64.encodeToString(credentials, Base64.NO_WRAP)
        builder.setRequestInterceptor { request ->
            request.addHeader("Authorization", basic)
        }
        builder.setEndpoint("")
        _adapter = builder.build()
    }

    fun <T> createAPI(service: Class<T>) : T {
        return _adapter.create(service)
    }

    companion object {
        val instance = APIClient()
    }
}
