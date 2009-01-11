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
 * Makes the call to the Facebook REST service  
 * 
 * @author Jason Crist 
 */
package com.pbking.facebook
{
	import com.pbking.facebook.delegates.IFacebookCallDelegate;
	import com.pbking.facebook.session.IFacebookSession;
	import com.pbking.util.logging.PBLogger;
	
	import flash.events.EventDispatcher;
	import flash.net.URLVariables;
	
	[Event(name="complete", type="flash.events.Event")]
	
	[Bindable]
	public class FacebookCall extends EventDispatcher
	{
		// VARIABLES //////////
		
		protected static var callID:uint = 0;
		
		protected var logger:PBLogger = PBLogger.getLogger("pbking.facebook");
		
		public var args:URLVariables;
		public var method:String;
		
		public var result:Object;
		public var exception:Object;

		public var success:Boolean = false;
		public var errorCode:int = 0;
		public var errorMessage:String = "";

		public var facebook:Facebook;
		
		public var callbacks:Array = [];
		
		// CONSTRUCTION //////////
		
		function FacebookCall(method:String="no_method_required", args:URLVariables=null)
		{
			this.method = method;
			this.args = args ? args : new URLVariables();
		}
		
		// PUBLIC METHODS //////////
		
		/**
		 * Set a name value pair to be sent in request postdata.  
		 * You could of course set these directly on the args variable 
		 * but this method proves handy too.
		 */
		public function setRequestArgument( name:String, value:* ):void
		{
			this.args[name] = value;	
		}
		
		public function clearRequestArguments():void
		{
			this.args = new URLVariables();
		}
		
		public function initialize():void
		{
			//override in case something needs to be initialized prior to execution
		}
		
		public function execute(facebook:Facebook=null):IFacebookCallDelegate
		{
			if(facebook)
				return facebook.post(this);
				
			else if(this.facebook)
				return this.facebook.post(this);

			return null;
		}
		
		public function handleResult(result:Object, exception:Object):void
		{
			this.result = result;
			this.exception = exception;
			
			//look for an error
			if(result && result.hasOwnProperty('error_code'))
			{
				//dang.  handle the error
				this.errorCode = result.error_code;
				this.errorMessage = result.error_msg;
				this.success = false;

				logger.debug('error making call: ' + errorCode +"|"+errorMessage);
			}
			else
			{
				this.success = true;
				handleSuccess(result);
			}

			dispatchEvent(new Event(Event.COMPLETE));
			
			for each(var f:Function in callbacks)
				f(this);
		}
		
		protected function handleSuccess(result:Object):void
		{
			//override this
		}

		public function addCallback(callback:Function):void
		{
			for each(var f:Function in callbacks)
				if(f == callback) 
					return;

			callbacks.push(callback);
		}
		
	}
}