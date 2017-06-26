package com.rak.wiscore;

import android.content.Intent;
import android.graphics.Color;
import android.os.Bundle;
import android.support.v7.app.AppCompatActivity;
import android.util.Log;
import android.view.View;
import android.widget.Button;
import android.widget.ImageView;
import android.widget.ProgressBar;
import android.widget.TextView;
import android.widget.Toast;

import com.rak.wiscore.component.MainMenuButton;
import com.rak.wiscore.component.NetworkUtil;

public class ApAddEndActivity extends AppCompatActivity {
	public static ApAddEndActivity _apAddEndActivity;
	private MainMenuButton _apAddEndBack;
	private ImageView _apAddEndImg;
	private Button _apAddEndBtn;
	private Button _apAddEndSettingsBtn;
	private boolean _isSuccess=true;
	private String _deviceId;
	private String _deviceSsid="";
	private TextView _apAddEndTxt1;
	private TextView _apAddEndTxt2;
	private boolean _isGoSettings=false;

	@Override
	public void onCreate(Bundle savedInstanceState)
	{
		super.onCreate(savedInstanceState);
		setContentView(R.layout.activity_ap_add_end);
		_apAddEndActivity=this;

		_apAddEndBack=(MainMenuButton) findViewById(R.id.ap_add_end_back_btn);
		_apAddEndBack.setOnClickListener(new View.OnClickListener() {
			@Override
			public void onClick(View v) {
				CloseActivity();
			}
		});
		_apAddEndImg=(ImageView) findViewById(R.id.ap_add_end_img);
		_apAddEndBtn=(Button) findViewById(R.id.ap_add_end_continue_btn);
		_apAddEndBtn.setOnClickListener(_apAddEndBtnClick);
		_apAddEndSettingsBtn=(Button) findViewById(R.id.ap_add_end_settings_btn);
		_apAddEndSettingsBtn.setOnClickListener(_apAddEndSettingsBtnClick);
		_apAddEndSettingsBtn.setVisibility(View.GONE);
		_apAddEndTxt1=(TextView) findViewById(R.id.ap_add_end_txt1);
		_apAddEndTxt2=(TextView) findViewById(R.id.ap_add_end_txt2);

		_isSuccess=getIntent().getBooleanExtra("result",true);
		_deviceId=getIntent().getStringExtra("id");
		_deviceSsid=getIntent().getStringExtra("ssid");

		if (!_isSuccess){
			_apAddEndSettingsBtn.setVisibility(View.VISIBLE);
			_apAddEndTxt1.setText(getString(R.string.main_add_end_failed_label1));
			_apAddEndTxt1.setTextColor(Color.BLACK);
			_apAddEndTxt2.setText(getString(R.string.main_add_end_failed_label2));
			_apAddEndImg.setImageResource(R.drawable.add_faild);
			_apAddEndBtn.setText(getString(R.string.main_add_end_failed_btn));
		}
		else{
			_apAddEndSettingsBtn.setVisibility(View.GONE);
		}
	}

	/**
	 * _apAddEndBtnClick
	 */
	View.OnClickListener _apAddEndBtnClick=new View.OnClickListener() {
		@Override
		public void onClick(View v) {
			CloseActivity();
		}
	};

	/**
	 * _apAddEndSettingsBtnClick
	 */
	View.OnClickListener _apAddEndSettingsBtnClick=new View.OnClickListener() {
		@Override
		public void onClick(View v) {
			_isGoSettings=true;
			startActivity(new Intent(android.provider.Settings.ACTION_WIFI_SETTINGS));
		}
	};


	/**
	 * Close
	 */
	private void CloseActivity(){
		if(ApAddWaitActivity._apAddWaitActivity!=null)
			ApAddWaitActivity._apAddWaitActivity.finish();
		if(ApAddStep3Activity._apAddStep3Activity!=null)
			ApAddStep3Activity._apAddStep3Activity.finish();
		if(ApAddStep2Activity._apAddStep2Activity!=null)
			ApAddStep2Activity._apAddStep2Activity.finish();
		if(ApAddStep1Activity._apAddStep1Activity!=null)
			ApAddStep1Activity._apAddStep1Activity.finish();
		finish();
	}

	@Override
	public void onBackPressed() {
		CloseActivity();
	}

	@Override
	protected void onResume(){
		super.onResume();
		if(_isGoSettings==false)
			return;
		if (_deviceSsid==null)
			return;
		if (_apAddEndActivity==null)
			return;

		_isGoSettings=false;
		String _ssid = NetworkUtil.getSsid(_apAddEndActivity);
		if (_ssid==null)
			return;
		Log.e("_ssid2==>",_ssid);
		if (_ssid.startsWith(_deviceSsid)){
			Intent intent=new Intent();
			intent.putExtra("ssid","");
			intent.putExtra("id",_deviceId);
			intent.setClass(ApAddEndActivity.this,ApAddWaitActivity.class);
			startActivity(intent);
			finish();
		}
		else{
			Toast.makeText(ApAddEndActivity.this,getString(R.string.check_network_dialog_text1)+_deviceSsid,Toast.LENGTH_SHORT).show();
		}
	}
}
