package com.onoapps.BooYa;

import com.onoapps.BooYa.R;

import android.app.Activity;
import android.content.ContentResolver;
import android.content.SharedPreferences;
import android.os.Bundle;

public class RootActivity extends Activity {

	private SharedPreferences pref;
	
	/** Called when the activity is first created. */
    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.main);
        
        // Check if log in 
		// Edit that the room has a "Like"
		SharedPreferences.Editor editor = pref.edit();
		//editor.putBoolean("RoomId"+myRoomId,true);
		editor.commit();
		
		pref = getSharedPreferences("Likes",0);
		
		ContentResolver cr = getContentResolver();
		
        
    }
}