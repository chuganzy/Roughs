package com.hoppenichu.roughs.Activity

import android.content.Context
import android.content.Intent
import android.os.Bundle
import android.support.v4.widget.SwipeRefreshLayout
import android.support.v7.app.AppCompatActivity
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.ArrayAdapter
import android.widget.ImageView
import android.widget.ListView
import android.widget.TextView
import com.hoppenichu.roughs.BuildConfig
import com.hoppenichu.roughs.R
import com.hoppenichu.roughs.Service.APIClient
import com.hoppenichu.roughs.Service.API.ProjectAPI
import com.hoppenichu.roughs.Service.Model.Project
import com.hoppenichu.roughs.Util.toArrayList
import com.squareup.picasso.Picasso
import retrofit.Callback
import retrofit.RetrofitError
import retrofit.client.Response

/**
 * Created by Takeru on 11/1/15.
 */

class ProjectListActivity : AppCompatActivity() {

    private var _refreshLayout: SwipeRefreshLayout? = null
    private var _adapter: ProjectListAdapter? = null

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_project_list)
        _adapter = ProjectListAdapter(this)
        val listView = findViewById(R.id.list_view) as ListView
        listView.setAdapter(_adapter)
        listView.setOnItemClickListener { adapterView, view, i, l ->
            val intent = Intent(this, javaClass<ProjectActivity>())
            val project = _adapter?.getItem(i) as Project
            intent.putExtra(ProjectActivity.INTENT_EXTRA_ROJECT, project)
            startActivity(intent)
        }
        val refreshLayout = findViewById(R.id.swipe_refresh_layout) as SwipeRefreshLayout
        refreshLayout.setOnRefreshListener {
            _refresh()
        }
        _refreshLayout = refreshLayout
        _refresh()
    }

    private fun _refresh() {
        _refreshLayout?.setRefreshing(true)
        val api = APIClient.instance.createAPI(javaClass<ProjectAPI>()) as ProjectAPI
        api.getAllProjects(object: Callback<Array<Project>> {
            override fun success(results: Array<Project>, response: Response) {
                _refreshLayout?.setRefreshing(false)
                _adapter?.setNotifyOnChange(false)
                _adapter?.clear()
                _adapter?.addAll(results.toArrayList())
                _adapter?.notifyDataSetChanged()
            }
            override fun failure(error: RetrofitError) {
                _refreshLayout?.setRefreshing(false)
            }
        })
    }

    class ProjectListAdapter(context: Context?) : ArrayAdapter<Project>(context, R.layout.view_project_list_cell) {
        override fun getView(position: Int, convertView: View?, parent: ViewGroup?): View? {
            val view = convertView ?: LayoutInflater.from(context).inflate(R.layout.view_project_list_cell, null)
            val project = getItem(position)
            Picasso.with(context).load(project.icon_url).into((view.findViewById(R.id.icon_image_view) as ImageView))
            (view.findViewById(R.id.title_text_view) as TextView).text = project.title
            (view.findViewById(R.id.creators_text_view) as TextView).text = project.creators.join(" / ")
            return view;
            BuildConfig.APPLICATION_ID
        }
    }
}

