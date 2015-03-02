package com.irontec.ikasega.ui;

/**
 * Created by axier on 28/01/15.
 */
import android.graphics.Canvas;
import android.graphics.Color;
import android.graphics.Paint;
import android.graphics.Path;
import android.graphics.RectF;
import android.graphics.drawable.shapes.Shape;

import com.irontec.ikasega.R;

public class WeirdShapeLeft extends Shape {
    private static final int    COLOUR       = Color.parseColor("#1aaaae");
    private static final float  STROKE_WIDTH = 2.0f;
    private static final float  CORNER = 20.0f;

    private final Paint border = new Paint();
    private final Path  path;

    public WeirdShapeLeft() {
        path   = new Path();

        border.setColor      (COLOUR);
        border.setStyle      (Paint.Style.STROKE);
        border.setStrokeWidth(STROKE_WIDTH);
        border.setAntiAlias  (true);
        border.setDither     (true);
        border.setStrokeJoin (Paint.Join.ROUND);
        border.setStrokeCap  (Paint.Cap.ROUND);
    }

    @Override
    protected void onResize(float width, float height) {
        super.onResize(width, height);

        float dx = STROKE_WIDTH/2.0f;
        float dy = STROKE_WIDTH/2.0f;
        float x  = dx;
        float y  = dy;
        float w  = width  - dx;
        float h  = height - dy;

        RectF arc = new RectF(x,h-2*CORNER,x+2*CORNER,h);

        path.reset();
        path.moveTo(x + CORNER, y);
        path.lineTo(w, y);
        path.lineTo(w, h);
        path.lineTo(x, h);
        path.lineTo(x,h - CORNER);
        path.lineTo(x,y + CORNER);
        path.close();
    }

    @Override
    public void draw(Canvas canvas, Paint paint) {
        canvas.drawPath(path,border);
    }
}