package com.example.jagat_teknologi_indonesia_test;

import android.app.Notification;
import android.app.Service;
import android.content.Intent;
import android.os.Handler;
import android.os.IBinder;
import android.util.Log;

import androidx.annotation.Nullable;
import androidx.core.app.NotificationCompat;

public class HelpdeskSchedulerListenerService extends Service {
    Handler handler = new Handler();
    public int i=0;
    Runnable runnableCode;
    private Intent helpdeskPostIntent;
    private int delayTime=30000;

    @Override
    public void onCreate() {
        super.onCreate();
        helpdeskPostIntent= new Intent(HelpdeskSchedulerListenerService.this,HelpdeskPostService.class);
        mainTask();
    }

    private void mainTask(){
        NotificationCompat.Builder status_service = new NotificationCompat.Builder(this,MainActivity.CHANNEL_ID)
                .setContentTitle("IT Support : Listening for tickets..")
                .setSmallIcon(R.drawable.launch_background)
                .setPriority(Notification.PRIORITY_MIN);
        runnableCode = new Runnable() {
            @Override
            public void run() {
                try{
                    i++;
                    Log.d(MainActivity.tag,"Update"+i);
                    Log.d(MainActivity.tag,"Calling Post"+i);
                    startService(helpdeskPostIntent);
                }finally {
                    Log.d(MainActivity.tag,"Delay Time is "+delayTime);
                    handler.postDelayed(this, delayTime);
                }
            }
        };
        handler.post(runnableCode);
        startForeground(103,status_service.build());
    }

    void stopRepeatingTask() {
        handler.removeCallbacks(runnableCode);
    }

    @Override
    public int onStartCommand(Intent intent, int flags, int startId) {
        return super.onStartCommand(intent, flags, startId);
    }

    @Override
    public void onDestroy() {
        Log.d(MainActivity.tag,"Sceduller Destroyed");
        stopRepeatingTask();
        super.onDestroy();
    }

    @Nullable
    @Override
    public IBinder onBind(Intent intent) {
        return null;
    }
}