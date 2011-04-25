package {
	
	import com.adobe.serialization.json.JSON;
	import com.facebook.graph.FacebookDesktop;
	import com.facebook.graph.data.FQLMultiQuery;
	
	import flash.desktop.NativeApplication;
	import flash.display.GradientType;
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Matrix;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	
	[SWF(width="650", height="700", backgroundColor="0xffffff", frameRate="15")]
	public class FQLMultiQuerying extends Sprite {
		
		// Static/Constant Properties:
		
		protected static const APP_ID:String = "YOUR_APP_ID"; // Your App ID.
		protected static const APP_ORIGIN:String = "http://your.site.com/"; // The site URL of your application (specified in your app settings); needed for clearing cookie when logging out.
		
		public static const ALBUM_FIELDS:String = "aid, cover_pid, name, owner";
		public static const PHOTO_FIELDS:String = "pid, aid, owner, src_small, src_big, src, caption, object_id";
		public static const TAG_FIELDS:String = "pid, subject, text";
		public static const USER_FIELDS:String = "uid, name";
		
		public static const PADDING_SMALL:Number = 10;
		public static const PADDING_TINY:Number = 5;
		
		// Public Properties:
		
		public var loginBtn:CustomButton;
		public var getAlbumsBtn:CustomButton;
		
		public var upBtn:CustomButton;
		public var downBtn:CustomButton;
		
		public var albumsContainer:Sprite;
		public var albumsMask:Sprite;
		
		// Protected Properties:
		
		protected var isLoggedIn:Boolean = false;
		protected var permissions:Array = ["user_photos", "user_likes", "friends_likes"];
		
		protected var renderers:Vector.<AlbumRenderer>;
		protected var focusedIndex:int;
		
		// Getter/Setter Properties:
		
		// Initialization:
		public function FQLMultiQuerying() {
			configUI();
			FacebookDesktop.init(APP_ID, handleInit);
			addEventListener(Event.DEACTIVATE, handleDeactivate, false, 0, true);
		}
		
		// Protected Methods:
		
		protected function configUI():void {
			loginBtn = new CustomButton();
			loginBtn.label = "Checking Login...";
			loginBtn.x = PADDING_SMALL;
			loginBtn.y = PADDING_SMALL;
			loginBtn.addEventListener(MouseEvent.CLICK, handleLoginBtnClick, false, 0, true);
			loginBtn.enabled = false;
			addChild(loginBtn);
			
			getAlbumsBtn = new CustomButton();
			getAlbumsBtn.label = "Get Albums and Their Tags";
			getAlbumsBtn.x = loginBtn.x + loginBtn.width + PADDING_SMALL;
			getAlbumsBtn.y = loginBtn.y;
			getAlbumsBtn.addEventListener(MouseEvent.CLICK, handleGetAlbumsBtnClick, false, 0, true);
			getAlbumsBtn.visible = false;
			addChild(getAlbumsBtn);
			
			downBtn = new CustomButton();
			downBtn.label = "Scroll Down";
			downBtn.x = stage.stageWidth - downBtn.width - PADDING_SMALL;
			downBtn.y = PADDING_SMALL;
			downBtn.addEventListener(MouseEvent.CLICK, handleDownBtnClick, false, 0, true);
			downBtn.visible = false;
			addChild(downBtn);
			
			upBtn = new CustomButton();
			upBtn.label = "Scroll Up";
			upBtn.x = downBtn.x - upBtn.width - PADDING_SMALL;
			upBtn.y = PADDING_SMALL;
			upBtn.addEventListener(MouseEvent.CLICK, handleUpBtnClick, false, 0, true);
			upBtn.visible = false;
			addChild(upBtn);
		}
		
		protected function setupTextField(textField:TextField):void {
			textField.autoSize = TextFieldAutoSize.LEFT;
			textField.selectable = false;
			textField.defaultTextFormat = new TextFormat("_sans", 14);
		}
		
		protected function updateDisplay():void {
			// Reposition renderers:
			var al:int = renderers.length;
			var renderer:AlbumRenderer;
			var yOffset:Number = 0;
			for (var i:int = 0; i < al; i++) {
				renderer = renderers[i];
				renderer.y = yOffset;
				renderer.setWidth(stage.stageWidth - albumsContainer.x - albumsContainer.x);
				
				yOffset += renderer.height + PADDING_SMALL;
			}
			
			albumsContainer.y = (getAlbumsBtn.y + getAlbumsBtn.height + PADDING_SMALL) - renderers[focusedIndex].y;
		}
		
		// Event Handlers:
		
		protected function handleDeactivate(event:Event):void {
			//FacebookDesktop.logout(handleLogout, APP_ORIGIN);
			//NativeApplication.nativeApplication.exit();
		}
		
		protected function handleInit(result:Object, fail:Object):void {
			loginBtn.enabled = true;
			if (result) { // User is already logged in.
				loginBtn.label = "Logout";
				isLoggedIn = true;
				getAlbumsBtn.x = loginBtn.x + loginBtn.width + PADDING_SMALL;
				getAlbumsBtn.visible = true;
			} else { // User hasn't logged in.
				loginBtn.label = "Login";
			}
		}
		
		protected function handleLogin(result:Object, fail:Object):void {
			if (result) { // User successfully logged in.
				loginBtn.label = "Logout";
				isLoggedIn = true;
				getAlbumsBtn.x = loginBtn.x + loginBtn.width + PADDING_SMALL;
				getAlbumsBtn.visible = true;
			} else { // User unsuccessfully logged in.
				loginBtn.label = "Login";
			}
		}
		
		protected function handleLogout(success:Boolean):void {
			loginBtn.label = "Login";
			isLoggedIn = false;
			
			getAlbumsBtn.visible = downBtn.visible = upBtn.visible = false;
			getAlbumsBtn.enabled = true;
			getAlbumsBtn.label = "Get Albums and Their Tags";
			
			if (albumsContainer) { removeChild(albumsContainer); }
			albumsContainer = null;
		}
		
		protected function handleLoginBtnClick(event:MouseEvent):void {
			if (isLoggedIn) {
				FacebookDesktop.logout(handleLogout, APP_ORIGIN);
			} else {
				FacebookDesktop.login(handleLogin, permissions);
			}
		}
		
		protected function handleGetAlbumsBtnClick(event:MouseEvent):void {
			getAlbumsBtn.enabled = false;
			getAlbumsBtn.label = "Loading albums...";
			
			var queries:FQLMultiQuery = new FQLMultiQuery();
			queries.add("SELECT {FIELDS} FROM album WHERE owner=me()", "query1", {FIELDS:ALBUM_FIELDS});
			queries.add("SELECT {FIELDS} FROM photo WHERE aid IN (SELECT aid FROM #query1)", "query2", {FIELDS:PHOTO_FIELDS});
			queries.add("SELECT {FIELDS} FROM photo_tag WHERE pid IN (SELECT pid FROM #query2)", "query3", {FIELDS:TAG_FIELDS});
			queries.add("SELECT {FIELDS} FROM photo WHERE pid IN (SELECT cover_pid FROM #query1)", "query4", {FIELDS:PHOTO_FIELDS});
			FacebookDesktop.fqlMultiQuery(queries, handleAlbumInfo);
		}
		
		protected function handleAlbumInfo(result:Object, fail:Object):void {
			if (result) {
				getAlbumsBtn.label = "Albums loaded";
				
				var albums:Array = result.query1 as Array;
				var photos:Array = result.query2 as Array;
				var tags:Array = result.query3 as Array;
				var covers:Array = result.query4 as Array;
				
				if (albumsContainer) { removeChild(albumsContainer); }
				albumsContainer = new Sprite();
				albumsContainer.x = PADDING_SMALL;
				albumsContainer.y = getAlbumsBtn.y + getAlbumsBtn.height + PADDING_SMALL;
				addChild(albumsContainer);
				if (!albumsMask) {
					albumsMask = new Sprite();
					albumsMask.graphics.beginFill(0xffffff);
					albumsMask.graphics.drawRect(albumsContainer.x, albumsContainer.y, stage.stageWidth - albumsContainer.x - albumsContainer.x, stage.stageHeight - albumsContainer.y - PADDING_SMALL);
					albumsMask.graphics.endFill();
					addChild(albumsMask);
				}
				albumsContainer.mask = albumsMask;
				renderers = new Vector.<AlbumRenderer>(albums.length, true);
				var al:int = albums.length;
				var pl:int = photos.length;
				var tl:int = tags.length;
				var cl:int = covers.length;
				var albumData:Object;
				var album:AlbumRenderer;
				var albumPhotos:Array;
				var albumTags:Array;
				var photo:Object;
				var tag:Object;
				var atl:int;
				for (var i:int = 0; i < al; i++) {
					album = new AlbumRenderer();
					albumData = albums[i];
					
					albumData.photos = albumPhotos = [];
					albumData.tags = albumTags = [];
					atl = 0;
					
					// Add album's photos:
					for (var j:int = 0; j < pl; j++) {
						photo = photos[j];
						if (photo.aid == albumData.aid) {
							albumPhotos.push(photo);
							
							// Add album's tags:
							for (var k:int = 0; k < tl; k++) {
								tag = tags[k];
								if (tag.pid == photo.pid) {
									var isAdded:Boolean = false;
									// Make sure this tag hasn't already been added:
									for (var m:int = 0; m < atl; m++) {
										if (albumTags[m].text == tag.text) {
											isAdded = true; break;
										}
									}
									if (!isAdded) {
										// User/tag has not been added.
										albumTags.push(tag);
										atl++;
									}
								}
							}
						}
					}
					
					// Add album's cover photo:
					for (var n:int = 0; n < cl; n++) {
						if (covers[n].pid == albumData.cover_pid) {
							albumData.cover = covers[n]; break;
						}
					}
					
					album.addEventListener(AlbumRenderer.IMAGE_LOADED, handleAlbumImageLoaded, false, 0, true);
					album.data = albumData;
					albumsContainer.addChild(album);
					
					renderers[i] = album;
				}
				updateDisplay();
				
				focusedIndex = 0;
				downBtn.visible = upBtn.visible = albumsContainer.y + albumsContainer.height > stage.stageHeight;
				upBtn.enabled = false;
			} else {
				getAlbumsBtn.label = "Error";
			}
		}
		
		protected function handleAlbumImageLoaded(event:Event):void {
			updateDisplay();
		}
		
		protected function handleDownBtnClick(event:MouseEvent):void {
			albumsContainer.y -= renderers[focusedIndex].height + PADDING_SMALL;
			focusedIndex++;
			if (albumsContainer.y + albumsContainer.height < stage.stageHeight) {
				downBtn.enabled = false;
			}
			if (focusedIndex > 0) {
				upBtn.enabled = true;
			}
		}
		
		protected function handleUpBtnClick(event:MouseEvent):void {
			focusedIndex--;
			albumsContainer.y += renderers[focusedIndex].height + PADDING_SMALL;
			if (focusedIndex == 0) {
				upBtn.enabled = false;
			}
			if (focusedIndex < renderers.length - 1) {
				downBtn.enabled = true;
			}
		}
		
	}
	
}