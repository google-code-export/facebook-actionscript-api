package com.pbking.facebook.session
{
	import flash.external.ExternalInterface;
	
	public class JSBridgeSession implements IFacebookSession
	{
		public var as_app_name:String;
		
		private var externalInterfaceCallId:uint = 0;
		private var externalInterfaceCallbacks:Object = {};
		
		public function JSBridgeSession(as_app_name:String)
		{
			this.as_app_name = as_app_name;

			ExternalInterface.addCallback("bridgeFacebookReply", postBridgeAsyncReply);
		}

		// INTERFACE IMPLEMENTATION //////////

		// These are all quickies.  We're just reaching into the JS API and are sync calls

		public function get api_key():String 
		{
			var call:String = "function(){return FB.Facebook.apiClient.get_apiKey();}";	
			return ExternalInterface.call(call);
        }

		public function get session_key():String 
		{
			var call:String = "function(){return FB.Facebook.apiClient.get_session().session_key;}";	
			return ExternalInterface.call(call);
        }		
		
		public function get expires():Number 
		{
			var call:String = "function(){return FB.Facebook.apiClient.get_session().expires;}";	
			return ExternalInterface.call(call);
        }		
	
		public function get secret():String 
		{
			var call:String = "function(){return FB.Facebook.apiClient.get_session().secret;}";	
			return ExternalInterface.call(call);
        }		
	
		public function get uid():String 
		{
			var call:String = "function(){return FB.Facebook.apiClient.get_session().uid;}";	
			return ExternalInterface.call(call);
        }

		public function callMethod(method:String, args:Object, callback:Function=null):void
		{
			postBridgeAsync(method, args, callback);
		}
		
		// UTILITIES //////////

		public function get sig():String 
		{
			var call:String = "function(){return FB.Facebook.apiClient.get_session().sig;}";	
			return ExternalInterface.call(call);
        }
		
		protected function postBridgeAsync(method:String, args:Object, instanceCallback:Function=null):void
		{
			externalInterfaceCallId++;
			
			externalInterfaceCallbacks[externalInterfaceCallId] = instanceCallback;
			
			var bridgeCallFunctionName:String = "bridgeFacebookCall_"+externalInterfaceCallId;

			var bridgeCall:String = 
				"function "+bridgeCallFunctionName+"(method, args){"+
					"FB.Facebook.apiClient._callMethod(method, args, " + 
							"function(result, exception){" + 
								"document."+as_app_name+".bridgeFacebookReply(result, exception, "+externalInterfaceCallId+");" + 
							"});" + 
				"}";

			ExternalInterface.call(bridgeCall, method, args);
		}
		
		protected static function postBridgeAsyncReply(result:Object, exception:Object, exCallId:uint):void
		{
			externalInterfaceCallbacks[exCallId](result, exception);
			delete externalInterfaceCallbacks[exCallId];
		}
		

	}
}