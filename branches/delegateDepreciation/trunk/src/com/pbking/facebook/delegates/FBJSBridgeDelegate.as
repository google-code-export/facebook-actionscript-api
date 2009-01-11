package com.pbking.facebook.delegates
{
	import com.pbking.facebook.FacebookCall;
	import com.pbking.facebook.session.IFacebookSession;
	import com.pbking.facebook.session.FBJSBridgeSession;
	import flash.net.LocalConnection;

	public class FBJSBridgeDelegate implements IFacebookCallDelegate
	{
		private var _call:FacebookCall;
		private var _session:FBJSBridgeSession;

		protected static var connection:LocalConnection = new LocalConnection();

		public function FBJSBridgeDelegate(call:FacebookCall, session:FBJSBridgeSession)
		{
			this.call = call;
			this.session = session;
			
			execute();
		}

		public function get call():FacebookCall { return _call;	}
		public function set call(newVal:FacebookCall):void { this._call = newVal; }
		
		public function get session():IFacebookSession { return _session; }
		public function set session(newVal:IFacebookSession):void { this._session = newVal; }
		
		protected function execute():void
		{
			connection.send(_session.bridgeSwfName, "callFBJS", call.method, call.args);
		}
	}
}