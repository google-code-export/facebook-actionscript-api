package com.pbking.facebook.delegates.marketplace
{
	import com.pbking.facebook.Facebook;
	import com.pbking.facebook.delegates.FacebookDelegate;

	public class GetSubCategories_delegate extends FacebookDelegate
	{
		public var subcategories:Array;
		
		function GetSubCategories_delegate(category:String)
		{
			fbCall.setRequestArgument("category", category);
			fbCall.post("marketplace.getSubCategories");
		}
		
		override protected function handleResult(result:Object):void
		{
			subcategories = [];
			for each(var subCatName:String in result)
			{
				subcategories.push( subCatName );
			}
		}
	}
}