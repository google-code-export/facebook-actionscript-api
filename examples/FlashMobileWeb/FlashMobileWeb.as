package {
	import com.adobe.serialization.json.JSON;
	import com.facebook.graph.Facebook;
	
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.net.URLRequest;
	
	public class FlashMobileWeb extends Sprite {
		
		protected static const APP_ID:String = "YOUR_APP_ID"; //Your App Id
		
		protected var profilePic:Loader;
		
		public function FlashMobileWeb() {			
			var accessToken:String;
			if (loaderInfo.parameters.accessToken != undefined) {				
				accessToken = String(loaderInfo.parameters.accessToken); //get the token passed in index.php
			}
			
			Facebook.init(APP_ID, onInit, null, accessToken);
			
			loginBtn.addEventListener(MouseEvent.CLICK, handleLoginClick, false, 0, true);
			callBtn.addEventListener(MouseEvent.CLICK, handleCallClick, false, 0, true);
			
			profilePic = new Loader();
			profilePic.contentLoaderInfo.addEventListener(Event.INIT, handleProfilePicInit, false, 0, true);
			profilePic.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, handleProfilePicIOError, false, 0, true);
			profileHolder.addChild(profilePic);
		}
		
		protected function onInit(response:Object, fail:Object):void {
			if (response) {
				outputTxt.appendText("Logged In\n");	
				loginBtn.label = "Logout";
			} else {
				outputTxt.appendText("Click to Login\n");
				loginBtn.label = "Login";
			}
		}
		
		protected function handleLoginClick(event:MouseEvent):void {			
			if (loginBtn.label == "Login") {
				var redirectUri:String = "http://your.app.url/"; //Your App URL as specified in facebook.com/developers app settings
				var permissions:Array = ["user_photos", "user_location"];
				Facebook.mobileLogin(redirectUri, "touch", permissions);
			} else {
				outputTxt.appendText("LOGOUT\n");				
				Facebook.mobileLogout("http://your.app.url/"); //Redirect user back to your app url
			}
		}
		
		protected function onLogout(response:Object):void {
			loginBtn.label = "Login";
			outputTxt.text = "";
		}
		
		protected function handleCallClick(event:MouseEvent):void {			
			Facebook.api("/me", onApiCall);
		}
		
		protected function onApiCall(response:Object, fail:Object):void {
			if (response) {								
				outputTxt.appendText("RESPONSE:\n" + JSON.encode(response) + "\n");	
				
				//profile pic
				var req:URLRequest = new URLRequest(Facebook.getImageUrl(response.id, "square"));				
				profilePic.load(req);
				
				//name and location
				profileHolder.nameTxt.text = response.name + "\n";
				if (response.location != null) { profileHolder.nameTxt.appendText(response.location.name); }
				
			} else {
				outputTxt.appendText("FAIL:\n" + JSON.encode(fail) + "n");
			}
		}	
		
		protected function handleProfilePicInit(event:Event):void {
			profilePic.x = 1;
			profilePic.y = profileHolder.height - profilePic.height >> 1;
		}
		
		protected function handleProfilePicIOError(event:IOErrorEvent):void {
			outputTxt.appendText("Error Loading Profile Pic\n");
		}
	}
}