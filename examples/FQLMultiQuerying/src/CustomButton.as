package {
	
	import flash.display.GradientType;
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Matrix;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	public class CustomButton extends Sprite {
		
		public static const UP:String = "CustomButton.up";
		public static const DOWN:String = "CustomButton.down";
		public static const DISABLED:String = "CustomButton.disabled";
		
		// Protected Properties:
		
		protected var bg:Sprite;
		protected var labelText:TextField;
		
		// Getter/Setters:
		
		protected var _label:String = "";
		public function get label():String { return _label; }
		public function set label(value:String):void {
			_label = value || "";
			labelText.text = _label;
			updateDisplay();
		}
		
		protected var _state:String = UP;
		public function get state():String { return _state; }
		public function set state(value:String):void {
			_state = value || UP;
			updateDisplay();
		}
		
		protected var _enabled:Boolean = true;
		public function get enabled():Boolean { return _enabled; }
		public function set enabled(value:Boolean):void {
			_enabled = mouseEnabled = value;
			state = _enabled ? UP: DISABLED;
			//if (_enabled) {
				//addEventListener(MouseEvent.MOUSE_DOWN, handleMouseDown, false, 0, true);
		//	} else {
				//removeEventListener(MouseEvent.MOUSE_DOWN, handleMouseDown);
			//}
		}
		
		public function CustomButton() {
			super();
			
			bg = new Sprite();
			addChild(bg);
			
			labelText = new TextField();
			labelText.autoSize = TextFieldAutoSize.LEFT;
			labelText.selectable = false;
			labelText.defaultTextFormat = new TextFormat("_sans", 14);
			addChild(labelText);
			
			enabled = true;
			addEventListener(MouseEvent.MOUSE_DOWN, handleMouseDown, false, 0, true);
			addEventListener(MouseEvent.CLICK, handleMouseClick, false, 0, true);
		}
		
		// Protected Methods:
		
		protected function updateDisplay():void {
			var g:Graphics = bg.graphics;
			g.clear();
			var matr:Matrix = new Matrix();
			matr.createGradientBox(30, 21, Math.PI * 0.5, 0, 0);
			alpha = 1;
			switch (state) {
				case UP:
					g.lineStyle(1, 0x333333, 1, true);
					g.beginGradientFill(GradientType.LINEAR, [0xffffff, 0xcccccc], [1, 1], [0, 255], matr);
					_enabled = true;
					bg.x = bg.y = 0;
					break;
				case DOWN:
					g.lineStyle(1, 0x000000, 1, true);
					g.beginGradientFill(GradientType.LINEAR, [0xffffff, 0xaaaaaa], [1, 1], [0, 255], matr);
					_enabled = true;
					bg.x = bg.y = 1;
					break;
				case DISABLED:
					g.lineStyle(1, 0x000000, 1, true);
					g.beginGradientFill(GradientType.LINEAR, [0xffffff, 0xaaaaaa], [1, 1], [0, 255], matr);
					_enabled = mouseEnabled = false;
					bg.x = bg.y = 0;
					alpha = 0.5;
					break;
			}
			g.drawRoundRect(0, 0, labelText.width + 10, labelText.height + 5, 10, 10);
			g.endFill();
			
			labelText.x = (bg.width >> 1) - (labelText.width >> 1);
			labelText.y = (bg.height >> 1) - (labelText.height >> 1);
		}
		
		// Event Handlers:
		
		protected function handleMouseDown(event:MouseEvent):void {
			if (!_enabled) {
				event.stopImmediatePropagation();
				return;
			}
			state = DOWN;
			stage.addEventListener(MouseEvent.MOUSE_UP, handleMouseUp, false, 0, true);
		}
		
		protected function handleMouseUp(event:MouseEvent):void {
			if (!_enabled) {
				event.stopImmediatePropagation();
				return;
			}
			state = UP;
			stage.removeEventListener(MouseEvent.MOUSE_UP, handleMouseUp);
		}
		
		protected function handleMouseClick(event:MouseEvent):void {
			if (!_enabled) {
				event.stopImmediatePropagation();
				return;
			}
		}
		
	}
}