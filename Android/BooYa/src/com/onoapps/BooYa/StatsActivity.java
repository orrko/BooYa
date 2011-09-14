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

import android.app.Activity;
import android.os.Bundle;
import android.widget.Toast;

public class StatsActivity extends Activity {

	@Override
	protected void onCreate(Bundle savedInstanceState) {
		// TODO Auto-generated method stub
		super.onCreate(savedInstanceState);
        setContentView(R.layout.stats_layout);
		
		// Post to WebServer
		HttpClient client = new DefaultHttpClient();
		HttpPost post = new HttpPost(
				"http://booya.r4r.co.il/ajax.php");

			
		try {

			List<NameValuePair> nameValuePairs = new ArrayList<NameValuePair>(2);
			nameValuePairs.add(new BasicNameValuePair("funcName","getUserStat"));
			//TODO - get the real user name form the shared prefs
			nameValuePairs.add(new BasicNameValuePair("userName","orr"));
			
			
			post.setEntity(new UrlEncodedFormEntity(nameValuePairs));
			
			HttpResponse response = client.execute(post);
			BufferedReader rd = new BufferedReader(new InputStreamReader(
					response.getEntity().getContent(),"UTF-8"));
						
			StringBuilder builder = new StringBuilder();
			for (String line = null; (line = rd.readLine()) != null;) {
			    builder.append(line).append("\n");
			}
														       
			JSONObject jObject = new JSONObject(builder.toString());
			JSONArray jArray = jObject.getJSONArray("data");
			
			
									
		} catch (IOException e) {
			e.printStackTrace();
		} catch (JSONException e1){
			e1.printStackTrace();
		}
		
	}
	
	

}
