package com.irontec.ikasega;

import android.os.Bundle;
import android.support.v7.app.ActionBarActivity;
import android.view.Menu;
import android.view.MenuItem;
import android.widget.TextView;

import com.irontec.ikasega.domains.RankingDomain;
import com.irontec.ikasega.ui.FontFitTextView;

import java.text.NumberFormat;
import java.util.Locale;

import greendao.Ranking;


public class RankingActivity extends ActionBarActivity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_ranking);
        getSupportActionBar().setDisplayHomeAsUpEnabled(true);
        Ranking ranking = RankingDomain.getRanking(this);

        FontFitTextView points = (FontFitTextView) findViewById(R.id.points);
        TextView completedExams = (TextView) findViewById(R.id.completed_exams);
        TextView rightAnswers = (TextView) findViewById(R.id.rightAnswers);
        TextView wrongAnswers = (TextView) findViewById(R.id.wrongAnswers);
        TextView average = (TextView) findViewById(R.id.average);

        if ( ranking == null || ranking.getPoints() == null) {
            points.setText(NumberFormat.getInstance().format(0));
        } else {
            points.setText(NumberFormat.getInstance().format(ranking.getPoints()));
        }

        if ( ranking == null || ranking.getCompletedExams() == null) {
            completedExams.setText(NumberFormat.getInstance().format(0));
        } else {
            completedExams.setText(NumberFormat.getInstance().format(ranking.getCompletedExams()));
        }

        long rightAnswersCount = 0;
        long wrongAnswersCount = 0;

        if ( ranking == null || ranking.getRightAnswers() == null) {
            rightAnswers.setText(NumberFormat.getInstance().format(0));
        } else {
            rightAnswersCount = ranking.getRightAnswers();
            rightAnswers.setText(NumberFormat.getInstance().format(ranking.getRightAnswers()));
        }

        if ( ranking == null || ranking.getWrongAnswers() == null) {
            wrongAnswers.setText(NumberFormat.getInstance().format(0));
        } else {
            wrongAnswersCount = ranking.getWrongAnswers();
            wrongAnswers.setText(NumberFormat.getInstance().format(ranking.getWrongAnswers()));
        }

        if ((rightAnswersCount + wrongAnswersCount) == 0) {
            average.setText(
                    NumberFormat.getInstance().format(0) + "%");
        } else {
            average.setText(
                    NumberFormat.getInstance().format(
                            (rightAnswersCount * 100) / (rightAnswersCount + wrongAnswersCount)
                    ) + "%");
        }
    }

    @Override
    public boolean onCreateOptionsMenu(Menu menu) {
        getMenuInflater().inflate(R.menu.menu_ranking, menu);
        return true;
    }

    @Override
    public boolean onOptionsItemSelected(MenuItem item) {
        int id = item.getItemId();
        if (id == android.R.id.home) {
            finish();
            return true;
        }
        return super.onOptionsItemSelected(item);
    }
}
