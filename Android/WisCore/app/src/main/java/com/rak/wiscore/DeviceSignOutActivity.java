package com.rak.wiscore;

import android.content.Intent;
import android.os.Bundle;
import android.support.v7.app.AppCompatActivity;
import android.text.Html;
import android.util.Log;
import android.view.View;
import android.widget.Button;
import android.widget.TextView;
import android.widget.Toast;

import com.amazon.identity.auth.device.api.authorization.AuthorizationManager;
import com.amazon.identity.auth.device.api.authorization.AuthorizeRequest;
import com.amazon.identity.auth.device.api.authorization.ScopeFactory;
import com.rak.wiscore.component.ApConfig;
import com.rak.wiscore.component.Loading;
import com.rak.wiscore.component.MainMenuButton;

import org.json.JSONException;
import org.json.JSONObject;

import java.util.Timer;
import java.util.TimerTask;

public class DeviceSignOutActivity extends AppCompatActivity {
	public static DeviceSignOutActivity _deviceSignOutActivity;
	private MainMenuButton  _deviceSignOutBack;
	private TextView _deviceSignOutBtn;
	private TextView _deviceSignOutNote;
	private String ip;
	private Loading _signOutLoad;
	private ApConfig _signOutAPConfig;

	@Override
	public void onCreate(Bundle savedInstanceState)
	{
		super.onCreate(savedInstanceState);
		setContentView(R.layout.activity_device_alexa_sign_out);

		_deviceSignOutActivity=this;
		_deviceSignOutBack=(MainMenuButton) findViewById(R.id.alexa_sign_out_back_btn);
		_deviceSignOutBack.setOnClickListener(new View.OnClickListener() {
			@Override
			public void onClick(View v) {
				finish();
			}
		});
		_deviceSignOutBtn=(TextView) findViewById(R.id.alexa_sign_out_btn);
		_deviceSignOutBtn.setOnClickListener(_deviceSignOutBtnClick);
		_deviceSignOutNote=(TextView) findViewById(R.id.alexa_sign_out_note);
		String source="To learn more and access additional features, download the <font color='#3BC9D8'>Alexa APP</font>.";
		_deviceSignOutNote.setText(Html.fromHtml(source));

		ip=getIntent().getStringExtra("ip");
		_signOutLoad=(Loading)findViewById(R.id.sign_out_loading);
		_signOutLoad.setText(getResources().getString(R.string.main_logout_sign_out_text));
		_signOutLoad.setVisibility(View.GONE);
		_signOutAPConfig=new ApConfig(ip,"admin");
		_signOutAPConfig.setOnResultListener(new ApConfig.OnResultListener() {
			@Override
			public void onResult(final ApConfig.Response result) {
				runOnUiThread(new Runnable() {
					@Override
					public void run() {
						_signOutLoad.setVisibility(View.GONE);
						if (result.type==ApConfig.Alexa_Sign_Out){
							if (result.statusCode==200){
								finish();
							}
							else{
								Toast.makeText(_deviceSignOutActivity,getString(R.string.main_logout_sign_out_failed),Toast.LENGTH_SHORT).show();
							}
						}
					}
				});
			}
		});
	}

	/**
	 * Sign out
	 */
	View.OnClickListener _deviceSignOutBtnClick=new View.OnClickListener() {
		@Override
		public void onClick(View v) {
			_signOutLoad.setVisibility(View.VISIBLE);
			_signOutAPConfig.alexaSignOut();
		}
	};
}
