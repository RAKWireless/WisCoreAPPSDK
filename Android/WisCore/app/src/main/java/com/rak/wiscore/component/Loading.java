package com.rak.wiscore.component;

import android.content.Context;
import android.graphics.Color;
import android.graphics.drawable.AnimationDrawable;
import android.util.AttributeSet;
import android.view.Gravity;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.RelativeLayout;
import android.widget.TextView;

import com.rak.wiscore.R;

/**
 * Created by Jean on 2017/4/28.
 */
public class Loading extends RelativeLayout{
    private ImageView imageView;
    private TextView text;

    public Loading(Context context) {
        super(context);
        init(context);
    }

    public Loading(Context context, AttributeSet attrs) {
        super(context, attrs);
        init(context);
    }

    public Loading(Context context, AttributeSet attrs, int defStyleAttr) {
        super(context, attrs, defStyleAttr);
        init(context);
    }

    private void init(Context context) {
        setClickable(true);
        this.setBackgroundColor(Color.BLACK);
        this.setAlpha(0.7f);

        RelativeLayout layout=new RelativeLayout(context);
        LayoutParams pp=new LayoutParams(ViewGroup.LayoutParams.WRAP_CONTENT, ViewGroup.LayoutParams.WRAP_CONTENT);
        pp.addRule(RelativeLayout.CENTER_IN_PARENT);
        layout.setLayoutParams(pp);

        LinearLayout container = new LinearLayout(context);//主布局container
         // 为主布局container设置布局参数
        LinearLayout.LayoutParams llp = new LinearLayout.LayoutParams(LayoutParams.WRAP_CONTENT, LayoutParams.WRAP_CONTENT);
        llp.gravity=Gravity.CENTER;
        container.setLayoutParams(llp);//设置container的布局
        container.setOrientation(LinearLayout.VERTICAL);//设置主布局的orientation

        imageView = new ImageView(context);
        LayoutParams params=new LayoutParams(ViewGroup.LayoutParams.MATCH_PARENT, ViewGroup.LayoutParams.WRAP_CONTENT);
        params.addRule(RelativeLayout.CENTER_IN_PARENT);
        imageView.setLayoutParams(params);

//        if (android.os.Build.VERSION.SDK_INT > 22) {//android 6.0替换clip的加载动画
//            final Drawable drawable =  context.getApplicationContext().getResources().getDrawable(R.drawable.load);
//            imageView.setImageDrawable(drawable);
//        }
//        else{
//            imageView.setImageResource(R.drawable.load);
//        }
        AnimationDrawable mAnimation = new AnimationDrawable();
        mAnimation.addFrame(getContext().getResources().getDrawable(R.drawable.l00),25);
        mAnimation.addFrame(getContext().getResources().getDrawable(R.drawable.l01),25);
        mAnimation.addFrame(getContext().getResources().getDrawable(R.drawable.l02),25);
        mAnimation.addFrame(getContext().getResources().getDrawable(R.drawable.l03),25);
        mAnimation.addFrame(getContext().getResources().getDrawable(R.drawable.l04),25);
        mAnimation.addFrame(getContext().getResources().getDrawable(R.drawable.l05),25);
        mAnimation.addFrame(getContext().getResources().getDrawable(R.drawable.l06),25);
        mAnimation.addFrame(getContext().getResources().getDrawable(R.drawable.l07),25);
        mAnimation.addFrame(getContext().getResources().getDrawable(R.drawable.l08),25);
        mAnimation.addFrame(getContext().getResources().getDrawable(R.drawable.l09),25);
        mAnimation.addFrame(getContext().getResources().getDrawable(R.drawable.l10),25);
        mAnimation.addFrame(getContext().getResources().getDrawable(R.drawable.l11),25);
        mAnimation.addFrame(getContext().getResources().getDrawable(R.drawable.l12),25);
        mAnimation.addFrame(getContext().getResources().getDrawable(R.drawable.l13),25);
        mAnimation.addFrame(getContext().getResources().getDrawable(R.drawable.l14),25);
        mAnimation.addFrame(getContext().getResources().getDrawable(R.drawable.l15),25);
        mAnimation.addFrame(getContext().getResources().getDrawable(R.drawable.l16),25);
        mAnimation.addFrame(getContext().getResources().getDrawable(R.drawable.l17),25);
        mAnimation.addFrame(getContext().getResources().getDrawable(R.drawable.l18),25);
        mAnimation.addFrame(getContext().getResources().getDrawable(R.drawable.l19),25);
        mAnimation.addFrame(getContext().getResources().getDrawable(R.drawable.l20),25);
        mAnimation.addFrame(getContext().getResources().getDrawable(R.drawable.l21),25);
        mAnimation.addFrame(getContext().getResources().getDrawable(R.drawable.l22),25);
        mAnimation.addFrame(getContext().getResources().getDrawable(R.drawable.l23),25);
        mAnimation.addFrame(getContext().getResources().getDrawable(R.drawable.l24),25);
        mAnimation.addFrame(getContext().getResources().getDrawable(R.drawable.l25),25);
        mAnimation.addFrame(getContext().getResources().getDrawable(R.drawable.l26),25);
        mAnimation.addFrame(getContext().getResources().getDrawable(R.drawable.l27),25);
        mAnimation.addFrame(getContext().getResources().getDrawable(R.drawable.l28),25);
        mAnimation.addFrame(getContext().getResources().getDrawable(R.drawable.l29),25);
        mAnimation.addFrame(getContext().getResources().getDrawable(R.drawable.l30),25);
        mAnimation.addFrame(getContext().getResources().getDrawable(R.drawable.l31),25);
        mAnimation.addFrame(getContext().getResources().getDrawable(R.drawable.l32),25);
        mAnimation.addFrame(getContext().getResources().getDrawable(R.drawable.l33),25);
        mAnimation.addFrame(getContext().getResources().getDrawable(R.drawable.l34),25);
        mAnimation.addFrame(getContext().getResources().getDrawable(R.drawable.l35),25);
        mAnimation.addFrame(getContext().getResources().getDrawable(R.drawable.l36),25);
        mAnimation.addFrame(getContext().getResources().getDrawable(R.drawable.l37),25);
        mAnimation.addFrame(getContext().getResources().getDrawable(R.drawable.l38),25);
        mAnimation.addFrame(getContext().getResources().getDrawable(R.drawable.l39),25);
        mAnimation.addFrame(getContext().getResources().getDrawable(R.drawable.l40),25);
        mAnimation.addFrame(getContext().getResources().getDrawable(R.drawable.l41),25);
        mAnimation.addFrame(getContext().getResources().getDrawable(R.drawable.l42),25);
        mAnimation.addFrame(getContext().getResources().getDrawable(R.drawable.l43),25);
        mAnimation.addFrame(getContext().getResources().getDrawable(R.drawable.l44),25);
        mAnimation.addFrame(getContext().getResources().getDrawable(R.drawable.l45),25);
        mAnimation.addFrame(getContext().getResources().getDrawable(R.drawable.l46),25);
        mAnimation.addFrame(getContext().getResources().getDrawable(R.drawable.l47),25);
        mAnimation.setOneShot(false);
        imageView.setImageDrawable(mAnimation);
        if (mAnimation != null && !mAnimation.isRunning()) {
            mAnimation.start();
        }
        container.addView(imageView);

        text = new TextView(context);
        LayoutParams params2=new LayoutParams(ViewGroup.LayoutParams.MATCH_PARENT, ViewGroup.LayoutParams.WRAP_CONTENT);
        text.setLayoutParams(params2);
        text.setGravity(Gravity.CENTER);
        text.setTextColor(Color.WHITE);
        text.setTextSize(20);
        text.setText("");
        container.addView(text);

        layout.addView(container);
        this.addView(layout);
    }

    public void setText(String value){
        if (text!=null)
            text.setText(value);
    }


}
