package com.hoppenichu.roughs.Service.Model

import java.io.Serializable

/**
 * Created by Takeru on 11/1/15.
 */
data class Project(
    val title: String,
    val icon_url: String,
    val project_url: String,
    val creators: Array<String>,
    val user_agent: String
) : Serializable

