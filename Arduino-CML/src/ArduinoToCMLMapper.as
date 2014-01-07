package {
	import com.gestureworks.cml.components.PanoramicViewer;
	import com.gestureworks.cml.core.CMLObjectList;
	import com.gestureworks.cml.elements.TouchContainer;
	import com.gestureworks.cml.utils.LinkedMap;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	
	import spark.components.Label;
	
	
	public class ArduinoToCMLMapper extends Sprite {
		private var button:Sprite;
		private var buttonLabel:TextField;
		private var _buttonState:Boolean;

		private var addButton:TextField;		
		private var panel:Sprite;

		private var mappers:Array;
		
		private var _viewer:ArduinoViewer;
				
		public function ArduinoToCMLMapper(viewer:ArduinoViewer) {
			_viewer = viewer;
						
			initButton();
			initPanel();
			
			addChild(button);
			addChild(panel);
			
			updateButton();
			initMappers();
		}

		private function initMappers():void {
			//initial set of mappers.  This can be removed to start from a blank slate
			mappers = [
				new DigitalMapper(2, 'muscles-frontal', 'toggleIndex', false),
				new DigitalMapper(2, 'skull-frontal', 'toggleIndex', false),
				new DigitalMapper(2, 'brain-frontal', 'toggleIndex', false),
								
				new AnalogMapper(2, 'skull-frontal', 'alpha', .10, .40, 0, 1),
				new AnalogMapper(2, 'brain-frontal', 'alpha', .50, .80, 0, 1),
				
				new DigitalMapper(2, 'muscles-lateral', 'toggleIndex', false),
				new DigitalMapper(2, 'skull-lateral', 'toggleIndex', false),
				new DigitalMapper(2, 'brain-lateral', 'toggleIndex', false),
								
				new AnalogMapper(2, 'skull-lateral', 'alpha', .10, .40, 0, 1),
				new AnalogMapper(2, 'brain-lateral', 'alpha', .50, .80, 0, 1),
		
				new RFIDMapper("4800E4E29C", 'frontal', 'toggle', false),
				new RFIDMapper("4800E5274B", 'lateral', 'toggle', false),
			];
			
			for each (var mapper:Mapper in mappers) {
				var mapperUI:MapperUI = new MapperUI(_viewer);
				mapperUI.setToMapper(mapper);
				addMapperUI(mapperUI);
			}
		}
		
		private function initPanel():void {
			panel = new Sprite();
			panel.y = 20;
			panel.visible = true;						
		}
		
		private function initButton(buttonState:Boolean=false):void {
			this._buttonState = buttonState;
			button = new Sprite();
			
			buttonLabel = new TextField();
			buttonLabel.background = true;
			buttonLabel.selectable = false;
			buttonLabel.height = 20;
			
			button.addChild(buttonLabel);
			
			button.x = 0; //1024 - button.width;
			button.y = 0;
			button.height = 20;
			
			buttonLabel.addEventListener(MouseEvent.CLICK, toggleHandler);
			
			addButton = new TextField();
			addButton.text=" + ";
			addButton.background=true;
			addButton.backgroundColor=_buttonState? 0x00CC00 : 0xCC0000;
			addButton.textColor=0xFFFFFF;
			addButton.height = 20;
			addButton.width = 20;
			addButton.selectable = false;
			button.addChild(addButton);
			addButton.x = buttonLabel.width;
			addButton.y = buttonLabel.y;
			addButton.addEventListener(MouseEvent.CLICK, function(event:MouseEvent):void {
				if (!_buttonState) {
					_buttonState = !_buttonState;
					updateButton();
				} else {
					addMapperUI(new MapperUI(_viewer));
				}
			});	
		}
		
		private function addMapperUI(mapperui:MapperUI):void {
			panel.addChild(mapperui);
			
			var predIndex:int = mapperui.parent.getChildIndex(mapperui) - 1;
			if (predIndex >= 0) {
				var pred:DisplayObject = mapperui.parent.getChildAt(predIndex);
				mapperui.y = pred.y + pred.height;
				
			}			
		}
		
		private function updateButton():void {
			buttonLabel.text = "Maps";
			buttonLabel.textColor = 0xFFFFFF;
			buttonLabel.backgroundColor = _buttonState ? 0x00CC00 : 0xCC0000;
			addButton.backgroundColor=_buttonState? 0x00CC00 : 0xCC0000;
			
			panel.visible = _buttonState;
		}
		
		private function toggleHandler(event:Event):void {
			_buttonState = !_buttonState;
			updateButton();
		}
	}
}
