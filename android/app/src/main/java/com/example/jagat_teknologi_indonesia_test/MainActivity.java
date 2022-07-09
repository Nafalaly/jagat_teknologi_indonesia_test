package com.example.jagat_teknologi_indonesia_test;

import io.flutter.embedding.android.FlutterActivity;

import android.app.NotificationChannel;
import android.app.NotificationManager;
import android.app.job.JobInfo;
import android.app.job.JobScheduler;
import android.content.ComponentName;
import android.content.Intent;
import android.content.SharedPreferences;
import android.os.Build;
import android.os.Bundle;
import android.util.Log;

import io.flutter.embedding.engine.FlutterEngine;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.annotation.RequiresApi;


import java.util.Map;
import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.MethodChannel;

public class MainActivity extends FlutterActivity {
    public static final String tag="UntukTag";
    public Intent servicetask;
    public Intent postTaskIntent;
    public Intent dummyNotificationIntent;
    public Intent repetitivePost;
    public Intent helpdeskListenIntent;
    public Intent helpdeskNotificationToogleListener;
    public static String CHANNEL_ID="channel_id_1";
    public static String CHANNEL_ID_DUMMY="channel_id_dummy";
    private NotificationChannel notificationChannel;
    private NotificationChannel helpdeskChannelNotification;

    @RequiresApi(api = Build.VERSION_CODES.O)
    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
        super.configureFlutterEngine(flutterEngine);
        Log.d(MainActivity.tag,"OnConfigureFlutterEnggine");
        if(Build.VERSION.SDK_INT >= Build.VERSION_CODES.O){
            createnotifchannel();
            createservice();
//            channelListener(flutterEngine);
            // startHelpdeskListen();

        }

    }

    @RequiresApi(api = Build.VERSION_CODES.O)
    @Override
    protected void onDestroy() {
        Log.d(MainActivity.tag,"Main Activity Destroyed");
        startHelpdeskListen();
        super.onDestroy();
    }

    @RequiresApi(api = Build.VERSION_CODES.O)
    @Override
    protected void onPause() {
        // startHelpdeskListen();
        super.onPause();
    }

    @RequiresApi(api = Build.VERSION_CODES.O)
    private void createnotifchannel(){
        helpdeskChannelNotification = new NotificationChannel(CHANNEL_ID,"Background hit",NotificationManager.IMPORTANCE_HIGH);
        helpdeskChannelNotification.setDescription("This is only dummy notification");
        NotificationManager notifmanager = getSystemService(NotificationManager.class);
        notifmanager.createNotificationChannel(helpdeskChannelNotification);

    }

    private void createservice(){
        helpdeskListenIntent =new Intent(MainActivity.this,HelpdeskSchedulerListenerService.class);
    }


    @RequiresApi(api = Build.VERSION_CODES.O)
    private void startHelpdeskListen(){
        Log.d(MainActivity.tag,"listen start service");
            startForegroundService(helpdeskListenIntent);
    }

}
