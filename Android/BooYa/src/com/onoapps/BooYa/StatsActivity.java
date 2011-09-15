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
import org.json.JSONStringer;
import com.facebook.android.DialogError;
import com.facebook.android.Facebook;
import com.facebook.android.FacebookError;
import com.facebook.android.Facebook.DialogListener;
import android.R.string;
import android.app.Activity;
import android.content.SharedPreferences;
import android.graphics.Typeface;
import android.os.Bundle;
import android.preference.PreferenceManager;
import android.view.View;
import android.widget.Button;
import android.widget.TextView;
import android.widget.Toast;

public class StatsActivity extends Activity {
	
	private Button postToFacebookBtn;
	
	//facebook holder
	private Facebook facebook = new Facebook("190714141001784");
	
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
			
			Typeface tf = Typeface.createFromAsset(getAssets(),
	                "fonts/SF Slapstick Comic Bold.ttf");
			
			//set the values in the text fields
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
		
		
		
		// Post to Facebook
		postToFacebookBtn = (Button)findViewById(R.id.postToFacebookBtn);
		
		postToFacebookBtn.setOnClickListener(new View.OnClickListener() {
			
			@Override
			public void onClick(View v) {
				// TODO Auto-generated method stub
				
			}
		});
		
		
//		JSONStringer actions;
//	
//		Bundle b = new Bundle();
//		
//        b.putString("picture", selectedItemList.get("Thumbnail"));
//        b.putString("name", selectedItemList.get("Title") );
//        b.putString("caption", selectedItemList.get("UserGenericInfo"));
//        b.putString("description",staticTxt.getText().toString());              
//        b.putString("link","http://google.com");
//		
//	     try {
//			actions = new JSONStringer().object()
//			.key("name").value(firstLoveTxt.getText().toString())
//			.key("link").value("http://firstlove.cellcom.co.il/?v="+myRoomId+"#/video/"+myRoomId).endObject();
//			 b.putString("actions", actions.toString());
//		} catch (JSONException e1) {
//			// TODO Auto-generated catch block
//			e1.printStackTrace();
//		}
//
//		facebook.dialog(this,"feed",b,new DialogListener() {
//			@Override
//			public void onComplete(Bundle values) {	}
//
//			@Override
//			public void onFacebookError(FacebookError error) {}
//
//			@Override
//			public void onError(DialogError e) {}
//
//			@Override
//			public void onCancel() {}
//		}
//		);	
	}
	
	
	

	
	

}
