package com.hoppenichu.roughs.Service.API

import com.hoppenichu.roughs.Service.Model.Project
import retrofit.http.GET
import retrofit.Callback

/**
 * Created by Takeru on 11/1/15.
 */

interface ProjectAPI {
    @GET("/projects/all")
    fun getAllProjects(handler: Callback<Array<Project>>)
}
