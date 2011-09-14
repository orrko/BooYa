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
        SharedPreferences app_preferences = 
        	PreferenceManager.getDefaultSharedPreferences(context);
        
		SharedPreferences.Editor editor = app_preferences.edit();
		editor.putString("C2DMRegId",registrationId);
		
//		TelephonyManager tManager = (TelephonyManager)getSystemService(Context.TELEPHONY_SERVICE);
//		String uid = tManager.getDeviceId();
//	
//		HttpClient client = new DefaultHttpClient();
//		HttpPost post = new HttpPost(
//				"http://r4r.co.il/and/Reg.php");
//
//		try {
//
//			List<NameValuePair> nameValuePairs = new ArrayList<NameValuePair>(1);
//			nameValuePairs.add(new BasicNameValuePair("RegId",registrationId));
//			nameValuePairs.add(new BasicNameValuePair("DeviceId",uid));
//	
//			post.setEntity(new UrlEncodedFormEntity(nameValuePairs));
//			HttpResponse response = client.execute(post);
//			BufferedReader rd = new BufferedReader(new InputStreamReader(
//					response.getEntity().getContent()));
//
//			String line = "";
//			while ((line = rd.readLine()) != null) {
////				Log.e("HttpResponse", line);
////				if (line.startsWith("Auth=")) {
////					Editor edit = prefManager.edit();
////					edit.putString(AUTH, line.substring(5));
////					edit.commit();
////					String s = prefManager.getString(AUTH, "n/a");
////					Toast.makeText(this, s, Toast.LENGTH_LONG).show();
////				}
//
//			}
//		} catch (IOException e) {
//			e.printStackTrace();
//		}
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
			Intent notificationIntent = new Intent(this, RootActivity.class);
			PendingIntent contentIntent = PendingIntent.getActivity(this, 0, notificationIntent, 0);

			notification.setLatestEventInfo(context, contentTitle, contentText, contentIntent);
			notification.defaults = Notification.DEFAULT_SOUND;
			mNotificationManager.notify(HELLO_ID, notification);
			
//			Intent i = new Intent(this, RegisterActivity.class);
//			i.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
//			startActivity(i);
			//Toast.makeText(this,extras.get("payload").toString(), Toast.LENGTH_LONG);				
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
