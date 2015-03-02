package com.irontec.ikasega.adapters;

import android.content.Context;
import android.content.Intent;
import android.graphics.Color;
import android.graphics.Typeface;
import android.support.v7.widget.RecyclerView;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.TextView;

import com.amulyakhare.textdrawable.TextDrawable;
import com.amulyakhare.textdrawable.util.ColorGenerator;
import com.irontec.ikasega.FinishedExamActivity;
import com.irontec.ikasega.IkasegaApplication;
import com.irontec.ikasega.QuestionActivity;
import com.irontec.ikasega.R;
import com.irontec.ikasega.domains.ExamDomain;
import com.irontec.ikasega.domains.ProgressDomain;
import com.irontec.ikasega.domains.QuestionDomain;
import com.irontec.ikasega.domains.RankingDomain;
import com.irontec.ikasega.parcelables.RecyclerViewDataParcelable;

import java.util.List;

import greendao.Exam;
import greendao.Progress;
import greendao.Question;
import greendao.QuestionDao;
import greendao.Ranking;

/**
 * Created by Asier Fernandez on 21/10/14.
 */
public class ExamsAdapter extends RecyclerView.Adapter<ExamsAdapter.ViewHolder> {

    private final static String TAG = ExamsAdapter.class.getSimpleName();
    private Context mContext;
    private List<Exam> mDataset;

    public static class ViewHolder extends RecyclerView.ViewHolder implements View.OnClickListener {

        public TextView mExamName;
        public ImageView mExamImage;
        public ViewHolderClicks mListener;

        public ViewHolder(View view, ViewHolderClicks listener) {
            super(view);
            mListener = listener;
            view.setOnClickListener(this);
            mExamImage = (ImageView) view.findViewById(R.id.exam_image);
            mExamName = (TextView) view.findViewById(R.id.exam_name);
        }

        @Override
        public void onClick(View view) {
            mListener.onItemClick(view);
        }

        public static interface ViewHolderClicks {
            public void onItemClick(View caller);
        }

    }

    public ExamsAdapter(Context context, List<Exam> myDataset) {
        mContext = context;
        mDataset = myDataset;
    }

    @Override
    public ExamsAdapter.ViewHolder onCreateViewHolder(ViewGroup parent, int viewType) {
        View v = LayoutInflater.from(parent.getContext()).inflate(R.layout.card, parent, false);
        ExamsAdapter.ViewHolder vh = new ViewHolder(v, new ExamsAdapter.ViewHolder.ViewHolderClicks() {
            public void onItemClick(View caller) {
                RecyclerViewDataParcelable data = (RecyclerViewDataParcelable)caller.getTag();
                Progress progress = ProgressDomain.getSingleProgressByExamId(mContext, Long.valueOf(data.getParam2()));
                List<Question> questions = QuestionDomain.getAllForExamId(mContext, Long.valueOf(data.getParam2()));
                Intent intent = new Intent(mContext, QuestionActivity.class);
                int percentage = 0;
                if (progress != null && !questions.isEmpty()) {
                    percentage = (int)(((progress.getTotalWrongAnswers() + progress.getTotalRightAnswers()) * 100) / questions.size());
                    if (percentage >= 100) {
                        intent = new Intent(mContext, FinishedExamActivity.class);
                    }
                }
                intent.putExtra("exam", (RecyclerViewDataParcelable) caller.getTag());
                mContext.startActivity(intent);
            };
        });
        return vh;
    }

    @Override
    public void onBindViewHolder(ViewHolder holder, int position) {
        Exam exam = mDataset.get(position);
        holder.mExamName.setText(exam.getUrl());
        Progress progress = ProgressDomain.getSingleProgressByExamId(mContext, exam.getId());
        List<Question> questions = QuestionDomain.getAllForExamId(mContext, exam.getId());
        int percentage = 0;
        if (progress != null && !questions.isEmpty()) {
            percentage = (int)(((progress.getTotalWrongAnswers() + progress.getTotalRightAnswers()) * 100) / questions.size());
            if (percentage >= 100) {
                percentage = 100;

                Ranking ranking = RankingDomain.getRanking(mContext);
                if (ranking == null) {
                    ranking = new Ranking();
                    ranking.setPoints(0);
                    ranking.setRightAnswers(0L);
                    ranking.setWrongAnswers(0L);
                    ranking.setCompletedExams(0);
                }
                ranking.setId(1L);
                ranking.setPoints(ranking.getPoints() + IkasegaApplication.EXAM_POINTS);
                if (ranking.getCompletedExams() == null) {
                    ranking.setCompletedExams(1);
                } else {
                    ranking.setCompletedExams(ranking.getCompletedExams() + 1);
                }
                RankingDomain.insertOrUpdate(mContext, ranking);
            }
        }

        int background = generateBackgroundColor(percentage);
        int text = generateTextColor(percentage);
        TextDrawable drawable = TextDrawable.builder()
                .beginConfig()
                .textColor(text)
                .useFont(Typeface.SANS_SERIF)
                .fontSize(40) /* size in px */
                .toUpperCase()
                .endConfig()
                .buildRound(percentage + "%", background);

        holder.mExamImage.setImageDrawable(drawable);

        RecyclerViewDataParcelable data = new RecyclerViewDataParcelable();
        data.setParam1(exam.getUrl());
        data.setParam2(exam.getId().toString());
        holder.itemView.setTag(data);
    }

    private int generateBackgroundColor(int percentage) {
        String defaultColor = "f0f0f0";
        String progressColor = "e95f22";
        if (percentage < 5) {
            return Color.parseColor("#" + defaultColor);
        } else if (percentage >= 5 && percentage < 25) {
            return Color.parseColor("#73" + progressColor);
        } else if (percentage >= 25 && percentage < 50) {
            return Color.parseColor("#B3" + progressColor);
        } else if (percentage >= 50 && percentage < 75) {
            return Color.parseColor("#D9" + progressColor);
        } else if (percentage >= 75 && percentage < 95) {
            return Color.parseColor("#F2" + progressColor);
        } else {
            return Color.parseColor("#" + progressColor);
        }
    }

    private int generateTextColor(int percentage) {
        String defaultColor = "000000";
        String progressColor = "FFFFFF";
        if (percentage < 5) {
            return Color.parseColor("#" + defaultColor);
        } else if (percentage >= 5 && percentage < 25) {
            return Color.parseColor("#73" + progressColor);
        } else if (percentage >= 25 && percentage < 50) {
            return Color.parseColor("#B3" + progressColor);
        } else if (percentage >= 50 && percentage < 75) {
            return Color.parseColor("#D9" + progressColor);
        } else if (percentage >= 75 && percentage < 95) {
            return Color.parseColor("#F2" + progressColor);
        } else {
            return Color.parseColor("#" + progressColor);
        }
    }

    @Override
    public int getItemCount() {
        return mDataset.size();
    }

    public void addAll(List<Exam> items) {
        mDataset.clear();
        mDataset.addAll(items);
        notifyDataSetChanged();
    }
}