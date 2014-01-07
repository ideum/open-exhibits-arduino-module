package 
{
	import ArduinoViewer;
	
	import com.gestureworks.cml.core.CMLObjectList;
	import com.gestureworks.components.CMLDisplay; CMLDisplay;
	import com.gestureworks.core.GestureWorks;
	import com.gestureworks.core.TouchSprite;
	import com.gestureworks.events.GWGestureEvent;
	import com.gestureworks.cml.core.CMLParser;
	
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.URLRequest;
	import flash.utils.Dictionary;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.display.StageDisplayState;
	
	import com.gestureworks.cml.elements.ImageSlideshow2; ImageSlideshow2;
	import com.gestureworks.cml.elements.Container2; Container2;
		
	[SWF(width = "1920", height = "1080", backgroundColor = "0XFFFFFF", frameRate = "30")]
	
	public class Main extends GestureWorks
	{
		private var _viewer:ArduinoViewer;
		private var _mapper:ArduinoToCMLMapper;
		
		private var _globalListeners : Dictionary;
		
		public function Main():void 
		{
			super();
			settingsPath = "library/cml/my_application.cml";
			stage.scaleMode = StageScaleMode.SHOW_ALL;
			stage.align = StageAlign.TOP_LEFT;
			stage.displayState = StageDisplayState.FULL_SCREEN_INTERACTIVE;
			CMLParser.instance.addEventListener(CMLParser.COMPLETE, cmlInit);	
		}
		
		private function cmlInit(event:Event):void
		{
			trace("cmlInit()");	
			
			_globalListeners = new Dictionary();
			
			//Arduino viewer communicates with arduino and allows for listeners to register
			viewer = new ArduinoViewer();
			addChild(viewer);
			
			//Tracks mapper objects that turns arduino events into changes in CML object property
			mapper = new ArduinoToCMLMapper(viewer);
			mapper.x = 175;
			addChild(mapper);
			
			//debug listen for all events
			addListenerForAllEvents( function(event:Event):void { trace(event); } );
		}
		
		public function get mapper():ArduinoToCMLMapper
		{
			return _mapper;
		}

		public function set mapper(value:ArduinoToCMLMapper):void
		{
			_mapper = value;
		}

		public function get viewer():ArduinoViewer
		{
			return _viewer;
		}

		public function set viewer(value:ArduinoViewer):void
		{
			_viewer = value;
		}

		public function addListenerForAllEvents( listener : Function ) : void{
			_globalListeners[ listener ] = listener;
		}
		
		public function removeListenerForAllEvents( listener : Function ) : void{
			delete _globalListeners[ listener ];
		}
		
		override public function dispatchEvent(event:Event):Boolean{
			var result:Boolean = super.dispatchEvent( event );
			
			for each( var listener : Function in _globalListeners ){
				listener( event );
			}
			
			return result;
		}	
	}
	
}

