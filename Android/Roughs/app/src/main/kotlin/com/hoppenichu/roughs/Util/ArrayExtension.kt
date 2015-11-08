package com.hoppenichu.roughs.Util

import java.util.*

/**
 * Created by Takeru on 11/2/15.
 */

fun <T> Array<T>.toArrayList(): ArrayList<T> {
    val list = ArrayList<T>()
    for (item in this) {
        list.add(item)
    }
    return list
}
