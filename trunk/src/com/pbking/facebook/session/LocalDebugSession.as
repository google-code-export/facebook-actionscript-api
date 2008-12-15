package com.pbking.facebook.session
{
	import com.pbking.facebook.delegates.auth.CreateTokenDelegate;
	
	public class LocalDebugSession implements IFacebookSession
	{
		protected var _auth_token:String;
		protected var _api_key:String; 
		protected var non_inf_session_secret:String;
		protected var _secret:String = '';
		
		/**
		 * The URL of the REST server that you will be using.
		 * Change this if you are using a redirect server. (not recommended)
		 */
		public var rest_url:String = "http://api.facebook.com/restserver.php";

		/**
		 * This ACTUAL FACEBOOK rest URL.  This cannot be changed.
		 */
		public var default_rest_url:String = "http://api.facebook.com/restserver.php";

		/**
		 * The URL of the login page a user will be directed to (for desktop applications)
		 * The default will work fine but you can set it to something else.
		 */
		public var login_url:String = "http://www.facebook.com/login.php";

		// CONSTRUCTION //////////
		
		public function LocalDebugSession(api_key:String, secret:String, infinite_session_key:String=null, infinite_session_secret:String=null)
		{
			this._api_key = api_key;
			
			if(infinite_session_key)
			{
				this.non_inf_session_secret = secret;
				this._secret = infinite_session_secret;
				this._session_key = infinite_session_key;

				//make a call to verify our session (and grab our user while we're at it)
				this.users.getLoggedInUser(verifyInfinateSession);
			}
			else
			{
				this._secret = secret;

				//construct a token and get ready for the user to enter user/pass
				var delegate:CreateTokenDelegate = new CreateTokenDelegate(this);
				delegate.addEventListener(Event.COMPLETE, onDesktopTokenCreated);
			}
		}

		// INTERFACE REQUIREMENTS //////////

		public function get api_key():String { return _api_key;	}
		
		public function get secret():String { return _secret; }

		public function get session_key():String 
		{
			//TODO
			return null;
		}

		public function get expires():Number 
		{
			//TODO
			return 0;
		}
		
		public function get uid():String 
		{
			//TODO
			return null;
		}

		public function callMethod(method:String, args:Object, callback:Function=null):void
		{
		}
		
		// UTILITIES //////////

		protected function verifyInfinateSession(event:Event):void
		{
			var d:GetLoggedInUserDelegate = event.target as GetLoggedInUserDelegate;
			if(d.success)
			{
				this._user = d.user;
				this._user.isLoggedInUser = true;
				onReady();
			}
			else
			{
				//infinate session didn't work out.  just start over without it
				this.session_key = null;
				this._secret = this.non_inf_session_secret;
				startDesktopSession(this._api_key, this._secret);
			}
		}
		
		protected function onDesktopTokenCreated(event:Event):void
		{
			var delegate:CreateTokenDelegate = event.target as CreateTokenDelegate;
			if(delegate.success)
			{
				_auth_token = delegate.auth_token;
				
				//now that we have an auth_token we need the user to login with it
				var authenticateLoginURL:String = login_url + "?api_key="+api_key+"&v=1.0&auth_token="+_auth_token;
				navigateToURL(new URLRequest(authenticateLoginURL), "_blank");
				
				this.dispatchEvent(new FacebookActionEvent(FacebookActionEvent.WAITING_FOR_LOGIN));
			}
			else
			{
				onConnectionError(delegate.errorMessage);
			}
		}
		
		/**
		 * Once a token has been created and a user has logged in we must manually validate this session
		 * with a call to this method.  Once this has been sucessfully called, the Facebook session is ready
		 */
		public function validateDesktopSession():void
		{
			//validate the session
			var delegate:GetSessionDelegate = new GetSessionDelegate(this, _auth_token);
			delegate.addEventListener(Event.COMPLETE, validateDesktopSessionReply);
		}
		
		protected function validateDesktopSessionReply(event:Event):void
		{
			var delegate:GetSessionDelegate = event.target as GetSessionDelegate;
			if(delegate.success)
			{
				this._user = FacebookUser.getUser(delegate.uid);
				this._user.isLoggedInUser = true;

				this._session_key = delegate.session_key;
				this._expires = delegate.expires;
				this._secret = delegate.secret;
			
				onReady();
			}
			else
			{
				onConnectionError(delegate.errorMessage);
			}
		}

	}
}