package com.rak.wiscore;

import android.content.Intent;
import android.graphics.Color;
import android.net.Uri;
import android.os.Bundle;
import android.support.v7.app.AppCompatActivity;
import android.text.Html;
import android.text.SpannableString;
import android.text.Spanned;
import android.text.TextPaint;
import android.text.method.LinkMovementMethod;
import android.text.style.ClickableSpan;
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
				if (DeviceSignInActivity._deviceSignInActivity!=null) {
					DeviceSignInActivity._deviceSignInActivity.finish();
					DeviceSignInActivity._deviceSignInActivity=null;
				}
				finish();
			}
		});
		_deviceSignOutBtn=(TextView) findViewById(R.id.alexa_sign_out_btn);
		_deviceSignOutBtn.setOnClickListener(_deviceSignOutBtnClick);
		_deviceSignOutNote=(TextView) findViewById(R.id.alexa_sign_out_note);
		//String source="To learn more and access additional features, download the <font color='#3BC9D8'>Alexa APP</font>.";
		String source="To learn more and access additional features, download the ";
		_deviceSignOutNote.setText(source);
		String str="Alexa APP";
		SpannableString spString = new SpannableString(str);
		spString.setSpan(new ClickableSpan(){
			@Override
			public void updateDrawState(TextPaint ds){
				super.updateDrawState(ds);
				ds.setTextSize(42);//设置字体大小
				ds.setFakeBoldText(true);//设置粗体
				ds.setColor(Color.argb(255,59,201,216));//设置字体颜色
				ds.setUnderlineText(false);//设置取消下划线
			}
			@Override
			public void onClick(View widget){
				//添加点击事件
				Intent intent=new Intent();//创建Intent对象
				intent.setAction(Intent.ACTION_VIEW);//为Intent设置动作
				intent.setData(Uri.parse("https://play.google.com/store/apps/details?id=com.amazon.dee.app"));//为Intent设置数据
				startActivity(intent);//将Intent传递给Activity
			}
		}, 0, str.length(), Spanned.SPAN_EXCLUSIVE_EXCLUSIVE);
		_deviceSignOutNote.append(spString);
		_deviceSignOutNote.setMovementMethod(LinkMovementMethod.getInstance());
		_deviceSignOutNote.append(".");


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

	@Override
	protected void onDestroy() {
		super.onDestroy();
	}

	@Override
	public void onBackPressed() {
		if (DeviceSignInActivity._deviceSignInActivity!=null) {
			DeviceSignInActivity._deviceSignInActivity.finish();
			DeviceSignInActivity._deviceSignInActivity=null;
		}
		finish();
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
