package com.irontec.ikasega;

import android.content.Intent;
import android.media.MediaPlayer;
import android.net.Uri;
import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.support.v4.app.FragmentManager;
import android.support.v4.app.FragmentStatePagerAdapter;
import android.support.v4.view.PagerAdapter;
import android.support.v4.view.ViewPager;
import android.support.v7.app.ActionBar;
import android.support.v7.app.ActionBarActivity;
import android.view.Menu;
import android.view.MenuItem;

import com.irontec.ikasega.domains.ExamDomain;
import com.irontec.ikasega.domains.ProgressDomain;
import com.irontec.ikasega.fragments.QuestionsSlidePageFragment;
import com.irontec.ikasega.parcelables.RecyclerViewDataParcelable;
import com.irontec.ikasega.transformers.DepthPageTransformer;
import com.irontec.ikasega.widget.NonSwipeableViewPager;

import java.io.File;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;

import greendao.Exam;
import greendao.Progress;
import greendao.Question;

public class QuestionActivity extends ActionBarActivity {

    private final static String TAG = QuestionActivity.class.getSimpleName();

    private Exam mExam;
    private Long mExamId;
    private NonSwipeableViewPager mPager;
    private PagerAdapter mPagerAdapter;
    private List<Question> mQuestions;
    private ActionBar mActionBar;
    private MediaPlayer mMediaPlayer;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_question);

        mActionBar = getSupportActionBar();
        mActionBar.setDisplayHomeAsUpEnabled(true);

        Intent intent = getIntent();
        if(intent != null && intent.getExtras() != null) {
            RecyclerViewDataParcelable data = intent.getExtras().getParcelable("exam");
            mExamId = Long.valueOf(data.getParam2());
        }

        mExam = ExamDomain.getForId(this, mExamId);
        if (mExam != null) {
            mActionBar.setTitle(mExam.getUrl());
        }

        mQuestions = ExamDomain.getForId(this, mExamId).getQuestions();
        List<Progress> progresses = ProgressDomain.getProgressByExamId(this, mExamId);
        List<Long> ids = new ArrayList<Long>();

        Iterator<Question> iterator = mQuestions.iterator();
        for (Iterator<Question> it = mQuestions.iterator(); it.hasNext();) {
            Question question = it.next();
            for (Progress progress : progresses) {
                if (question.getId().equals(progress.getAnsweredQuestionId())) {
                    it.remove();
                    break;
                }
            }
        }

        mPager = (NonSwipeableViewPager) findViewById(R.id.pager);
        mPager.setPageTransformer(true, new DepthPageTransformer());
        mPagerAdapter = new ScreenSlidePagerAdapter(getSupportFragmentManager());
        mPager.setAdapter(mPagerAdapter);

    }

    public void moveForward() {
        if (mPager.getCurrentItem() + 1 < mPagerAdapter.getCount()) {
            mPager.setCurrentItem(mPager.getCurrentItem() + 1, true);
        } else {
            Intent intent = new Intent(this, FinishedExamActivity.class);
            RecyclerViewDataParcelable bundle = new RecyclerViewDataParcelable();
            bundle.setParam2(mExamId.toString());
            intent.putExtra("exam", bundle);
            startActivity(intent);
            finish();
        }
    }

    public class ScreenSlidePagerAdapter extends FragmentStatePagerAdapter {

        public ScreenSlidePagerAdapter(FragmentManager fm) {
            super(fm);
        }

        @Override
        public Fragment getItem(int position) {
            if (mQuestions != null && !mQuestions.isEmpty()) {
                return new QuestionsSlidePageFragment(mExam, mQuestions.get(position));
            } else {
                return new QuestionsSlidePageFragment();
            }
        }

        @Override
        public int getCount() {
            return mQuestions.size();
        }
    }

    public void playMp3File() {
        File file = new File(getFilesDir(), mExam.getFile() + ".mp3");
        if (file.exists()) {
            mMediaPlayer = MediaPlayer.create(this, Uri.parse(file.getAbsolutePath()));
            mMediaPlayer.setLooping(false);
            mMediaPlayer.start();
        }

    }

    @Override
    protected void onStop() {
        super.onStop();
        if (mMediaPlayer != null) {
            mMediaPlayer.stop();
            mMediaPlayer.release();
        }
    }

    @Override
    public boolean onCreateOptionsMenu(Menu menu) {
        return super.onCreateOptionsMenu(menu);
    }

    @Override
    public boolean onOptionsItemSelected(MenuItem item) {
        int id = item.getItemId();
        if (id == android.R.id.home) {
            finish();
        }
        return super.onOptionsItemSelected(item);
    }
}
