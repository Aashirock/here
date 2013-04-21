package com.spaceappschallenge.weatheronmars.helper;

import java.util.List;

import twitter4j.Status;
import android.app.Activity;
import android.content.Context;
import android.text.util.Linkify;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ArrayAdapter;
import android.widget.TextView;

import com.spaceappschallenge.weatheronmars.R;

public class TweetAdapter extends ArrayAdapter<Status> {

	Context context;
	int layoutResourceId;
	List<Status> tweets;

	public TweetAdapter(Context context, int layoutResourceId, List<Status> data) {
		super(context, layoutResourceId);

		this.context = context;
		this.layoutResourceId = layoutResourceId;
		this.tweets = data;
	}

	@Override
	public View getView(int position, View convertView, ViewGroup parent) {
		View row = convertView;
		TweetHolder holder = null;

		if (row == null) {
			LayoutInflater inflater = ((Activity) context).getLayoutInflater();
			row = inflater.inflate(layoutResourceId, parent, false);

			holder = new TweetHolder();

			holder.tvContent = (TextView) row.findViewById(R.id.tvContent);
			holder.tvDate = (TextView) row.findViewById(R.id.tvDate);

			row.setTag(holder);
		} else {
			holder = (TweetHolder) row.getTag();
		}

		Status tweet = tweets.get(position);
		holder.tvContent.setText(tweet.getText());
		holder.tvDate.setText(tweet.getCreatedAt().toString());

		Linkify.addLinks(holder.tvContent, Linkify.WEB_URLS);
		
		return row;
	}

	public void addTweet(Status tweet) {
		tweets.add(tweet);
	}

	@Override
	public int getCount() {
		return tweets.size();
	}

	static class TweetHolder {
		TextView tvDate;
		TextView tvContent;
	}

}
