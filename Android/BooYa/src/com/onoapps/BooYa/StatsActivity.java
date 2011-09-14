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
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

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
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import android.R.string;
import android.app.Activity;
import android.content.SharedPreferences;
import android.graphics.Typeface;
import android.os.Bundle;
import android.preference.PreferenceManager;
import android.widget.TextView;
import android.widget.Toast;

public class StatsActivity extends Activity {
	
	

	@Override
	protected void onCreate(Bundle savedInstanceState) {
		// TODO Auto-generated method stub
		super.onCreate(savedInstanceState);
        setContentView(R.layout.stats_layout2);
		
		// Post to WebServer
		HttpClient client = new DefaultHttpClient();
		HttpPost post = new HttpPost(
				"http://booya.r4r.co.il/ajax.php");

			
		try {

			List<NameValuePair> nameValuePairs = new ArrayList<NameValuePair>(2);
			nameValuePairs.add(new BasicNameValuePair("funcName","getUserStat"));
			//TODO - get the real user name form the shared prefs
			// Get the app's shared preferences
	        SharedPreferences app_preferences = 
	        	PreferenceManager.getDefaultSharedPreferences(this);
	        
	        // Get the value for the username
	        String userName = app_preferences.getString("kUserName", "");
			nameValuePairs.add(new BasicNameValuePair("userName",userName));
			
			
			post.setEntity(new UrlEncodedFormEntity(nameValuePairs));
			
			HttpResponse response = client.execute(post);
			BufferedReader rd = new BufferedReader(new InputStreamReader(
					response.getEntity().getContent(),"UTF-8"));
						
			StringBuilder builder = new StringBuilder();
			for (String line = null; (line = rd.readLine()) != null;) {
			    builder.append(line).append("\n");
			}
														       
			JSONObject jObject = new JSONObject(builder.toString());
			//JSONArray jArray = jObject.getJSONArray("data");
			
			Typeface tf = Typeface.createFromAsset(getAssets(),
	                "fonts/SF Slapstick Comic Bold.ttf");
			
			//set the values in the textfields
			TextView scoreTxt =   (TextView)findViewById(R.id.stats_scoreTxtView_id);
			scoreTxt.setText(jObject.get("score").toString());
			scoreTxt.setTypeface(tf);
			
			TextView rankTxt =   (TextView)findViewById(R.id.stats_ranking_id);
			rankTxt.setText(jObject.get("rank").toString());
			rankTxt.setTypeface(tf);
			
			String sendWin = jObject.get("sendWin").toString();
			String sendTotal = jObject.get("sendTotal").toString();
			
			
			TextView sendTxtView =   (TextView)findViewById(R.id.stats_sent_id);
			sendTxtView.setText(sendWin + "/" + sendTotal);
			sendTxtView.setTypeface(tf);
			
			String receiveWin = jObject.get("receiveWin").toString();
			String receiveTotal = jObject.get("receiveTotal").toString();
			
			TextView recTxtView =   (TextView)findViewById(R.id.stats_recieved_id);
			recTxtView.setText(receiveWin + "/" + receiveTotal);
			recTxtView.setTypeface(tf);
			
			
			
			
									
		} catch (IOException e) {
			e.printStackTrace();
		} catch (JSONException e1){
			e1.printStackTrace();
		}
		
	}
	
	

	
	

}
