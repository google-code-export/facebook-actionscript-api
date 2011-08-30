package {
	
	import com.adobe.serialization.json.JSON;
	import com.facebook.graph.FacebookDesktop;
	import com.facebook.graph.data.Batch;
	
	import fl.controls.ComboBox;
	import fl.data.DataProvider;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.net.URLRequestMethod;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	
	[SWF(width="640", height="480", backgroundColor="0xffffff", frameRate="15")]
	public class BatchRequests extends Sprite {
		
		// Static/Constant Properties:
		
		protected static const APP_ID:String = "YOUR_APP_ID"; // Your App ID.
		protected static const APP_ORIGIN:String = "YOUR_APP_ORGIN"; // The site URL of your application (specified in your app settings); needed for clearing cookie when logging out.
		
		public static const PADDING_LARGE:Number = 20;
		public static const PADDING_SMALL:Number = 10;
		
		// Public Properties:
		public var loginBtn:CustomButton;
		public var makeBatchRequestBtn:CustomButton;
		public var getMyInfoToggle:ToggleButton;
		public var getMyInfoBtn:CustomButton;
		public var myInfoText:TextField;
		public var postMessageToggle:ToggleButton;
		public var postMessageBtn:CustomButton;
		public var postMessageInput:TextField;
		public var postMessageCompleteText:TextField;
		public var uploadImagesToggle:ToggleButton;
		public var uploadImagesBtn:CustomButton;
		public var albumPickerText:TextField;
		public var albumPicker:ComboBox;
		public var uploadPhotosCompleteText:TextField;
		
		public var imagesList:Array;
		public var imagesContainer:Sprite;
		
		// Protected Properties:
		
		protected var isLoggedIn:Boolean = false;
		protected var permissions:Array = ["user_photos"];
		
		protected var isMakingRequest:Boolean = false;
		
		protected var getMyInfoEnabled:Boolean = true;
		protected var postMessagesEnabled:Boolean = true;
		protected var uploadImagesEnabled:Boolean = true;
		
		protected var uploadedImages:uint;
		
		// Getter/Setter Properties:
		
		// Initialization:
		public function BatchRequests() {
			configUI();
			updateDisplayList();
			FacebookDesktop.init(APP_ID, handleLogin);
		}
		
		// Protected Methods:
		protected function configUI():void {
			loginBtn = new CustomButton();
			loginBtn.label = "Checking Login...";
			loginBtn.addEventListener(MouseEvent.CLICK, handleLoginBtnClick, false, 0, true);
			loginBtn.enabled = false;
			addChild(loginBtn);
			
			makeBatchRequestBtn = new CustomButton();
			makeBatchRequestBtn.label = "Make Batch Request";
			makeBatchRequestBtn.addEventListener(MouseEvent.CLICK, handleMakeBatchRequestBtnClick, false, 0, true);
			makeBatchRequestBtn.enabled = false;
			addChild(makeBatchRequestBtn);
			
			getMyInfoToggle = new ToggleButton();
			addChild(getMyInfoToggle);
			
			getMyInfoBtn = new CustomButton();
			getMyInfoBtn.label = "Get My Info";
			getMyInfoBtn.addEventListener(MouseEvent.CLICK, handleGetMyInfoBtnClick, false, 0, true);
			getMyInfoBtn.enabled = false;
			addChild(getMyInfoBtn);
			
			myInfoText = new TextField();
			myInfoText.border = true;
			myInfoText.alpha = 0.5;
			myInfoText.multiline = myInfoText.wordWrap = true;
			addChild(myInfoText);
			
			postMessageToggle = new ToggleButton();
			addChild(postMessageToggle);
			
			postMessageBtn = new CustomButton();
			postMessageBtn.label = "Post Message";
			postMessageBtn.addEventListener(MouseEvent.CLICK, handlePostMessageBtnClick, false, 0, true);
			postMessageBtn.enabled = false;
			addChild(postMessageBtn);
			
			postMessageInput = new TextField();
			postMessageInput.defaultTextFormat = new TextFormat("_sans", 12);
			postMessageInput.text = "This is a message to post.";
			postMessageInput.type = TextFieldType.INPUT;
			postMessageInput.border = true;
			postMessageInput.visible = false;
			addChild(postMessageInput);
			
			postMessageCompleteText = new TextField();
			postMessageCompleteText.text = "Posted!";
			postMessageCompleteText.visible = false;
			addChild(postMessageCompleteText);
			
			uploadImagesToggle = new ToggleButton();
			uploadImagesToggle.diameter = 10;
			addChild(uploadImagesToggle);
			
			uploadImagesBtn = new CustomButton();
			uploadImagesBtn.label = "Upload Sample Images";
			uploadImagesBtn.addEventListener(MouseEvent.CLICK, handleUploadImagesBtnClick, false, 0, true);
			uploadImagesBtn.enabled = false;
			addChild(uploadImagesBtn);
			
			albumPickerText = new TextField();
			albumPickerText.autoSize = TextFieldAutoSize.LEFT;
			albumPickerText.text = "Albums:";
			addChild(albumPickerText);
			
			albumPicker = new ComboBox();
			albumPicker.enabled = false;
			addChild(albumPicker);
			
			uploadPhotosCompleteText = new TextField();
			uploadPhotosCompleteText.visible = false;
			addChild(uploadPhotosCompleteText);
			
			getMyInfoEnabled = postMessagesEnabled = uploadImagesEnabled = false;
			
			imagesContainer = new Sprite();
			addChild(imagesContainer);
			
			imagesList = [];
			var size:Number = 150;
			var columns:int = 3;//(stage.stageWidth - PADDING_SMALL - PADDING_SMALL) / (size + PADDING_SMALL);
			for (var i:int, numImages:int = 3; i < numImages; i++) {
				var img:Bitmap = new Bitmap(new BitmapData(size, size, false, Math.random()*0xffffff));
				img.x = (i % columns) * (size + PADDING_SMALL);
				img.y = Math.floor(i / columns) * (size + PADDING_SMALL);
				
				imagesList.push(img);
				imagesContainer.addChild(img);
			}
		}
		
		protected function updateDisplay():void {
			makeBatchRequestBtn.enabled = getMyInfoBtn.enabled = uploadImagesBtn.enabled = postMessageBtn.enabled = isLoggedIn && !isMakingRequest;
			postMessageInput.visible = isLoggedIn && postMessageToggle.selected;
			loginBtn.enabled = !isMakingRequest;
			getMyInfoToggle.selected = getMyInfoEnabled;
			postMessageToggle.selected = postMessageInput.visible = postMessagesEnabled;
			uploadImagesToggle.selected = uploadImagesEnabled;
			albumPicker.enabled = albumPicker.dataProvider.length > 0 && !isMakingRequest;
		}
		
		protected function updateDisplayList():void {
			loginBtn.x = PADDING_SMALL;
			loginBtn.y = PADDING_SMALL;
			
			makeBatchRequestBtn.x = (stage.stageWidth / 2) - (makeBatchRequestBtn.width / 2);
			makeBatchRequestBtn.y = loginBtn.y;
			
			getMyInfoToggle.diameter = 10;
			getMyInfoToggle.x = PADDING_SMALL;
			
			getMyInfoBtn.x = getMyInfoToggle.x + getMyInfoToggle.width + PADDING_SMALL;
			getMyInfoBtn.y = loginBtn.y + loginBtn.height + PADDING_LARGE;
			
			getMyInfoToggle.y = getMyInfoBtn.y + (getMyInfoBtn.height / 2) - (getMyInfoToggle.height / 2);
			
			myInfoText.x = getMyInfoBtn.x + getMyInfoBtn.width + PADDING_SMALL;
			myInfoText.y = getMyInfoBtn.y;
			myInfoText.width = stage.stageWidth - PADDING_SMALL - myInfoText.x;
			myInfoText.height = 100;
			
			postMessageToggle.diameter = 10;
			postMessageToggle.x = PADDING_SMALL;
			postMessageToggle.y = myInfoText.y + myInfoText.height + PADDING_LARGE;
			
			postMessageBtn.x = postMessageToggle.x + postMessageToggle.width + PADDING_SMALL;
			postMessageBtn.y = myInfoText.y + myInfoText.height + PADDING_SMALL;
			
			postMessageToggle.y = postMessageBtn.y + (postMessageBtn.height / 2) - (postMessageToggle.height / 2);
			
			postMessageInput.x = postMessageBtn.x + postMessageBtn.width + PADDING_SMALL;
			postMessageInput.y = postMessageBtn.y;
			postMessageInput.width = 350;
			postMessageInput.height = postMessageBtn.height;
			
			postMessageCompleteText.x = postMessageInput.x + postMessageInput.width + PADDING_SMALL;
			postMessageCompleteText.y = postMessageInput.y;
			
			uploadImagesToggle.diameter = 10;
			uploadImagesToggle.x = PADDING_SMALL;
			uploadImagesToggle.y = postMessageBtn.y + postMessageBtn.height + PADDING_LARGE;
			
			uploadImagesBtn.x = uploadImagesToggle.x + uploadImagesToggle.width + PADDING_SMALL;
			uploadImagesBtn.y = postMessageBtn.y + postMessageBtn.height + PADDING_SMALL;
			
			uploadImagesToggle.y = uploadImagesBtn.y + (uploadImagesBtn.height / 2) - (uploadImagesToggle.height / 2);
			
			albumPickerText.x = uploadImagesBtn.x + uploadImagesBtn.width + PADDING_SMALL;
			albumPickerText.y = uploadImagesBtn.y;
			
			albumPicker.x = albumPickerText.x + albumPickerText.width + PADDING_SMALL;
			albumPicker.y = uploadImagesBtn.y;
			albumPicker.width = 200;
			
			uploadPhotosCompleteText.x = albumPicker.x + albumPicker.width + PADDING_SMALL;
			uploadPhotosCompleteText.y = uploadImagesBtn.y;
			
			imagesContainer.x = uploadImagesBtn.x;
			imagesContainer.y = uploadImagesBtn.y + uploadImagesBtn.height + PADDING_SMALL;
		}
		
		// Event Handlers:
		
		protected function handleMakeBatchRequestBtnClick(event:MouseEvent):void {
			// Create a new Batch object:
			var batch:Batch = new Batch();
			
			// Check if user wants to get their info:
			if (getMyInfoEnabled) {
				myInfoText.text = "";
				myInfoText.alpha = 0.5;
				batch.add("me/", handleGetInfoComplete);
			}
			
			// Check if user wants to post a message:
			if (postMessagesEnabled) {
				postMessageCompleteText.visible = false;
				batch.add("me/feed/", handlePostMessageComplete, {message:postMessageInput.text}, URLRequestMethod.POST);
			}
			
			// Check if user wants to upload photos:
			if (uploadImagesEnabled) {
				var albumId:String = albumPicker.selectedItem.id;
				uploadedImages = 0;
				uploadPhotosCompleteText.visible = false;
				for (var i:int, l:int = imagesList.length; i < l; i++) {
					//Add each photo to this batch.
					batch.add(
						'/'+albumId+'/photos', //Upload photos to this album
						handleUploadImageComplete, //Called after the batch operation is complete. 
						{
							message:'My photo ' + (i + 1),
							fileName:'FILE_NAME' + i,
							image:(imagesList[i] as Bitmap).bitmapData
						}, //Add the image data and related data (the batch operation will format the image for upload)
						URLRequestMethod.POST
					);
				}
			}
			
			isMakingRequest = true;
			updateDisplay();
			
			// Make the batch request call.
			//handleBatchRequestComplete: Will be called after the individual batch callbacks
			FacebookDesktop.batchRequest(batch, handleBatchRequestComplete);
		}
		
		protected function handleGetInfoComplete(result:Object):void {
			if (!("error" in result.body)) {
				myInfoText.alpha = 1;
				myInfoText.text = JSON.encode(result.body);
			} else {
				myInfoText.text = "An Error Occured.";
			}
		}
		
		protected function handlePostMessageComplete(result:Object):void {
			postMessageCompleteText.visible = true;
			postMessageCompleteText.text = ("error" in result.body) ? "An Error Occured" : "Message Posted!";
		}
		
		protected function handleUploadImageComplete(result:Object):void {
			if (++uploadedImages == imagesList.length) {
				uploadPhotosCompleteText.visible = true;
				uploadPhotosCompleteText.text = ("error" in result.body) ? "An Error Occured" : "Images Posted!";
			}
		}
		
		protected function handleBatchRequestComplete(result:Object):void {
			isMakingRequest = false;
			updateDisplay();
		}
		
		protected function handleGetMyInfoBtnClick(event:MouseEvent):void {
			getMyInfoEnabled = !getMyInfoEnabled;
			updateDisplay();
		}
		
		protected function handlePostMessageBtnClick(event:MouseEvent):void {
			postMessagesEnabled = !postMessagesEnabled;
			postMessageCompleteText.visible = postMessagesEnabled;
			postMessageCompleteText.text = "";
			updateDisplay();
		}
		
		protected function handleUploadImagesBtnClick(event:MouseEvent):void {
			uploadImagesEnabled = !uploadImagesEnabled;
			uploadPhotosCompleteText.visible = uploadImagesEnabled;
			uploadPhotosCompleteText.text = "";
			updateDisplay();
		}
		
		protected function handleLogin(result:Object, fail:Object):void {
			loginBtn.enabled = true;
			if (result) { // User successfully logged in.
				loginBtn.label = "Logout";
				isLoggedIn = true;
				getMyInfoEnabled = postMessagesEnabled = uploadImagesEnabled = true;
				updateDisplay();
				
				albumPickerText.text = "Loading Albums...";
				FacebookDesktop.api("me/albums", handleAlbumsComplete);
				
				updateDisplayList();
			} else { // User unsuccessfully logged in.
				loginBtn.label = "Login";
			}
		}
		
		protected function handleAlbumsComplete(result:Object, error:Object):void {
			if (result && !result.error) {
				var albums:Array = result as Array;
				albumPicker.dataProvider = new DataProvider(albums);
				albumPicker.labelField = "name";
				
				albumPickerText.text = "Albums:";
				
				uploadImagesEnabled = true;
				uploadImagesBtn.enabled = true;
				updateDisplay();
				updateDisplayList();
			} else {
				albumPicker.dataProvider = new DataProvider();
				albumPicker.visible = true;
				albumPickerText.text = "No Albums";
				uploadImagesEnabled = false;
				updateDisplay();
				updateDisplayList();
				uploadImagesBtn.enabled = false;
			}
		}
		
		protected function handleLogout(success:Boolean):void {
			albumPicker.dataProvider = new DataProvider();
			loginBtn.enabled = true;
			loginBtn.label = "Login";
			isLoggedIn = false;
			getMyInfoEnabled = postMessagesEnabled = uploadImagesEnabled = false;
			postMessageCompleteText.visible = uploadPhotosCompleteText.visible = false;
			updateDisplay();
		}
		
		protected function handleLoginBtnClick(event:MouseEvent):void {
			loginBtn.enabled = false;
			if (isLoggedIn) {
				loginBtn.label = "Logging Out...";
				FacebookDesktop.logout(handleLogout, APP_ORIGIN);
			} else {
				loginBtn.label = "Logging In...";
				FacebookDesktop.login(handleLogin, permissions);
			}
		}
		
	}
	
}
