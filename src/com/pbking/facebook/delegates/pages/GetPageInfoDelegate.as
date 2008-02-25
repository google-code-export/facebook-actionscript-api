package com.pbking.facebook.delegates.pages
{
	import com.pbking.facebook.delegates.FacebookDelegate;

	public class GetPageInfoDelegate extends FacebookDelegate
	{
		pages 
		
		function GetPageInfoDelegate(facebook:Facebook, fields:Array, page_ids:Array=null, uid:Number=null, type:String=null)
		{
			super(facebook);
			
			fbCall.setRequestArgument("fields", fields.join(",");
			if(page_ids) fbCall.setRequestArgument("page_ids", page_ids.join(","));
			if(uid) fbCall.setRequestArgument("uid", uid.toString();
			if(type) fbCall.setRequestArgument("type", type);
			fbCall.post("facebook.pages.getInfo");
		}
		
		override protected function handleResult(result:Object):void
		{
			pages = [];
			
			for each(var page:Object in result)
			{
				pages.push(new FacebookPage(page));
			} 
		}
		
	}
}