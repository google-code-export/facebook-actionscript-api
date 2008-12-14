package com.pbking.facebook.session
{
	public interface IFacebookSession
	{
		
		public function get api_key():String; 

		public function get secret():String; 
	
		public function get session_key():String; 
		
		public function get expires():Number; 
	
		public function get uid():String; 
	}
}