package com.spaceappschallenge.weatheronmars;

import java.io.IOException;
import java.util.List;
import java.util.Random;

import javax.xml.parsers.ParserConfigurationException;

import org.xml.sax.SAXException;

import twitter4j.Twitter;
import twitter4j.TwitterException;
import twitter4j.TwitterFactory;
import twitter4j.auth.AccessToken;
import twitter4j.auth.RequestToken;
import twitter4j.conf.Configuration;
import twitter4j.conf.ConfigurationBuilder;
import android.app.ProgressDialog;
import android.content.Intent;
import android.content.SharedPreferences;
import android.os.AsyncTask;
import android.os.Bundle;
import android.support.v4.app.FragmentActivity;
import android.support.v4.app.FragmentTransaction;
import android.util.Log;
import android.view.Gravity;
import android.view.LayoutInflater;
import android.view.Menu;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.ProgressBar;
import android.widget.TextView;
import android.widget.Toast;

import com.spaceappschallenge.weatheronmars.business.Magnitudes.MagnitudesDTO;
import com.spaceappschallenge.weatheronmars.business.WeatherReport;
import com.spaceappschallenge.weatheronmars.dao.TriviaAdapter;
import com.spaceappschallenge.weatheronmars.helper.Const;
import com.spaceappschallenge.weatheronmars.helper.DeviceConnection;

public class MainActivity extends FragmentActivity {

	TextView tvDate, tvSunrise, tvSunset;
	TextView tvTemperature, tvPressure, tvHumidity;
	TextView tvWindSpeed, tvSeason;
	ImageView ivTwitter;
	ProgressBar pbTwitter;

	WeatherReport wr;

	private Twitter mTwitter;
	private RequestToken mRequestToken;
	List<twitter4j.Status> statuses;
	String user = "MarsWxReport";

	boolean isRefreshTaskRunning = false;
	boolean isTimelineTaskRunning = false;
	ProgressDialog pbLoading;

	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.activity_main);

		tvDate = (TextView) findViewById(R.id.tvDate);
		tvPressure = (TextView) findViewById(R.id.tvPressure);
		tvHumidity = (TextView) findViewById(R.id.tvHumidity);
		tvWindSpeed = (TextView) findViewById(R.id.tvWindSpeed);
		tvTemperature = (TextView) findViewById(R.id.tvTemperature);
		tvSeason = (TextView) findViewById(R.id.tvSeason);
		tvSunrise = (TextView) findViewById(R.id.tvSunrise);
		tvSunset = (TextView) findViewById(R.id.tvSunset);
		ivTwitter = (ImageView) findViewById(R.id.ivTwitter);
		pbTwitter = (ProgressBar) findViewById(R.id.pbTwitter);

		new parseXMLTask().execute((Void) null);

		if (savedInstanceState == null) {
			FragmentTransaction transaction = getSupportFragmentManager()
					.beginTransaction();
			TwitterFragment newFragment = new TwitterFragment();

			transaction.add(R.id.fragment_twitter_container, newFragment,
					"Twitter Fragment");
			transaction.commit();
		}

		if (!isAuthorized() && DeviceConnection.isConnected(MainActivity.this)) {
			Toast.makeText(MainActivity.this, "not authorize yet",
					Toast.LENGTH_SHORT).show();
			ivTwitter.setVisibility(View.VISIBLE);
		} else if (DeviceConnection.isConnected(MainActivity.this)) {
			ivTwitter.setVisibility(View.GONE);
			new TimelineTask().execute((Void) null);
		} else
			ivTwitter.setVisibility(View.GONE);
	}

	@Override
	public boolean onCreateOptionsMenu(Menu menu) {
		getMenuInflater().inflate(R.menu.main, menu);
		return true;
	}

	public void startTwitterActivity(View view) {
		Intent intent = new Intent(MainActivity.this, TwitterActivity.class);
		startActivity(intent);
	}

	public boolean isAuthorized() {
		SharedPreferences pref = getSharedPreferences(Const.PREF_NAME,
				MODE_PRIVATE);
		String accessToken = pref.getString(Const.PREF_KEY_ACCESS_TOKEN, null);
		String accessTokenSecret = pref.getString(
				Const.PREF_KEY_ACCESS_TOKEN_SECRET, null);
		if (accessToken == null || accessTokenSecret == null)
			return false;
		return true;
	}

	public class parseXMLTask extends AsyncTask<Void, Void, Void> {

		int error = 0;

		@Override
		protected Void doInBackground(Void... params) {
			try {
				wr = WeatherReport.parseXML(MainActivity.this);
			} catch (ParserConfigurationException e) {
				e.printStackTrace();
				error = 1;
			} catch (SAXException e) {
				e.printStackTrace();
				error = 1;
			} catch (IOException e) {
				e.printStackTrace();
				error = 1;
			}
			return null;
		}

		@Override
		protected void onPostExecute(Void result) {
			super.onPostExecute(result);

			if (error == 0) {

				tvDate.setText(wr.dto.getTerrestrialDate());
				tvSunrise.setText(wr.dto.getMagnitudes().dto.getSunrise());
				tvSunset.setText(wr.dto.getMagnitudes().dto.getSunset());

				MagnitudesDTO mdto = wr.dto.getMagnitudes().dto;
				tvTemperature.setText(mdto.getMin_temp() + " C - "
						+ mdto.getMax_temp() + " C");
				tvPressure.setText(mdto.getPressure() + " Pa");
				tvHumidity.setText(mdto.getAbs_humidity());
				tvWindSpeed.setText(mdto.getWind_speed() + " m/s "
						+ mdto.getWind_direction());
				tvSeason.setText(mdto.getSeason());
			}
		}

	}

	public class AuthRequestTokenTask extends AsyncTask<Void, Void, Void> {

		@Override
		protected void onPreExecute() {
			super.onPreExecute();
			ivTwitter.setEnabled(false);
		}

		@Override
		protected Void doInBackground(Void... params) {
			ConfigurationBuilder confbuilder = new ConfigurationBuilder();
			Configuration conf = confbuilder
					.setOAuthConsumerKey(Const.CONSUMER_KEY)
					.setOAuthConsumerSecret(Const.CONSUMER_SECRET).build();
			mTwitter = new TwitterFactory(conf).getInstance();
			mTwitter.setOAuthAccessToken(null);
			try {
				mRequestToken = mTwitter
						.getOAuthRequestToken(Const.CALLBACK_URL);

			} catch (TwitterException e) {
				e.printStackTrace();
			}
			return null;

		}

		@Override
		protected void onPostExecute(Void result) {
			super.onPostExecute(result);
			Intent intent = new Intent(MainActivity.this,
					TwitterLoginActivity.class);
			intent.putExtra(Const.IEXTRA_AUTH_URL,
					mRequestToken.getAuthorizationURL());
			startActivityForResult(intent, 0);
		}
	}

	@Override
	protected void onActivityResult(int requestCode, int resultCode, Intent data) {
		// TODO Auto-generated method stub
		super.onActivityResult(requestCode, resultCode, data);

		if (requestCode == 0) {
			if (resultCode == RESULT_OK) {
				new AuthAccessTokenTask().execute(data);

			} else if (resultCode == RESULT_CANCELED) {
				Toast.makeText(MainActivity.this, "Cancelled",
						Toast.LENGTH_SHORT).show();
				ivTwitter.setEnabled(true);
			}
		}
	}

	public class AuthAccessTokenTask extends AsyncTask<Intent, Void, Void> {

		@Override
		protected Void doInBackground(Intent... params) {
			AccessToken accessToken = null;
			try {
				String oauthVerifier = params[0].getExtras().getString(
						Const.IEXTRA_OAUTH_VERIFIER);
				accessToken = mTwitter.getOAuthAccessToken(mRequestToken,
						oauthVerifier);
				SharedPreferences pref = getSharedPreferences(Const.PREF_NAME,
						MODE_PRIVATE);
				SharedPreferences.Editor editor = pref.edit();
				editor.putString(Const.PREF_KEY_ACCESS_TOKEN,
						accessToken.getToken());
				editor.putString(Const.PREF_KEY_ACCESS_TOKEN_SECRET,
						accessToken.getTokenSecret());
				editor.commit();

			} catch (TwitterException e) {
				e.printStackTrace();
			}
			return null;
		}

		@Override
		protected void onPostExecute(Void result) {
			super.onPostExecute(result);
			Toast.makeText(MainActivity.this, "Authorized", Toast.LENGTH_SHORT)
					.show();
			ivTwitter.setVisibility(View.GONE);
			new TimelineTask().execute((Void) null);
		}

	}

	public class TimelineTask extends AsyncTask<Void, Void, Void> {

		@Override
		protected void onPreExecute() {
			super.onPreExecute();

			pbTwitter.setVisibility(View.VISIBLE);
			isTimelineTaskRunning = true;

		}

		@Override
		protected Void doInBackground(Void... params) {
			if (mTwitter == null) {
				ConfigurationBuilder confbuilder = new ConfigurationBuilder();
				Configuration conf = confbuilder
						.setOAuthConsumerKey(Const.CONSUMER_KEY)
						.setOAuthConsumerSecret(Const.CONSUMER_SECRET).build();
				mTwitter = new TwitterFactory(conf).getInstance();
			}
			SharedPreferences pref = getSharedPreferences(Const.PREF_NAME,
					MODE_PRIVATE);
			String accessToken = pref.getString(Const.PREF_KEY_ACCESS_TOKEN,
					null);
			String accessTokenSecret = pref.getString(
					Const.PREF_KEY_ACCESS_TOKEN_SECRET, null);

			mTwitter.setOAuthAccessToken(new AccessToken(accessToken,
					accessTokenSecret));

			try {
				statuses = mTwitter.getUserTimeline(user);
			} catch (TwitterException e) {
				e.printStackTrace();
			}

			System.out.println("Showing @" + user + "'s user timeline.");
			return null;
		}

		@Override
		protected void onPostExecute(Void result) {
			super.onPostExecute(result);

			TwitterFragment fragment = (TwitterFragment) getSupportFragmentManager()
					.findFragmentByTag("Twitter Fragment");
			fragment.setTweets(statuses);
			isTimelineTaskRunning = false;
			pbTwitter.setVisibility(View.INVISIBLE);
			if (!isRefreshTaskRunning && pbLoading != null)
				pbLoading.dismiss();
		}
	}

	public class RefreshTask extends AsyncTask<Void, Void, Void> {

		@Override
		protected void onPreExecute() {
			super.onPreExecute();

			isRefreshTaskRunning = true;
		}

		@Override
		protected Void doInBackground(Void... params) {

			try {
				WeatherReport.download(MainActivity.this);
			} catch (IOException e) {
				e.printStackTrace();
			}

			return null;
		}

		@Override
		protected void onPostExecute(Void result) {
			super.onPostExecute(result);
			isRefreshTaskRunning = false;
			new parseXMLTask().execute((Void) null);
			if (!isTimelineTaskRunning)
				pbLoading.dismiss();
		}

	}

	public void signIn(View view) {
		new AuthRequestTokenTask().execute((Void) null);
	}

	public void refresh(View view) {

		if (DeviceConnection.isConnected(MainActivity.this)) {

			pbLoading = new ProgressDialog(MainActivity.this);
			pbLoading.setCancelable(false);
			pbLoading.setMessage("Downloading new data");
			pbLoading.show();

			new RefreshTask().execute((Void) null);

			if (!isTimelineTaskRunning && isAuthorized())
				new TimelineTask().execute((Void) null);
		} else
			Toast.makeText(MainActivity.this, "No Internet", Toast.LENGTH_SHORT)
					.show();
	}

	public void showTrivia(View view) {

		// query
		String result = null;

		TriviaAdapter adapter = new TriviaAdapter(this);
		adapter.open();
		adapter.createTrivia();

		// get a random trivia from all
		// result = adapter.TriviaResult();

		// get a random trivia based on group_name
		String[] categories = { "Temperature", "Pressure", "Wind Speed",
				"General" };
		Random r = new Random();
		String category = categories[r.nextInt(categories.length)];

		Log.v("Category", "cat: " + category);
		category = "General";

		if (category == "Temperature") {
			String minTemp = wr.dto.getMagnitudes().dto.getMin_temp();
			String maxTemp = wr.dto.getMagnitudes().dto.getMax_temp();

			result = adapter.TriviaResult(category, minTemp, maxTemp, null);
		} else if (category == "Pressure") {
			String value = wr.dto.getMagnitudes().dto.getPressure();

			result = adapter.TriviaResult(category, null, null, value);
		} else if (category == "Wind Speed") {
			String value = wr.dto.getMagnitudes().dto.getWind_speed();

			result = adapter.TriviaResult(category, null, null, value);
		} else {

			result = adapter.TriviaResult(category, null, null, null);
		}

		// toast
		LayoutInflater inflater = getLayoutInflater();
		View layout = inflater.inflate(R.layout.toast_layout,
				(ViewGroup) findViewById(R.id.toast_layout_root));

		TextView tv = (TextView) layout.findViewById(R.id.tvTriviaDesc);
		tv.setText(result);

		Toast toast = new Toast(MainActivity.this);
		toast.setGravity(Gravity.BOTTOM, 0, 0);
		toast.setDuration(6000);
		toast.setView(layout);
		toast.show();

	}
}
