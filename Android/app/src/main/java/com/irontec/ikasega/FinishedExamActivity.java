package com.irontec.ikasega;

import android.content.Intent;
import android.graphics.drawable.ShapeDrawable;
import android.support.v7.app.ActionBar;
import android.support.v7.app.ActionBarActivity;
import android.os.Bundle;
import android.view.MenuItem;
import android.view.View;
import android.widget.Button;
import android.widget.LinearLayout;
import android.widget.TextView;

import com.github.mikephil.charting.charts.PieChart;
import com.github.mikephil.charting.data.PieData;

import com.github.mikephil.charting.data.Entry;
import com.github.mikephil.charting.data.PieDataSet;
import com.irontec.ikasega.domains.ExamDomain;
import com.irontec.ikasega.domains.ProgressDomain;
import com.irontec.ikasega.parcelables.RecyclerViewDataParcelable;
import com.irontec.ikasega.ui.WeirdShapeLeft;
import com.irontec.ikasega.ui.WeirdShapeRight;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;

import greendao.Exam;
import greendao.Progress;


public class FinishedExamActivity extends ActionBarActivity {

    private Long mExamId;
    private Exam mExam;
    private Progress mProgress;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_finished_exam);

        ActionBar actionBar = getSupportActionBar();
        actionBar.setDisplayHomeAsUpEnabled(true);

        LinearLayout linearStart = (LinearLayout) findViewById(R.id.weirdShapeRight);
        LinearLayout linearEnd = (LinearLayout) findViewById(R.id.weirdShapeLeft);

        TextView tvStart = (TextView) findViewById(R.id.start);
        TextView tvEnd = (TextView) findViewById(R.id.end);

        Button shareBtn = (Button) findViewById(R.id.shareBtn);


        linearStart.setBackground(new ShapeDrawable(new WeirdShapeRight()));
        linearEnd.setBackground(new ShapeDrawable(new WeirdShapeLeft()));

        mProgress = null;
        Intent intent = getIntent();
        if(intent != null && intent.getExtras() != null) {
            RecyclerViewDataParcelable data = intent.getExtras().getParcelable("exam");
            mExamId = Long.valueOf(data.getParam2());
            mExam = ExamDomain.getForId(this, mExamId);
            mProgress = ProgressDomain.getSingleProgressByExamId(this, mExamId);
        }

        PieChart chart = (PieChart) findViewById(R.id.chart1);
        chart = configureChart(chart);
        if (mProgress != null) {
            chart = setData(chart, mProgress);
            tvStart.setText(mProgress.getStartDate());
            tvEnd.setText(mProgress.getEndDate());
        }
        chart.animateXY(1500, 1500);

        shareBtn.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                if (mExam == null && mProgress != null) {
                    return;
                }
                String shareBody = getString(R.string.share_text, mExam.getUrl(), mProgress.getTotalRightAnswers());
                Intent sharingIntent = new Intent(android.content.Intent.ACTION_SEND);
                sharingIntent.setType("text/plain");
                sharingIntent.putExtra(android.content.Intent.EXTRA_TEXT, shareBody);
                startActivity(Intent.createChooser(sharingIntent, getResources().getString(R.string.share_using)));
            }
        });
    }

    public String formatDate(String date) {
        SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss'Z'");
        try {
            Date parsedDate = format.parse(date);
            return parsedDate.toString();
        } catch (ParseException e) {
            e.printStackTrace();
        }
        return "";
    }

    public PieChart configureChart(PieChart chart) {
        chart.setHoleColor(getResources().getColor(android.R.color.background_dark));
        chart.setHoleRadius(60f);
        chart.setDescription("");
        chart.setTransparentCircleRadius(5f);
        chart.setDrawYValues(true);
        chart.setDrawCenterText(false);
        chart.setDrawHoleEnabled(false);
        chart.setRotationAngle(0);
        chart.setDrawXValues(false);
        chart.setRotationEnabled(false);
        chart.setUsePercentValues(true);
        return chart;
    }

    private PieChart setData(PieChart chart, Progress progress) {
        ArrayList<Entry> yVals1 = new ArrayList<Entry>();
        if (progress.getTotalRightAnswers() != null) {
            yVals1.add(new Entry(progress.getTotalRightAnswers(), 0));
        }
        if (progress.getTotalWrongAnswers() != null) {
            yVals1.add(new Entry(progress.getTotalWrongAnswers(), 1));
        }
        ArrayList<String> xVals = new ArrayList<String>();
        xVals.add("Ondo");
        xVals.add("Gaizki");
        PieDataSet set1 = new PieDataSet(yVals1, "");
        set1.setSliceSpace(0f);
        ArrayList<Integer> colors = new ArrayList<Integer>();
        colors.add(getResources().getColor(android.R.color.holo_green_light));
        colors.add(getResources().getColor(android.R.color.holo_red_light));
        set1.setColors(colors);
        PieData data = new PieData(xVals, set1);
        chart.setData(data);
        chart.highlightValues(null);
        chart.invalidate();
        return chart;
    }

    @Override
    public boolean onOptionsItemSelected(MenuItem item) {
        if (item.getItemId() == android.R.id.home) {
            finish();
        }
        return super.onOptionsItemSelected(item);
    }
}
