package {
	import com.pbking.facebook.Facebook;
	import com.pbking.facebook.commands.friends.GetFriends;
	import com.pbking.facebook.events.FacebookActionEvent;
	import com.pbking.facebook.util.FacebookFlashSessionUtil;
	import com.pbking.util.logging.PBLogEvent;
	import com.pbking.util.logging.PBLogger;
	
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;

	public class Facebook_Flash_Example extends Sprite
	{
		// VARIABLES //////////
		
		public var fBook:Facebook;
		private var logger:PBLogger;
		
		public var logBox:TextField;
		public var loginButton:SimpleButton;
		
		// CONSTRUCTION //////////
		
		public function Facebook_Flash_Example()
		{
			//instantiate our Flash Friendly logger and listen for facebook logs
			logger = PBLogger.getLogger("pbking.facebook");
			logger.addEventListener(PBLogEvent.LOG, onLog);

			//create the session util.  this will handle getting us connected to facebook using the best route possible.
			var fbu:FacebookFlashSessionUtil = new FacebookFlashSessionUtil();
			
			fBook = fbu.facebook;
			fBook.addEventListener(FacebookActionEvent.CONNECT, onConnect);
			
			//in flash we need to handle the login prompt out here.
			//in the flex example it's handled in the SessionUtil with an Alert window.
			//No such Alert Window love so do something else.
			//I'm sure you can get creative.
			fBook.addEventListener(FacebookActionEvent.WAITING_FOR_LOGIN, onWaitingForLogin);
			
			//in the flex example we don't have to pass the loaderInfo object
			//but in flash we're not able to get at the flashVars globally
			//so we gotta do that here.
			//note also that you CAN pass other stuff (not recommended) such as an API key, secret or the file
			//that those things will be pulled from.
			fbu.connect(loaderInfo);
		}
		
		private function onLog(e:PBLogEvent):void
		{
			logBox.appendText(e.message + "\n");
		}
		
		private function onWaitingForLogin(e:FacebookActionEvent):void
		{
			loginButton.visible = true;
			loginButton.addEventListener(MouseEvent.CLICK, onLoginButtonClick);
		}
		
		private function onLoginButtonClick(e:MouseEvent):void
		{
			loginButton.visible = false;
			fBook.validateDesktopSession();
		}
		
		private function onConnect(event:FacebookActionEvent):void
		{
			logger.info("Facebook connected");
			fBook.post(new GetFriends(), onGotFriends);
		}
		
		private function onGotFriends(call:GetFriends):void
		{
			logger.info("My friends: " + call.friends);
		}
	}
}
