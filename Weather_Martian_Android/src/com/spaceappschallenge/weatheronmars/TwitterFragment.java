package com.spaceappschallenge.weatheronmars;

import java.util.ArrayList;
import java.util.List;

import twitter4j.Status;
import android.os.Bundle;
import android.support.v4.app.ListFragment;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;

import com.spaceappschallenge.weatheronmars.helper.TweetAdapter;

public class TwitterFragment extends ListFragment {

	TweetAdapter adapter;
	List<Status> tweets;

	@Override
	public View onCreateView(LayoutInflater inflater, ViewGroup container,
			Bundle savedInstanceState) {

		View view = inflater.inflate(R.layout.fragment_twitter, container,
				false);

		return view;
	}

	@Override
	public void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);

		tweets = new ArrayList<Status>();
		adapter = new TweetAdapter(getActivity(), R.layout.listview_row, tweets);
		setListAdapter(adapter);
	}

	public void setTweets(List<Status> tweets) {
		List<Status> listTweets = tweets;
		adapter = new TweetAdapter(getActivity(), R.layout.listview_row, tweets);
		setListAdapter(adapter);
	}
}
