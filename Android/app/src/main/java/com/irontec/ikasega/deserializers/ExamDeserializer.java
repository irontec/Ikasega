package com.irontec.ikasega.deserializers;

import com.google.gson.JsonDeserializationContext;
import com.google.gson.JsonDeserializer;
import com.google.gson.JsonElement;
import com.google.gson.JsonObject;
import com.google.gson.JsonParseException;

import java.lang.reflect.Type;

import greendao.Exam;

/**
 * Created by Asier Fernandez on 23/10/14.
 */
public class ExamDeserializer implements JsonDeserializer<Exam> {
    @Override
    public Exam deserialize(JsonElement json, Type typeOfT, JsonDeserializationContext context) throws JsonParseException {
        JsonObject jsonObj = (JsonObject) json;
        Exam exam = new Exam();
        exam.setUrl(jsonObj.get("url").getAsString());
        return exam;
    }
}
