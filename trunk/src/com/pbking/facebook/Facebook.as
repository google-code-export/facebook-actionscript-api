/*
Copyright (c) 2007 Jason Crist

Permission is hereby granted, free of charge, to any person
obtaining a copy of this software and associated documentation
files (the "Software"), to deal in the Software without
restriction, including without limitation the rights to use,
copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the
Software is furnished to do so, subject to the following
conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
OTHER DEALINGS IN THE SOFTWARE.
*/

/**
 * Facebook API top level class. 
 * 
 * Provides internal configuration, connection management, and abstract method exposure.
 * 
 * @see http://developers.facebook.com/documentation.php?v=1.0
 * @author Jason Crist 
 */

package com.pbking.facebook
{
	import com.pbking.facebook.data.users.FacebookUser;
	import com.pbking.facebook.delegates.auth.*;
	import com.pbking.facebook.events.FacebookActionEvent;
	import com.pbking.facebook.methodGroups.*;
	import com.pbking.facebook.session.IFacebookSession;
	import com.pbking.util.logging.PBLogger;
	
	import flash.events.EventDispatcher;
	
	[Event(name="complete", type="com.pbking.facebook.events.FacebookActionEvent")]
	[Event(name="waiting_for_login", type="com.pbking.facebook.events.FacebookActionEvent")]

	[Bindable]
	public class Facebook extends EventDispatcher implements IFacebookSession
	{	
		// VARIABLES //////////
		
		public var logger:PBLogger = PBLogger.getLogger("pbking.facebook");
		public var isConnected:Boolean = false;
		public var connectionErrorMessage:String;

		protected static var _facebook_namespace:Namespace;
		public static var api_version:String = "1.0";
		
		// CONSTRUCTION //////////
		
		function Facebook():void
		{
			//nothing here
		}
		
		// GETTERS and SETTERS //////////
		
		/**
		 * Facebook namespace to use when pulling out XML data responses
		 */
		public static function get FACEBOOK_NAMESPACE():Namespace
		{
			if(_facebook_namespace == null)
			{
				_facebook_namespace = new Namespace("http://api.facebook.com/1.0/");
			}
			return _facebook_namespace;
		}
		
		// UTILS //////////
		
		/**
		 * Helper function.  Called when the connection is ready.
		 */
		protected function onReady():void
		{
			isConnected = true;
			
			dispatchEvent(new FacebookActionEvent(FacebookActionEvent.COMPLETE));
		}
		
		/**
		 * Helper function.  Called when the connection fails to be made.
		 */
		protected function onConnectionError(errorMessage:String):void
		{
			isConnected = false;
			
			connectionErrorMessage = errorMessage;
			
			logger.fatal(errorMessage);
			
			dispatchEvent(new FacebookActionEvent(FacebookActionEvent.COMPLETE));
		}
		
	}
}