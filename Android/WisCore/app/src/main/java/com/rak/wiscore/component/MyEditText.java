package com.rak.wiscore.component;

import android.content.Context;
import android.graphics.Canvas;
import android.graphics.Color;
import android.graphics.Paint;
import android.graphics.RectF;
import android.util.AttributeSet;
import android.widget.EditText;

/**
 * Created by Jean on 2017/1/7.
 */
public class MyEditText extends EditText {
    public MyEditText(Context context, AttributeSet attrs) {
        super(context, attrs);
    }

    @Override
    protected void onDraw(Canvas canvas) {
        Paint paint = new Paint();
        paint.setStyle(Paint.Style.STROKE);
        paint.setStrokeWidth(2);
        if(this.isFocused() == true) {
            paint.setColor(Color.rgb(59, 201, 216));//得到焦点时颜色
            this.setBackgroundColor(Color.rgb(255, 255, 255));
        }
        else {
            paint.setColor(Color.rgb(224, 227, 239));//没有得到焦点时颜色
            this.setBackgroundColor(Color.rgb(244, 244, 249));
        }
        canvas.drawRoundRect(new RectF(2+this.getScrollX(), 2+this.getScrollY(), this.getWidth()-3+this.getScrollX(), this.getHeight()+ this.getScrollY()-1), 3,3, paint);
        super.onDraw(canvas);
    }
}
