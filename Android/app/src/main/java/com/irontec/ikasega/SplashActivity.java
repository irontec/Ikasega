package com.irontec.ikasega;

import android.app.Activity;
import android.content.Intent;
import android.content.SharedPreferences;
import android.os.AsyncTask;
import android.os.Bundle;
import android.preference.PreferenceManager;
import android.util.Log;
import android.view.Menu;
import android.view.MenuItem;
import android.widget.Toast;

import com.google.gson.Gson;
import com.google.gson.stream.JsonReader;
import com.irontec.ikasega.domains.AnswerDomain;
import com.irontec.ikasega.domains.ExamDomain;
import com.irontec.ikasega.domains.QuestionDomain;
import com.irontec.ikasega.networking.HTTPClient;
import com.loopj.android.http.FileAsyncHttpResponseHandler;
import com.loopj.android.http.JsonHttpResponseHandler;
import com.squareup.okhttp.Request;
import com.squareup.okhttp.Response;

import org.apache.http.Header;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.util.ArrayList;
import java.util.List;

import greendao.Answer;
import greendao.Exam;
import greendao.Question;


public class SplashActivity extends Activity {

    private final static String TAG = SplashActivity.class.getSimpleName();

    private List<Exam> mExams;
    private List<Question> mQuestions = new ArrayList<Question>();
    private List<Answer> mAnswers = new ArrayList<Answer>();

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_splash);

        checkVersion();
    }

    public void checkVersion() {
        HTTPClient httpClient = HTTPClient.getInstance();
        httpClient.getAsync(HTTPClient.VERSION, null, new JsonHttpResponseHandler() {
            @Override
            public void onSuccess(int statusCode, Header[] headers, JSONObject response) {
                super.onSuccess(statusCode, headers, response);
                Log.d(TAG, "GET STATUS: " + statusCode);
                Log.d(TAG, "GET RESPONSE: " + response.toString());
                try {
                    JSONObject versionObj = new JSONObject(response.toString());
                    SharedPreferences prefs = PreferenceManager.getDefaultSharedPreferences(SplashActivity.this);
                    Integer currentVersion = prefs.getInt(IkasegaApplication.PREFS_VERSION_KEY, -1);
                    List<Exam> exams = ExamDomain.getAll(SplashActivity.this);
                    if (currentVersion < 0 || versionObj.getInt("version") > currentVersion || exams.isEmpty()) {
                        new GetExamsTask().execute();
                        SharedPreferences.Editor editor = prefs.edit();
                        editor.putInt(IkasegaApplication.PREFS_VERSION_KEY, versionObj.getInt("version"));
                        editor.commit();
                    } else {
                        startMainActivity();
                    }
                } catch (JSONException jsEx) {
                    jsEx.printStackTrace();
                }
            }

            @Override
            public void onFailure(int statusCode, Header[] headers, Throwable throwable, JSONObject errorResponse) {
                super.onFailure(statusCode, headers, throwable, errorResponse);
                Log.d(TAG, "GET STATUS: " + statusCode);
                Toast.makeText(SplashActivity.this, R.string.http_error, Toast.LENGTH_LONG).show();
            }
        });
    }

    public class GetExamsTask extends AsyncTask<Void, Void, Void> {

        @Override
        protected Void doInBackground(Void... params) {
            HTTPClient httpClient = HTTPClient.getInstance();
            InputStream stream = null;
            Gson gson = new Gson();
            try {
                Response response = httpClient.run(HTTPClient.EXAMS);
                JSONObject jsonResponse = new JSONObject(response.body().string());
                mExams = new ArrayList<Exam>();
                JSONArray examsArray = jsonResponse.getJSONArray("exams");
                for (int i = 0; i < examsArray.length(); i++) {
                    JSONObject examJson = examsArray.getJSONObject(i);
                    Exam exam = gson.fromJson(examJson.toString(), Exam.class);
                    JSONArray questionsArray = examJson.getJSONArray("questions");
                    for (int j = 0; j < questionsArray.length(); j++) {
                        JSONObject questionJson = questionsArray.getJSONObject(j);
                        Question question = gson.fromJson(questionJson.toString(), Question.class);
                        question.setExamId(exam.getId());
                        Log.d(TAG, "Insert of question id " + question.getId() + " for exam id " + question.getExamId());
                        JSONArray answersArray = questionJson.getJSONArray("answers");
                        for (int k = 0; k < answersArray.length(); k++) {
                            JSONObject answerJson = answersArray.getJSONObject(k);
                            Answer answer = gson.fromJson(answerJson.toString(), Answer.class);
                            answer.setQuestionId(question.getId());
                            mAnswers.add(answer);
                        }
                        mQuestions.add(question);
                    }
                    Log.d(TAG, "*********************************************************************************");
                    mExams.add(exam);
                }
                ExamDomain.insertOrReplaceInTx(SplashActivity.this, mExams);
                QuestionDomain.insertOrReplaceInTx(SplashActivity.this, mQuestions);
                AnswerDomain.insertOrReplaceInTx(SplashActivity.this, mAnswers);
                Log.d(TAG, "How many exams? " + mExams.size());
                Log.d(TAG, "How many questions? " + mQuestions.size());
                Log.d(TAG, "How many answers? " + mAnswers.size());
                for (Exam exam : mExams) {
                    if (exam.getFile() != null) {
                        downloadMp3Files(exam);
                    }
                }
            } catch (IOException ioEx) {
                ioEx.printStackTrace();
            } catch (JSONException jsEx) {
                jsEx.printStackTrace();
            }
            return null;
        }

        @Override
        protected void onPostExecute(Void aVoid) {
            super.onPostExecute(aVoid);
            startMainActivity();
        }
    }

    public void checkFileAndDeleteIfExists(File file) {
        if (file.exists()) {
            file.delete();
            try {
                file.createNewFile();
            } catch (IOException ioEx) {
                ioEx.printStackTrace();
            }
        }
    }

    public void downloadMp3Files(Exam exam) {
        File file = new File(getFilesDir(), exam.getFile() + ".mp3");
        checkFileAndDeleteIfExists(file);
        HTTPClient httpClient = HTTPClient.getInstance();
        httpClient.getFile(HTTPClient.MP3_FOLDER + exam.getFile() + HTTPClient.EXT_MP3, null, new FileAsyncHttpResponseHandler(file) {
            @Override
            public void onSuccess(int statusCode, Header[] headers, File file) {
                Log.d(TAG, "Downloaded MP3: " + file.getAbsolutePath());
            }

            @Override
            public void onFailure(int statusCode, Header[] headers, Throwable throwable, File file) {
                Log.d(TAG, "GET STATUS: " + statusCode);
                Toast.makeText(SplashActivity.this, R.string.http_error, Toast.LENGTH_LONG).show();
            }
        });
    }

    public void startMainActivity() {
        Intent intent = new Intent(SplashActivity.this, MainActivity.class);
        startActivity(intent);
        finish();
    }

    @Override
    public boolean onCreateOptionsMenu(Menu menu) {
        getMenuInflater().inflate(R.menu.splash, menu);
        return true;
    }

    @Override
    public boolean onOptionsItemSelected(MenuItem item) {
        int id = item.getItemId();
        /*if (id == R.id.action_settings) {
            return true;
        }*/
        return super.onOptionsItemSelected(item);
    }
}
