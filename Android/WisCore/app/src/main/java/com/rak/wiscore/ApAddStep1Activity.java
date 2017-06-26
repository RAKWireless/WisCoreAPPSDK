package com.rak.wiscore;

import android.content.Intent;
import android.os.Bundle;
import android.support.v7.app.AppCompatActivity;
import android.view.View;
import android.widget.Button;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.Toast;

import com.rak.wiscore.component.ListAdapter;
import com.rak.wiscore.component.MainMenuButton;

public class ApAddStep1Activity extends AppCompatActivity {
	public static ApAddStep1Activity _apAddStep1Activity;
	private Button _apAddStep1Continue;
	private MainMenuButton _apAddStep1Back;
	private LinearLayout _apAddStep1CheckBtn;
	private ImageView _apAddStep1CheckImg;
	private boolean isCheck=false;

	@Override
	public void onCreate(Bundle savedInstanceState)
	{
		super.onCreate(savedInstanceState);
		setContentView(R.layout.activity_ap_add_step1);

		_apAddStep1Activity=this;
		_apAddStep1Back=(MainMenuButton) findViewById(R.id.ap_add_step1_back_btn);
		_apAddStep1Back.setOnClickListener(new View.OnClickListener() {
			@Override
			public void onClick(View v) {
				finish();
			}
		});
		_apAddStep1Continue=(Button)findViewById(R.id.ap_add_step1_continue_btn);
		_apAddStep1Continue.setEnabled(false);
		_apAddStep1Continue.setBackgroundResource(R.drawable.long_oc_dis);
		_apAddStep1Continue.setOnClickListener(new View.OnClickListener() {
			@Override
			public void onClick(View v) {
				if (!isCheck){
					Toast.makeText(_apAddStep1Activity,getString(R.string.main_add_step1_check_first),Toast.LENGTH_SHORT).show();
					return;
				}
				Intent intent=new Intent();
				intent.setClass(ApAddStep1Activity.this,ApAddStep3Activity.class);
				startActivity(intent);
			}
		});
		_apAddStep1CheckImg=(ImageView)findViewById(R.id.ap_add_step1_check_img);
		_apAddStep1CheckBtn=(LinearLayout)findViewById(R.id.ap_add_step1_check_btn);
		_apAddStep1CheckBtn.setOnClickListener(new View.OnClickListener() {
			@Override
			public void onClick(View v) {
				isCheck=!isCheck;
				if (isCheck){
					_apAddStep1Continue.setEnabled(true);
					_apAddStep1Continue.setBackgroundResource(R.drawable.continue_selector);
					_apAddStep1CheckImg.setImageResource(R.drawable.remember_sel);
				}
				else{
					_apAddStep1Continue.setEnabled(false);
					_apAddStep1Continue.setBackgroundResource(R.drawable.long_oc_dis);
					_apAddStep1CheckImg.setImageResource(R.drawable.remember_nor);
				}
			}
		});

	}
}
