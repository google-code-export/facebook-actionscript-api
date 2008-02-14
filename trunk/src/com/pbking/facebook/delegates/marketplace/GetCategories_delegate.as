package com.pbking.facebook.delegates.marketplace
{
	import com.pbking.facebook.Facebook;
	import com.pbking.facebook.delegates.FacebookDelegate;

	public class GetCategories_delegate extends FacebookDelegate
	{
		public var categories:Array;
		
		function GetCategories_delegate(facebook:Facebook)
		{
			super(facebook);
			fbCall.post("marketplace.getCategories");
		}
		
		override protected function handleResult(result:Object):void
		{
			categories = [];
			for each(var catName:String in result)
			{
				categories.push( catName );
			}
		}
	}
}