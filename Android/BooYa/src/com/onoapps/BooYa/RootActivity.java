package com.onoapps.BooYa;

import android.app.Activity;

import android.content.ContentResolver;
import android.database.Cursor;
import android.os.Bundle;
import android.provider.Contacts;
import android.provider.Contacts.People;

public class RootActivity extends Activity {

	/** Called when the activity is first created. */
    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.main);
        
        //If log in?
        
        ContentResolver cr = getContentResolver();
        Cursor cur = cr.query(People.CONTENT_URI, 
			null, null, null, null);
        if (cur.getCount() > 0) {
	     while (cur.moveToNext()) {
	         String id = cur.getString(cur.getColumnIndex(People._ID));
	         String name = cur.getString(cur.getColumnIndex(People.DISPLAY_NAME));
	         
	     	if (Integer.parseInt(cur.getString(
	                cur.getColumnIndex(People.PRIMARY_PHONE_ID))) > 0) {
	    		Cursor pCur = cr.query(
	    				Contacts.Phones.CONTENT_URI, 
	    				null, 
	    				Contacts.Phones.PERSON_ID +" = ?", 
	    				new String[]{id}, null);
	    		int i=0;
	    		int pCount = pCur.getCount();
	    		String[] phoneNum = new String[pCount];
	    		String[] phoneType = new String[pCount];
	    		while (pCur.moveToNext()) {
	    			phoneNum[i] = pCur.getString(
	                                   pCur.getColumnIndex(Contacts.Phones.NUMBER));
	    			phoneType[i] = pCur.getString(
	                                   pCur.getColumnIndex(Contacts.Phones.TYPE));
	    			i++;
	    		} 
	    	}
	     }
        }
        
    }
}