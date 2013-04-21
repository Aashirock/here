package com.spaceappschallenge.weatheronmars.business;

public class Tweet {

	public TweetDTO dto;
	
	public Tweet() {
		dto = new TweetDTO();
	}
	
	public class TweetDTO {
		private String date;
		private String content;

		public String getDate() {
			return date;
		}

		public void setDate(String date) {
			this.date = date;
		}

		public String getContent() {
			return content;
		}

		public void setContent(String content) {
			this.content = content;
		}
	}
}
