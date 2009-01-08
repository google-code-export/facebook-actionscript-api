package com.pbking.facebook.commands.friends
{
	import com.pbking.facebook.FacebookCall;
	import com.pbking.facebook.data.users.FacebookUser;
	
	public class GetFriends extends FacebookCall
	{
		public var friends:Array;
		
		public function GetFriends()
		{
			super("facebook.friends.get");
		}
		
		override protected function handleSuccess(result:Object):void
		{
			friends = [];
			
			for each(var uid:int in result)
			{
				friends.push(FacebookUser.getUser(uid));
			} 
		}
		
	}
}