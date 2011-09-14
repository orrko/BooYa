package com.onoapps.BooYa;

import com.onoapps.BooYa.R;

import android.app.Activity;
import android.os.Bundle;
import android.util.Log;
import android.view.View;
import android.widget.EditText;
import android.widget.TextView;
import android.widget.Toast;


public class C2DMRegisterActivity extends Activity {
		
	private TextView txt;
	
	/** Called when the activity is first created. */
	@Override
	public void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.pushregistery);
		
		txt = (TextView)findViewById(R.id.messgaeTxt);
	}

	public void register(View view) {
		Log.e("Super", "Starting registration");
		Toast.makeText(this, "Starting", Toast.LENGTH_LONG).show();
		EditText text = (EditText) findViewById(R.id.editText1);

		C2DMessaging.register(this, text.getText().toString());
	}
	
	public void getMessage(View view){
		
		txt.setText("");
		txt.append(C2DMReceiver.getMsg());
	}
	
	
}