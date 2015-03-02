package com.irontec.ikasega.networking;

import android.util.Log;

import com.loopj.android.http.AsyncHttpClient;
import com.loopj.android.http.AsyncHttpResponseHandler;
import com.loopj.android.http.RequestParams;
import com.loopj.android.http.SyncHttpClient;
import com.squareup.okhttp.OkHttpClient;
import com.squareup.okhttp.Request;
import com.squareup.okhttp.Response;

import java.io.IOException;
import java.io.InputStream;

/**
 * Created by Asier Fernandez on 23/10/14.
 */
public class HTTPClient {

    private static final String TAG = HTTPClient.class.getSimpleName();

    private static HTTPClient INSTANCE = null;

    private static final String BASE_URL = "http://lander.irontec.com/Ikasega/";

    public static final String EXAMS = "ikasega.json";
    public static final String VERSION = "ikasega.version.json";
    public static final String MP3_FOLDER = "mp3low/";
    public static final String EXT_MP3 = ".mp3";

    private OkHttpClient okClient = null;
    private AsyncHttpClient asyncClient = null;
    private SyncHttpClient filesClient = null;

    public static HTTPClient getInstance() {
        if (INSTANCE == null) {
            INSTANCE = new HTTPClient();
        }
        return INSTANCE;
    }

    public HTTPClient() {
        if (okClient == null) {
            okClient = new OkHttpClient();
        }
        if (asyncClient == null) {
            asyncClient = new AsyncHttpClient();
        }
        if (filesClient == null) {
            filesClient = new SyncHttpClient();
        }
    }

    public Response run(String url) throws IOException {
        Log.d(TAG, "GET - " + getAbsoluteUrl(url));
        Request request = new Request.Builder()
                .url(getAbsoluteUrl(url))
                .build();

        Response response = okClient.newCall(request).execute();
        return response;
    }

    public void getAsync(String url, RequestParams params, AsyncHttpResponseHandler responseHandler) {
        Log.d(TAG, "GET FILE - " + getAbsoluteUrl(url));
        asyncClient.get(getAbsoluteUrl(url), params, responseHandler);
    }

    public void getFile(String url, RequestParams params, AsyncHttpResponseHandler responseHandler) {
        Log.d(TAG, "GET FILE - " + getAbsoluteUrl(url));
        filesClient.get(getAbsoluteUrl(url), params, responseHandler);
    }

    private String getAbsoluteUrl(String relativeUrl) {
        return BASE_URL + relativeUrl;
    }

}
