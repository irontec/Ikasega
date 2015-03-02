package com.irontec.ikasega.parcelables;

import android.os.Parcel;
import android.os.Parcelable;

/**
 * Created by Asier Fernandez on 28/10/14.
 */
public class RecyclerViewDataParcelable implements Parcelable {

    public String param1;
    public String param2;
    public String param3;

    public String getParam1() {
        return param1;
    }

    public void setParam1(String param1) {
        this.param1 = param1;
    }

    public String getParam2() {
        return param2;
    }

    public void setParam2(String param2) {
        this.param2 = param2;
    }

    public String getParam3() {
        return param3;
    }

    public void setParam3(String param3) {
        this.param3 = param3;
    }

    @Override
    public int describeContents() {
        return 0;
    }

    @Override
    public void writeToParcel(Parcel dest, int flags) {
        dest.writeString(this.param1);
        dest.writeString(this.param2);
        dest.writeString(this.param3);
    }

    public RecyclerViewDataParcelable() {
    }

    private RecyclerViewDataParcelable(Parcel in) {
        this.param1 = in.readString();
        this.param2 = in.readString();
        this.param3 = in.readString();
    }

    public static final Parcelable.Creator<RecyclerViewDataParcelable> CREATOR = new Parcelable.Creator<RecyclerViewDataParcelable>() {
        public RecyclerViewDataParcelable createFromParcel(Parcel source) {
            return new RecyclerViewDataParcelable(source);
        }

        public RecyclerViewDataParcelable[] newArray(int size) {
            return new RecyclerViewDataParcelable[size];
        }
    };
}
