package com.example.jagat_teknologi_indonesia_test;

import android.app.Service;
import android.content.Intent;
import android.content.SharedPreferences;
import android.os.IBinder;
import android.util.Log;

import androidx.annotation.Nullable;

import com.android.volley.Request;
import com.android.volley.RequestQueue;
import com.android.volley.Response;
import com.android.volley.VolleyError;
import com.android.volley.toolbox.StringRequest;
import com.android.volley.toolbox.Volley;

import org.json.JSONException;
import org.json.JSONObject;

public class HelpdeskPostService extends Service {

    @Override
    public void onCreate() {
        super.onCreate();
        mainTask();
    }

    private void mainTask(){
        Log.d(MainActivity.tag,"POST : Hit Main Task");
        postRequest();
    }

    private void postRequest(){
        RequestQueue requestQueue = Volley.newRequestQueue(this);
        String URL = "http://test-tech.api.jtisrv.com/md/public/API/BgService/Hit";
        StringRequest stringRequest = new StringRequest(Request.Method.POST, URL, new Response.Listener<String>() {
            @Override
            public void onResponse(String response) {
                Log.d(MainActivity.tag,"Response Received "+response);
                onResponseHandler(response);
            }
        }, new Response.ErrorListener() {
            @Override
            public void onErrorResponse(VolleyError error) {
                Log.d(MainActivity.tag,"My Fault.."+error);
                stopSelf();
            }
        }) {
            @Override
            public String getBodyContentType() {
                return "application/json; charset=utf-8";
            }

            @Override
            public byte[] getBody(){
                JSONObject jsonBody = new JSONObject();
                JSONObject params = new JSONObject();
                try {
                        params.put("nama","Nafal Aly");
                        params.put("email", "nafalaly@gmail.com");
                        params.put("nohp", "089670466744");
                    Log.d(MainActivity.tag,"POST PARAMS :"+params);
                } catch (JSONException e) {
                    e.printStackTrace();
                }
                try {
                    jsonBody.put("params", params);
                } catch (JSONException e) {
                    e.printStackTrace();
                }finally {
                    return jsonBody.toString().getBytes();
                }
            }

        };
        requestQueue.add(stringRequest);
    }

    void onResponseHandler(String serverRespoonse){
        try {
            Log.d(MainActivity.tag,"Parsing Response");
            JSONObject response = new JSONObject(serverRespoonse);
            Log.d(MainActivity.tag,"Parse OK");
        } catch (JSONException e) {
            e.printStackTrace();
        }finally {
            Log.d(MainActivity.tag,"POST : Stopping service");
            stopSelf();
        }
    }


    @Override
    public int onStartCommand(Intent intent, int flags, int startId) {
        return super.onStartCommand(intent, flags, startId);
    }

    @Override
    public void onDestroy() {
        super.onDestroy();
    }

    @Nullable
    @Override
    public IBinder onBind(Intent intent) {
        return null;
    }
}