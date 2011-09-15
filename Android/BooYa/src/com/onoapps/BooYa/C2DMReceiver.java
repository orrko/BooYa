package com.onoapps.BooYa;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.util.ArrayList;
import java.util.List;

import org.apache.http.HttpResponse;
import org.apache.http.NameValuePair;
import org.apache.http.client.HttpClient;
import org.apache.http.client.entity.UrlEncodedFormEntity;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.impl.client.DefaultHttpClient;
import org.apache.http.message.BasicNameValuePair;

import com.onoapps.BooYa.R;

import android.app.Notification;
import android.app.NotificationManager;
import android.app.PendingIntent;
import android.content.Context;
import android.content.Intent;
import android.content.SharedPreferences;
import android.content.SharedPreferences.Editor;
import android.media.AudioManager;
import android.net.Uri;
import android.os.Bundle;
import android.preference.PreferenceManager;
import android.telephony.TelephonyManager;
import android.util.Log;
import android.widget.Toast;

public class C2DMReceiver extends C2DMBaseReceiver {
	
	 private static final int HELLO_ID = 1;
	 private static  String msg;
	
	public C2DMReceiver() {
		// Email address currently not used by the C2DM Messaging framework
		super("david@onoapps.com");
	}

	@Override
	public void onRegistered(Context context, String registrationId)
			throws java.io.IOException {
	
		// The registrationId should be send to your applicatioin server.
		// We just log it to the LogCat view
		// We will copy it from there
		Log.e("C2DM", "Registration ID arrived: Fantastic!!!");
		Log.e("C2DM", registrationId);
		
		// Save the RegisterId to SharedPreferences and send it to RegisteryActivity
        SharedPreferences app_preferences = //getSharedPreferences("BooYa", MODE_PRIVATE);
        	PreferenceManager.getDefaultSharedPreferences(context);
                
		SharedPreferences.Editor editor = app_preferences.edit();
		editor.putString("C2DMRegId",registrationId);
		
		editor.commit(); // Very important
			
	};

	@Override
	protected void onMessage(Context context, Intent intent) {
		Log.e("C2DM", "Message: Fantastic!!!");
		// Extract the payload from the message
		Bundle extras = intent.getExtras();
		if (extras != null) {
			
			// Checking if the device is in silent or vibrate and change it to normal mode.
			AudioManager am = (AudioManager)getSystemService(Context.AUDIO_SERVICE);

			switch (am.getRingerMode()) {
			    case AudioManager.RINGER_MODE_SILENT:
			        Log.i("MyApp","Silent mode");
			        am.setRingerMode(AudioManager.RINGER_MODE_NORMAL);
			        break;
			    case AudioManager.RINGER_MODE_VIBRATE:
			        Log.i("MyApp","Vibrate mode");
			        am.setRingerMode(AudioManager.RINGER_MODE_NORMAL);
			        break;
			    case AudioManager.RINGER_MODE_NORMAL:
			        Log.i("MyApp","Normal mode");
			        break;
			}
			
			System.out.println(extras.get("payload"));
			// Now do something smart based on the information
			setMsg(extras.get("payload").toString());
			
			// Notification
			String ns = Context.NOTIFICATION_SERVICE;
			NotificationManager mNotificationManager = (NotificationManager) getSystemService(ns);
			
			int icon = R.drawable.icon;
			CharSequence tickerText = "BooYa...";
			long when = System.currentTimeMillis();

			Notification notification = new Notification(icon, tickerText, when);
			
			context = getApplicationContext();
			CharSequence contentTitle = "BooYa for you...";
			CharSequence contentText = extras.get("payload").toString();
			CharSequence contentTextBooYaId = extras.get("booYaId").toString();
			CharSequence contentTextBooYaType = extras.get("booYaType").toString();
			CharSequence contentTextUserName = extras.get("userName").toString();
			CharSequence contentTextSound = extras.get("sound").toString();
			
			Intent notificationIntent = new Intent(this, RootActivity.class);
			PendingIntent contentIntent = PendingIntent.getActivity(this, 0, notificationIntent, 0);

			notification.setLatestEventInfo(context, contentTitle, contentText, contentIntent);
			
			//check which sound is to be played
			
			//TODO - fix the bad programming below
			//check if this is a silent or loud booya
			if (contentTextBooYaType.toString().equalsIgnoreCase("loud")){
				//we are in the loud booya
				switch (Integer.parseInt(contentTextSound.toString().subSequence(11, 12).toString())) {
				case  1:
					notification.sound = Uri.parse("android.resource://com.onoapps.BooYa/"+ R.raw.loud_booya01);
					break;
				case  2:
					notification.sound = Uri.parse("android.resource://com.onoapps.BooYa/"+ R.raw.loud_booya02);
					break;
				case  3:
					notification.sound = Uri.parse("android.resource://com.onoapps.BooYa/"+ R.raw.loud_booya03);
					break;
				case  4:
					notification.sound = Uri.parse("android.resource://com.onoapps.BooYa/"+ R.raw.loud_booya04);
					break;
				case  5:
					notification.sound = Uri.parse("android.resource://com.onoapps.BooYa/"+ R.raw.loud_booya05);
					break;

				default:
					break;
				}
			}else if(contentTextBooYaType.toString().equalsIgnoreCase("silent")){
				//we are in the silent booya
				switch (Integer.parseInt(contentTextSound.toString().subSequence(13, 14).toString())) {
				case  1:
					notification.sound = Uri.parse("android.resource://com.onoapps.BooYa/"+ R.raw.silent_booya01);
					break;
				case  2:
					notification.sound = Uri.parse("android.resource://com.onoapps.BooYa/"+ R.raw.silent_booya02);
					break;
				case  3:
					notification.sound = Uri.parse("android.resource://com.onoapps.BooYa/"+ R.raw.silent_booya03);
					break;
				case  4:
					notification.sound = Uri.parse("android.resource://com.onoapps.BooYa/"+ R.raw.silent_booya04);
					break;
				case  5:
					notification.sound = Uri.parse("android.resource://com.onoapps.BooYa/"+ R.raw.silent_booya05);
					break;

				default:
					break;
				}
			}else if(contentTextBooYaType.toString().equalsIgnoreCase("win")){
				
				// Sound for win
				notification.sound = Uri.parse("android.resource://com.onoapps.BooYa/"+ R.raw.win);
				
			}else if(contentTextBooYaType.toString().equalsIgnoreCase("lose")){
				
				// Sound for lose
				notification.sound = Uri.parse("android.resource://com.onoapps.BooYa/"+ R.raw.lose);
			}
						
			//notification.sound = Uri.parse("android.resource://com.onoapps.BooYa/"+ R.raw.loud_booya01);
			
			//notification.defaults = Notification.DEFAULT_SOUND;
			notification.flags = Notification.FLAG_AUTO_CANCEL;
			mNotificationManager.notify(HELLO_ID, notification);
		
		}
	}

	public static String getMsg(){
		return msg;
	}
	
	public static void setMsg(String txt){
		 msg = txt;
	}
	
	
	@Override
	public void onError(Context context, String errorId) {
		Log.e("C2DM", "Error occured!!!");
	}

}
