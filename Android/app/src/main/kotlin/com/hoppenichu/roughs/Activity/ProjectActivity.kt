package com.hoppenichu.roughs.Activity

import android.os.Bundle
import android.support.v7.app.AppCompatActivity
import android.view.KeyEvent
import android.webkit.WebView
import com.hoppenichu.roughs.R
import com.hoppenichu.roughs.Service.Model.Project

/**
 * Created by Takeru on 11/9/15.
 */
class ProjectActivity : AppCompatActivity() {

    private var _webView: WebView? = null

    companion object {
        val INTENT_EXTRA_ROJECT = "PROJECT"
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_project)
        val project = intent.getSerializableExtra(INTENT_EXTRA_ROJECT) as Project
        val webView = findViewById(R.id.web_view) as WebView
        webView.settings.javaScriptEnabled = true
        webView.settings.domStorageEnabled = true
        webView.settings.setAppCacheEnabled(true)
        webView.settings.setAppCachePath(cacheDir.getPath())
        webView.settings.userAgentString = project.user_agent
        webView.loadUrl(project.project_url + "?in_browser=1")
        _webView = webView
    }

    override fun onBackPressed() {
        if (_webView?.canGoBack() == true) {
            _webView?.goBack()
            return
        }
        super.onBackPressed()
    }

    override fun onKeyLongPress(keyCode: Int, event: KeyEvent?): Boolean {
        if (keyCode == KeyEvent.KEYCODE_BACK) {
            supportFinishAfterTransition()
            return true
        }
        return super.onKeyLongPress(keyCode, event)
    }
}
