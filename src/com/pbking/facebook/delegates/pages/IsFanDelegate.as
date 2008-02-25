package com.pbking.facebook.delegates.pages
{
	import com.pbking.facebook.delegates.FacebookDelegate;

	public class IsFanDelegate extends FacebookDelegate
	{
		function IsFanDelegate(facebook:Facebook, page_id:Number, uid:Number=null)
		{
			super(facebook);
			
			fbCall.setRequestArgument("page_id", page_id);
			if(uid)
				fbCall.setRequestArgument("uid", uid);
			fbCall.post("facebook.pages.isAdmin");
		}
	}
}