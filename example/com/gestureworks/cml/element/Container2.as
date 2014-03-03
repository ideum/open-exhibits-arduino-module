package com.gestureworks.cml.elements
{
	import com.gestureworks.cml.elements.*;
	import flash.events.*;
	
	public class Container2 extends Container
	{			
		public function Container2()
		{
			super();
		}
		
		private var _toggle:Boolean = false;
		public function get toggle():Boolean { return _toggle; }
		public function set toggle(value:Boolean):void
		{
			trace("toggle", value);
			
			if (value) {
				this.visible = true;
		
				if (parent)
					parent.addChildAt(this, parent.numChildren - 1);
			}
		}
		
		
	}
}