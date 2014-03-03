package com.gestureworks.cml.elements
{
	import com.gestureworks.cml.elements.*;
	import flash.events.*;
	import org.libspark.betweenas3.*;
	import org.libspark.betweenas3.easing.*;
	import org.libspark.betweenas3.tweens.*;
	import com.gestureworks.cml.managers.FileManager;

	/**
	 * ImageSlideshow
	 * Image sequencer with cross-fade transitions
	 * @author Charles Veasey 
	 */	
	public class ImageSlideshow2 extends ImageSlideshow
	{	
		private var tween:ITween;
		
		public function ImageSlideshow2()
		{
			super();
		}
		
		private var loaded:Boolean = false;
		
		/**
		 * Default index sets the default image and displays it
		 */		
		private var _defaultIndex:int;
		public function get defaultIndex():int { return _defaultIndex };
		public function set defaultIndex(value:int):void
		{
			_defaultIndex = value;
		}	
			
		public function loadDefault(index:int):void
		{	
			currentIndex = index
			fadein(index);
		}

		override public function loadComplete():void 
		{
			loaded = true;  

			for (var i:int = 0; i < this.length; i++) 
			{
				getIndex(i).loadComplete();
			}	

			loadDefault(_defaultIndex);						
			dispatchEvent(new Event(Event.COMPLETE));
		}	
		
		/**
		 * Toggles index by boolean value
		 */		
		private var _toggleIndex:Boolean;
		public function set toggleIndex(value:Boolean):void
		{
			trace("toggleIndex", value);
			_toggleIndex = value;
						
			if (!value)
				fadeout(1);
			else 
				fadein(1);
		}	
		
		
		/**
		 * Fades out
		 * @param index 
		 */		
		override public function fadeout(index:int):void
		{
			
			trace("fadeout");
			var lastImage:* = getIndex(index);
			
			if (hasIndex(index))
			{
				tween = BetweenAS3.tween(lastImage, { alpha:0 }, null, fadeDuration/1000, Linear.easeOut);
				tween.play();
			}
		}
		
		
		/**
		 * Fades in
		 * @param index 
		 */		
		override public function fadein(index:int):void
		{
			trace("fadein");
			
			var currentImage:* = getIndex(index);
			
			getIndex(index).alpha = 0;
			show(index);
						
			tween = BetweenAS3.tween(currentImage, { alpha:1 }, null, fadeDuration/1000, Linear.easeIn);
			tween.play();
		}
		
		
	}
}