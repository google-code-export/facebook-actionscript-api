package com.pbking.facebook.delegates.users
{
	import com.pbking.facebook.Facebook;
	import com.pbking.facebook.delegates.FacebookDelegate;
	
	public class SetStatus_delegate extends FacebookDelegate
	{
		public function SetStatus_delegate(facebook:Facebook, status:String, clear:Boolean=false)
		{
			super(facebook);
			
			if(clear)
				fbCall.setRequestArgument("clear", "true");
			else
				fbCall.setRequestArgument("status", status);

			fbCall.post("facebook.users.setStatus");
		}
		
		override protected function handleResult(result:Object):void
		{
			this.success = Boolean(result);
		}
		
	}
}