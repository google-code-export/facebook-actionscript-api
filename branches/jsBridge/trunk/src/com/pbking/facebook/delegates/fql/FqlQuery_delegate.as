package com.pbking.facebook.delegates.fql
{
	import com.pbking.facebook.Facebook;
	import com.pbking.facebook.delegates.FacebookDelegate;

	public class FqlQuery_delegate extends FacebookDelegate
	{
		public function FqlQuery_delegate(query:String)
		{
			fbCall.setRequestArgument("query", query);
			fbCall.post("facebook.fql.query");
		}
		
	}
}