package {
	
	import flash.display.Graphics;
	import flash.display.Sprite;
	
	public class ToggleButton extends Sprite {
		
		// Protected Properties:
		
		protected var selectedState:Sprite;
		protected var unselectedState:Sprite;
		
		// Getter/Setters:
		
		protected var _diameter:Number = 10;
		public function get diameter():Number { return _diameter; }
		public function set diameter(value:Number):void {
			_diameter = value;
			updateDisplay();
		}
		
		protected var _selected:Boolean = false;
		public function get selected():Boolean { return _selected; }
		public function set selected(value:Boolean):void {
			_selected = value;
			updateDisplay();
		}
		
		public function ToggleButton() {
			super();
			
			unselectedState = new Sprite();
			addChild(unselectedState);
			
			selectedState = new Sprite();
			addChild(selectedState);
			
			updateDisplay();
		}
		
		// Protected Methods:
		
		protected function updateDisplay():void {
			selectedState.visible = _selected;
			
			var g:Graphics = selectedState.graphics;
			g.clear();
			g.lineStyle(1);
			g.beginFill(0x00ff00);
			g.drawCircle(_diameter / 2, _diameter / 2, _diameter / 2);
			
			g = unselectedState.graphics;
			g.clear();
			g.lineStyle(1);
			g.beginFill(0xff0000);
			g.drawCircle(_diameter / 2, _diameter / 2, _diameter / 2);
		}
		
	}
}