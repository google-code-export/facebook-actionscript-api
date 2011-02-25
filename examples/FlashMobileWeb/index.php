<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
	<head>
	 	<!-- Include support librarys first -->
		<script type="text/javascript" src="http://ajax.googleapis.com/ajax/libs/swfobject/2.2/swfobject.js"></script>
		<script type="text/javascript" src="http://connect.facebook.net/en_US/all.js"></script>		
	</head>
	<body>		
		<script type="text/javascript">
			var flashVars = {};
			<? //We use php to get the token because the token exchange requires the app secret																			
				$code = $_GET["code"]; //Facebook returns code, exchange this for an access token								
				
				if (isset($code)) {
					$appId = "YOUR_APP_ID"; //Your App Id
					$appSecret = "YOUR_APP_SECRET"; //Your App Secret
					$redirectUri = "http://your.site.url/"; //Your Site URL		
					
					$authUrl = "https://graph.facebook.com/oauth/access_token?client_id=".$appId."&redirect_uri=".$redirectUri."&client_secret=".$appSecret."&code=".$code;				
				
					$ch = curl_init();
					curl_setopt($ch, CURLOPT_URL, $authUrl);
					curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
					$tokenStr = curl_exec($ch); //access token & expiry string							
					$a = explode("&", $tokenStr); 
					$accessToken = substr($a[0], strpos($a[0], "=")+1);
					$expiry = substr($a[1], strpos($a[1], "=")+1);
					echo("flashVars = {accessToken:\"".$accessToken."\", expiry:\"".$expiry."\"};");
					curl_close($ch);					    
				} 																	
			?>
			
			//A 'name' attribute with the same value as the 'id' is REQUIRED for Chrome/Mozilla browsers
			swfobject.embedSWF("FlashMobileWeb.swf", "flashContent", "300", "400", "9.0", null, flashVars, null, {name:"flashContent"});
		</script>		
		<div id="fb-root"></div><!-- required div tag -->
		<div id="flashContent">
			<h1>You need at least Flash Player 9.0 to view this page.</h1>
			<p><a href="http://www.adobe.com/go/getflashplayer"><img src="http://www.adobe.com/images/shared/download_buttons/get_flash_player.gif" alt="Get Adobe Flash player" /></a></p>
		</div>		
	</body>
</html>