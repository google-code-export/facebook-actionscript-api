/*
	Copyright (c) 2010, Adobe Systems Incorporated
	All rights reserved.
	
	Redistribution and use in source and binary forms, with or without
	modification, are permitted provided that the following conditions are
	met:
	
	* Redistributions of source code must retain the above copyright notice,
	this list of conditions and the following disclaimer.
	
	* Redistributions in binary form must reproduce the above copyright
	notice, this list of conditions and the following disclaimer in the
	documentation and/or other materials provided with the distribution.
	
	* Neither the name of Adobe Systems Incorporated nor the names of its
	contributors may be used to endorse or promote products derived from
	this software without specific prior written permission.
	
	THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS
	IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO,
	THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
	PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR
	CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
	EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
	PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
	PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
	LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
	NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
	SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/

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