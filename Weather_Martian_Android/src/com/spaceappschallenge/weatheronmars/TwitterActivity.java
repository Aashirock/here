package com.spaceappschallenge.weatheronmars;

import java.util.List;

import twitter4j.Twitter;
import twitter4j.TwitterException;
import twitter4j.TwitterFactory;
import twitter4j.auth.AccessToken;
import twitter4j.auth.RequestToken;
import twitter4j.conf.Configuration;
import twitter4j.conf.ConfigurationBuilder;
import android.content.Intent;
import android.content.SharedPreferences;
import android.os.AsyncTask;
import android.os.Bundle;
import android.support.v4.app.FragmentActivity;
import android.support.v4.app.FragmentTransaction;
import android.widget.Toast;

import com.spaceappschallenge.weatheronmars.helper.Const;

public class TwitterActivity extends FragmentActivity {

	private Twitter mTwitter;
	private RequestToken mRequestToken;
	List<twitter4j.Status> statuses;
	String user = "MarsWxReport";

	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.activity_twitter);

		if (savedInstanceState == null) {
			FragmentTransaction transaction = getSupportFragmentManager()
					.beginTransaction();
			TwitterFragment newFragment = new TwitterFragment();
			
			transaction.add(R.id.fragment_twitter_container, newFragment, "Twitter Fragment");
			transaction.commit();
		}

		SharedPreferences pref = getSharedPreferences(Const.PREF_NAME,
				MODE_PRIVATE);
		String accessToken = pref.getString(Const.PREF_KEY_ACCESS_TOKEN, null);
		String accessTokenSecret = pref.getString(
				Const.PREF_KEY_ACCESS_TOKEN_SECRET, null);
		if (accessToken == null || accessTokenSecret == null) {
			Toast.makeText(TwitterActivity.this, "not authorize yet",
					Toast.LENGTH_SHORT).show();
			new AuthRequestTokenTask().execute((Void) null);
		} else
			new TimelineTask().execute((Void) null);
	}

	public class AuthRequestTokenTask extends AsyncTask<Void, Void, Void> {

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
			Intent intent = new Intent(TwitterActivity.this,
					TwitterLoginActivity.class);
			intent.putExtra(Const.IEXTRA_AUTH_URL,
					mRequestToken.getAuthorizationURL());
			startActivityForResult(intent, 0);
		}
	}

	@Override
	protected void onActivityResult(int requestCode, int resultCode, Intent data) {
		super.onActivityResult(requestCode, resultCode, data);

		if (requestCode == 0) {
			if (resultCode == RESULT_OK) {
				new AuthAccessTokenTask().execute(data);

			} else if (resultCode == RESULT_CANCELED) {
				Toast.makeText(TwitterActivity.this, "Cancelled",
						Toast.LENGTH_SHORT).show();
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
			Toast.makeText(TwitterActivity.this, "authorized",
					Toast.LENGTH_SHORT).show();
			new TimelineTask().execute((Void) null);
		}

	}

	public class TimelineTask extends AsyncTask<Void, Void, Void> {

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

			Toast.makeText(TwitterActivity.this, "count: " + statuses.size(),
					Toast.LENGTH_SHORT).show();
			
			TwitterFragment fragment = (TwitterFragment) getSupportFragmentManager()
					.findFragmentByTag("Twitter Fragment");
			fragment.setTweets(statuses);
		}
	}
}
