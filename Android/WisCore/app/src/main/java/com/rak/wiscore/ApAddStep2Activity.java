package com.rak.wiscore;

import android.content.Intent;
import android.content.SharedPreferences;
import android.os.Bundle;
import android.support.v7.app.AppCompatActivity;
import android.text.Html;
import android.util.Log;
import android.view.View;
import android.widget.Button;
import android.widget.TextView;
import android.widget.Toast;

import com.rak.wiscore.component.MainMenuButton;
import com.rak.wiscore.component.NetworkStateReceiver;
import com.rak.wiscore.component.NetworkUtil;

public class ApAddStep2Activity extends AppCompatActivity {
	public static ApAddStep2Activity _apAddStep2Activity;
	private Button _apAddStep2Continue;
	private Button _apAddStep2Settings;
	private MainMenuButton _apAddStep2Back;
	private TextView _apAddStep2Note;
	private int _networkState = 0;
	private String _ssid="";

	@Override
	public void onCreate(Bundle savedInstanceState)
	{
		super.onCreate(savedInstanceState);
		setContentView(R.layout.activity_ap_add_step2);
		_apAddStep2Activity=this;
		_apAddStep2Back=(MainMenuButton) findViewById(R.id.ap_add_step2_back_btn);
		_apAddStep2Back.setOnClickListener(new View.OnClickListener() {
			@Override
			public void onClick(View v) {
				finish();
			}
		});
		_apAddStep2Note=(TextView)findViewById(R.id.ap_add_step2_note);
		String source="Go to your Wi-Fi setting on this iphone(ipad) and select the network of the format \"<font color='#3BC9D8'>WisCore_xxxxxx</font>\". It may take up a minute to display.Wait until WisCore says you are connected, then return here.";
		_apAddStep2Note.setText(Html.fromHtml(source));
		_apAddStep2Continue=(Button)findViewById(R.id.ap_add_step2_continue_btn);
		_apAddStep2Continue.setOnClickListener(new View.OnClickListener() {
			@Override
			public void onClick(View v) {
				startActivity(new Intent(android.provider.Settings.ACTION_WIFI_SETTINGS));
			}
		});

		_apAddStep2Settings=(Button)findViewById(R.id.ap_add_step2_settings_btn);
		_apAddStep2Settings.setOnClickListener(new View.OnClickListener() {
			@Override
			public void onClick(View v) {
				startActivity(new Intent(android.provider.Settings.ACTION_WIFI_SETTINGS));
			}
		});

		NetworkStateReceiver networkStateReceiver = new NetworkStateReceiver();
		networkStateReceiver.setOnNetworkChangedListener(new NetworkStateReceiver.OnNetworkChangedListener() {
			@Override
			public void onChanged(int state) {
				_networkState = state;
				switch (state) {
					case 1:
						_ssid = NetworkUtil.getSsid(ApAddStep2Activity.this);
						Log.e("_ssid1==>",_ssid);
						if (_ssid.startsWith("WisCore")){
							Intent intent=new Intent();
							intent.putExtra("ssid",getIntent().getStringExtra("ssid"));
							intent.putExtra("psk",getIntent().getStringExtra("psk"));
							intent.setClass(ApAddStep2Activity.this,ApAddWaitActivity.class);
							startActivity(intent);
						}
						else{
							Toast.makeText(_apAddStep2Activity,getString(R.string.main_add_step2_connected_failed),Toast.LENGTH_SHORT).show();
						}
						break;
					case -1:
						Toast.makeText(_apAddStep2Activity,getString(R.string.main_add_step2_connected_failed),Toast.LENGTH_SHORT).show();
						break;
				}
			}
		});
	}

	@Override
	protected void onResume(){
		_ssid = NetworkUtil.getSsid(ApAddStep2Activity.this);
		Log.e("_ssid2==>",_ssid);
		if (_ssid.startsWith("WisCore")){
			Intent intent=new Intent();
			intent.putExtra("ssid",getIntent().getStringExtra("ssid"));
			intent.putExtra("psk",getIntent().getStringExtra("psk"));
			intent.setClass(ApAddStep2Activity.this,ApAddWaitActivity.class);
			startActivity(intent);
		}
		else{
			Toast.makeText(_apAddStep2Activity,getString(R.string.main_add_step2_connected_failed),Toast.LENGTH_SHORT).show();
		}
		super.onResume();
	}
}
