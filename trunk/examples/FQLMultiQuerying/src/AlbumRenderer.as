package {
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Graphics;
	import flash.display.LineScaleMode;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.HTTPStatusEvent;
	import flash.events.IOErrorEvent;
	import flash.net.URLRequest;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	public class AlbumRenderer extends Sprite {
		
		public static const PADDING_TINY:Number = 5;
		public static const IMAGE_LOADED:String = "imageLoader";
		
		protected const DEFAULT_COVER_SIZE:Number = 75;
		
		public var albumCover:Bitmap;
		public var albumNameText:TextField;
		public var userTagsText:TextField;
		public var divider:Sprite;
		
		public var tags:Array;
		
		// Protected Properties:
		
		protected var _width:Number = 100;
		protected var coverLoader:Loader;
		
		// Getter/Setters:
		
		public function AlbumRenderer() {
			super();
			configUI();
		}
		
		public function set data(value:Object):void {
			if (value.cover) {
				coverLoader = new Loader();
				coverLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, handleLoaderComplete, false, 0, true);
				//coverLoader.contentLoaderInfo.addEventListener(HTTPStatusEvent.HTTP_STATUS, handleLoaderError, false, 0, true);
				coverLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, handleLoaderError, false, 0, true);
				coverLoader.load(new URLRequest(value.cover.src_small));
			} else {
				albumCover.bitmapData = new BitmapData(DEFAULT_COVER_SIZE, DEFAULT_COVER_SIZE, false, 0x777777);
			}
			
			albumNameText.text = value.name || "";
			var userTags:String = "<b>Tags</b>: ";
			tags = value.tags;
			if (tags.length > 0) {
				var tag:Object;
				for (var i:int, l:int = tags.length; i < l; i++) {
					tag = tags[i];
					if (tag.subject && tag.subject != "") {
						userTags += "<font color='#0000cc'><u><a href='http://www.facebook.com/profile.php?id="+tag.subject+"'>" + tag.text + "</a></u></font>";
					} else {
						userTags += tag.text;
					}
					userTags += i+1 == l ? "" : ", "
				}
			} else {
				userTags = "<font color='#777777'>Nobody is tagged in this album :(</font>";
			}
			userTagsText.htmlText = userTags;
			
			updateDisplay();
		}
		
		public function setWidth(value:Number):void {
			_width = value;
			updateDisplay();
		}
		
		// Protected Methods:
		
		protected function configUI():void {
			albumCover = new Bitmap();
			albumCover.bitmapData = new BitmapData(DEFAULT_COVER_SIZE, DEFAULT_COVER_SIZE, false, 0xcccccc);
			addChild(albumCover);
			
			albumNameText = new TextField();
			albumNameText.autoSize = TextFieldAutoSize.LEFT;
			albumNameText.defaultTextFormat = new TextFormat("_sans", 14, 0x0, true);
			addChild(albumNameText);
			
			userTagsText = new TextField();
			userTagsText.autoSize = TextFieldAutoSize.LEFT;
			userTagsText.multiline = userTagsText.wordWrap = true;
			userTagsText.defaultTextFormat = new TextFormat("Arial", 11, 0x0, false);
			addChild(userTagsText);
			
			divider = new Sprite();
			var g:Graphics = divider.graphics;
			g.lineStyle(1, 0xcccccc, 1, true, LineScaleMode.NONE);
			g.lineTo(_width, 0);
			addChild(divider);
			
			updateDisplay();
		}
		
		protected function updateDisplay():void {
			albumNameText.x = userTagsText.x = albumCover.x + albumCover.width + PADDING_TINY;
			albumNameText.width = userTagsText.width = _width - albumNameText.x;
			userTagsText.y = albumNameText.y + albumNameText.height;
			
			divider.y = Math.max(albumCover.y + albumCover.height, userTagsText.y + userTagsText.height) + PADDING_TINY;
			divider.width = _width;
		}
		
		// Event Handlers:
		
		protected function handleLoaderComplete(event:Event):void {
			albumCover.bitmapData = (coverLoader.content as Bitmap).bitmapData;
			updateDisplay();
			
			dispatchEvent(new Event(IMAGE_LOADED));
		}
		
		protected function handleLoaderError(event:Event):void {
			albumCover.bitmapData = new BitmapData(DEFAULT_COVER_SIZE, DEFAULT_COVER_SIZE, false, 0x777777);
			updateDisplay();
		}
		
	}
}