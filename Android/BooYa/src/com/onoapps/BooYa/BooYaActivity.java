package com.onoapps.BooYa;

import android.app.Activity;
import android.os.Bundle;
import android.widget.Button;

public class BooYaActivity extends Activity {
    /** Called when the activity is first created. */
    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.main);
        
        Button myBtn = (Button)findViewById(R.id.button1);
        
        
    }
}