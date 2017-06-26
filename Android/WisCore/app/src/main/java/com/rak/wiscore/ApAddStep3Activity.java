package com.rak.wiscore;

import android.content.Intent;
import android.content.SharedPreferences;
import android.graphics.Paint;
import android.os.Bundle;
import android.support.v7.app.AppCompatActivity;
import android.text.method.HideReturnsTransformationMethod;
import android.text.method.PasswordTransformationMethod;
import android.view.View;
import android.widget.Button;
import android.widget.ImageView;
import android.widget.ListView;
import android.widget.TextView;
import android.widget.Toast;

import com.rak.wiscore.component.MainMenuButton;
import com.rak.wiscore.component.MyEditText;
import com.rak.wiscore.component.NetworkStateReceiver;
import com.rak.wiscore.component.NetworkUtil;

public class ApAddStep3Activity extends AppCompatActivity {
	public static ApAddStep3Activity _apAddStep3Activity;
	private Button _apAddStep3Continue;
	private MainMenuButton _apAddStep3Back;
	private ImageView _apAddSsidImg;
	private ImageView _apAddPskImg;
	private MyEditText _apAddSsidText;
	private MyEditText _apAddPskText;
	private ListView _apAddDeviceListView;
	private int _networkState = 0;
	private String _ssid="";
	private String _password="";
	private TextView _apAddStep3Switch;

	@Override
	public void onCreate(Bundle savedInstanceState)
	{
		super.onCreate(savedInstanceState);
		setContentView(R.layout.activity_ap_add_step3);
		_apAddStep3Activity=this;
		_apAddStep3Back=(MainMenuButton) findViewById(R.id.ap_add_step3_back_btn);
		_apAddStep3Back.setOnClickListener(new View.OnClickListener() {
			@Override
			public void onClick(View v) {
				finish();
			}
		});

		_apAddStep3Continue=(Button)findViewById(R.id.ap_add_step3_continue_btn);
		_apAddStep3Continue.setOnClickListener(_apAddStep3ContinueClick);
		_apAddStep3Switch=(TextView) findViewById(R.id.ap_add_step3_switch);
		_apAddStep3Switch.setOnClickListener(_apAddStep3SwitchClick);
		_apAddStep3Switch.getPaint().setFlags(Paint.UNDERLINE_TEXT_FLAG);
		_apAddStep3Switch.getPaint().setAntiAlias(true);
		_apAddSsidImg=(ImageView)findViewById(R.id.ap_add_step3_ssid_img);
		_apAddSsidImg.setOnClickListener(_apAddSsidImgClick);
		_apAddPskImg=(ImageView)findViewById(R.id.ap_add_step3_psk_img);
		_apAddPskImg.setOnClickListener(_apAddPskImgClick);
		_apAddSsidText=(MyEditText)findViewById(R.id.ap_add_step3_ssid_edit);
		_apAddPskText=(MyEditText)findViewById(R.id.ap_add_step3_psk_edit);

		_apAddSsidText.setText(NetworkUtil.getSsid(this));
		_apAddPskText.requestFocus();
		NetworkStateReceiver networkStateReceiver = new NetworkStateReceiver();
		networkStateReceiver.setOnNetworkChangedListener(new NetworkStateReceiver.OnNetworkChangedListener() {
			@Override
			public void onChanged(int state) {
				_networkState = state;
				switch (state) {
					case 1:
						_ssid = NetworkUtil.getSsid(ApAddStep3Activity.this);
						_apAddSsidText.setText(_ssid);
						break;
					case -1:
						//Toast.show(getApplicationContext(), getString(R.string.add_device_step1_ssid_error));
						break;
				}
			}
		});
	}

	@Override
	protected void onResume(){
		//获取保存的密码
		SharedPreferences p = getSharedPreferences(_apAddSsidText.getText().toString(), MODE_PRIVATE);
		String psk=p.getString("psk", "");
		_apAddPskText.setText(psk);
		super.onResume();
	}
	/**
	 * AP Config
	 */
	View.OnClickListener _apAddStep3ContinueClick=new View.OnClickListener() {
		@Override
		public void onClick(View v) {
			if (_apAddSsidText.getText().toString().equals("")){
				Toast.makeText(_apAddStep3Activity,getString(R.string.main_config_ssid_error),Toast.LENGTH_SHORT).show();
				return;
			}

			SharedPreferences.Editor editor = getSharedPreferences(_apAddSsidText.getText().toString(), MODE_PRIVATE).edit();
			editor.putString("psk", _apAddPskText.getText().toString());
			editor.commit();

			Intent intent=new Intent();
			intent.putExtra("ssid",_apAddSsidText.getText().toString());
			intent.putExtra("psk",_apAddPskText.getText().toString());
			intent.setClass(ApAddStep3Activity.this,ApAddStep2Activity.class);
			startActivity(intent);
		}
	};

	/**
	 * _apAddStep3SwitchClick
	 */
	View.OnClickListener _apAddStep3SwitchClick=new View.OnClickListener() {
		@Override
		public void onClick(View v) {
			startActivity(new Intent(android.provider.Settings.ACTION_WIFI_SETTINGS));
		}
	};

	/**
	 * Get Ssid List
	 */
	View.OnClickListener _apAddSsidImgClick=new View.OnClickListener() {
		@Override
		public void onClick(View v) {

		}
	};

	/**
	 * Show or Hide PSK
	 */
	boolean psk_open=false;
	View.OnClickListener _apAddPskImgClick=new View.OnClickListener() {
		@Override
		public void onClick(View v) {
			psk_open=!psk_open;
			if(psk_open)
			{
				_apAddPskText.setTransformationMethod(HideReturnsTransformationMethod.getInstance());
				_apAddPskImg.setImageResource(R.drawable.psk_on);
			}
			else
			{
				_apAddPskText.setTransformationMethod(PasswordTransformationMethod.getInstance());
				_apAddPskImg.setImageResource(R.drawable.psk_off);
			}
		}
	};
}
