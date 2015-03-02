package com.irontec.ikasega.fragments;

import android.annotation.SuppressLint;
import android.content.Context;
import android.media.MediaPlayer;
import android.net.Uri;
import android.os.AsyncTask;
import android.os.Bundle;
import android.os.Handler;
import android.support.v4.app.Fragment;
import android.text.Html;
import android.text.format.DateFormat;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Button;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.ProgressBar;
import android.widget.TextView;

import com.irontec.ikasega.IkasegaApplication;
import com.irontec.ikasega.QuestionActivity;
import com.irontec.ikasega.R;
import com.irontec.ikasega.domains.ProgressDomain;
import com.irontec.ikasega.domains.QuestionDomain;
import com.irontec.ikasega.domains.RankingDomain;

import java.io.File;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Timer;
import java.util.TimerTask;

import greendao.Answer;
import greendao.Exam;
import greendao.Progress;
import greendao.Question;
import greendao.Ranking;

/**
 * Created by Asier Fernandez on 28/10/14.
 */
public class QuestionsSlidePageFragment extends Fragment implements View.OnClickListener {

    private final static String TAG = QuestionsSlidePageFragment.class.getSimpleName();
    private MediaPlayer mMediaPlayer;
    private TextView mQuestionText;
    private LinearLayout mAnswersLayout;
    private Question mQuestion;
    private Exam mExam;
    private LayoutInflater mLayoutInflater;
    private Boolean mFirstTimeAnswering = true;
    private ProgressBar mProgress;
    private int mProgressStatus = 0;
    private ImageView mPlayBtn;
    private Handler mHandler = new Handler();
    private Timer mTimer = new Timer();
    private LinearLayout mLayoutAudio;
    private List<Button> mButtons;
    private Boolean mIsClickEnabled = false;

    public QuestionsSlidePageFragment() { }  // Required empty constructor

    @SuppressLint("ValidFragment")
    public QuestionsSlidePageFragment(Exam exam, Question question) {
        this.mQuestion = question;
        this.mExam = exam;
    }

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {

        ViewGroup rootView = (ViewGroup) inflater.inflate( R.layout.fragment_question, container, false);

        mLayoutAudio = (LinearLayout) rootView.findViewById(R.id.layoutAudio);
        if (mExam != null && mExam.getFile() != null && !mExam.getFile().isEmpty()) {
            mLayoutAudio.setVisibility(View.VISIBLE);
        } else {
            mLayoutAudio.setVisibility(View.GONE);
        }

        mLayoutInflater = (LayoutInflater) getActivity().getSystemService(Context.LAYOUT_INFLATER_SERVICE);
        mProgress = (ProgressBar) rootView.findViewById(R.id.progress);
        mPlayBtn = (ImageView) rootView.findViewById(R.id.play);
        mPlayBtn.setBackground(getResources().getDrawable(R.drawable.ikasega_play));
        mPlayBtn.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                if (mMediaPlayer != null && mMediaPlayer.isPlaying()) {
                    mMediaPlayer.pause();
                    mPlayBtn.setBackground(getResources().getDrawable(R.drawable.ikasega_play));
                } else if (mMediaPlayer != null && !mMediaPlayer.isPlaying()) {
                    mMediaPlayer.start();
                    mPlayBtn.setBackground(getResources().getDrawable(R.drawable.ikasega_pause));
                } else {
                    playMp3File();
                    mPlayBtn.setBackground(getResources().getDrawable(R.drawable.ikasega_pause));
                }
            }
        });

        mQuestionText = (TextView) rootView.findViewById(R.id.question_text);
        if (mQuestion != null) {
            mQuestionText.setText(mQuestion.getQuestionText());
        }
        mAnswersLayout = (LinearLayout) rootView.findViewById(R.id.answers_layout);

        populateAnswers(mAnswersLayout);

        return rootView;
    }

    @Override
    public void setUserVisibleHint(boolean isVisibleToUser) {
        super.setUserVisibleHint(isVisibleToUser);
        if (isVisibleToUser) {
            mIsClickEnabled = true;
        }else {
            mIsClickEnabled = false;
        }
    }

    @Override
    public void onStop() {
        super.onStop();
        if (mMediaPlayer != null) {
            mMediaPlayer.stop();
            mMediaPlayer.release();
        }
    }

    public void playMp3File() {
        File file = new File(getActivity().getFilesDir(), mExam.getFile() + ".mp3");
        if (file.exists()) {
            mMediaPlayer = MediaPlayer.create(getActivity(), Uri.parse(file.getAbsolutePath()));
            mMediaPlayer.setLooping(false);
            mMediaPlayer.setOnPreparedListener(new MediaPlayer.OnPreparedListener() {
                @Override
                public void onPrepared(MediaPlayer mp) {
                    if (mp.getDuration() > 0) {
                        final int duration = mMediaPlayer.getDuration();
                        final int amoungToupdate = duration / 100;
                        mTimer.schedule(new TimerTask() {
                            @Override
                            public void run() {
                                if (getActivity() != null && !getActivity().isFinishing()) {
                                    getActivity().runOnUiThread(new Runnable() {
                                        @Override
                                        public void run() {
                                            if (!(amoungToupdate * mProgress.getProgress() >= duration)) {
                                                int p = mProgress.getProgress();
                                                p += 1;
                                                mProgress.setProgress(p);
                                            }
                                        }
                                    });
                                }
                            };
                        }, 0, amoungToupdate);
                    }
                }
            });
            mMediaPlayer.start();
        }
    }

    @Override
    public void onClick(View v) {
        if (!mIsClickEnabled){
            return;
        }
        Ranking ranking = RankingDomain.getRanking(getActivity());
        if (ranking == null) {
            ranking = new Ranking();
            ranking.setPoints(0);
            ranking.setRightAnswers(0L);
            ranking.setWrongAnswers(0L);
        }
        Answer answer = (Answer) v.getTag();
        Boolean isRight = false;
        if (answer.getValid() == 1) {
            v.setBackgroundColor(getResources().getColor(R.color.holo_green_light));
            isRight = true;
        } else {
            v.setBackgroundColor(getResources().getColor(R.color.holo_red_light));
        }
        Progress progress = ProgressDomain.getSingleProgressByExamId(getActivity(), mExam.getId());
        if (progress == null) {
            progress = new Progress();
            progress.setAnsweredQuestionId(mQuestion.getId());
            progress.setExamId(mExam.getId());
        }
        String dateStr = DateFormat.format("yyyy-MM-dd hh:mm:ss", new Date()).toString();
        if (mFirstTimeAnswering) {
            progress.setStartDate(dateStr);
            mFirstTimeAnswering = false;
        }
        progress.setEndDate(dateStr);
        if (isRight) {
            int count = progress.getTotalRightAnswers() == null? 0 : progress.getTotalRightAnswers();
            progress.setTotalRightAnswers(1 + count);
            ranking.setId(1L);
            ranking.setPoints(ranking.getPoints() + IkasegaApplication.QUESTION_POINTS);
            ranking.setRightAnswers(1L + ranking.getRightAnswers());
        } else {
            ranking.setWrongAnswers(ranking.getWrongAnswers() + 1);
            int count = progress.getTotalWrongAnswers() == null? 0 : progress.getTotalWrongAnswers();
            progress.setTotalWrongAnswers(1 + count);
        }
        long idRanking = RankingDomain.insertOrUpdate(getActivity(), ranking);
        long idProcess = ProgressDomain.insertOrUpdate(getActivity(), progress);
        ((QuestionActivity) getActivity()).moveForward();
    }

    private void populateAnswers(LinearLayout layout) {
        List<Answer> answers = QuestionDomain.getAnswersForQuestionId(getActivity(), mQuestion.getId());
        LinearLayout.LayoutParams params = new LinearLayout.LayoutParams(
                LinearLayout.LayoutParams.MATCH_PARENT,
                LinearLayout.LayoutParams.WRAP_CONTENT
        );
        params.setMargins(0, 2, 0, 2);
        mButtons = new ArrayList<Button>();
        for (Answer answer : answers) {
            Button answerBtn = (Button) mLayoutInflater.inflate(R.layout.layout_answer_button, null);
            answerBtn.setLayoutParams(params);
            answerBtn.setText(answer.getAnswer());
            answerBtn.setTag(answer);
            answerBtn.setOnClickListener(this);
            layout.addView(answerBtn);
        }
    }
}