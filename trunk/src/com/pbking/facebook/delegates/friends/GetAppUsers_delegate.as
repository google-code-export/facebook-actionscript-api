package com.pbking.facebook.delegates.friends
{
	import com.pbking.facebook.FacebookCall;
	import com.pbking.facebook.delegates.FacebookDelegate;
	import com.pbking.util.logging.PBLogger;
	
	import flash.events.Event;
	
	public class GetAppUsers_delegate extends FacebookDelegate
	{
		public var users:Array;
		
		public function GetAppUsers_delegate()
		{
			PBLogger.getLogger("pbking.facebook").debug("getting appUsers");
			
			var fbCall:FacebookCall = new FacebookCall(fBook);
			fbCall.addEventListener(Event.COMPLETE, onCallComplete);
			fbCall.post("facebook.friends.getAppUsers");
		}
		
		override protected function handleResult(result:Object):void
		{
			users = [];
			
			for each(var uid:int in result)
			{
				users.push(fBook.getUser(uid));
			} 
		}
		
	}
}