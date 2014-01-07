package
{
	import com.gestureworks.cml.core.CMLObjectList;
	import com.gestureworks.cml.elements.TouchContainer;
	
	public class AnalogMapper implements Mapper
	{
		public var pin:Number;
		public var cmlID:String;
		public var property:String;
		public var inMin:Number;
		public var inMax:Number;
		public var outMin:Number;
		public var outMax:Number;
		
		private var _viewer:ArduinoViewer;
		
		 
		/**
		 * toggles low-pass filter
		 */
		public var lowPass:Boolean = true;
		
		
		/**
		 * smoothing for low-pass filter
		 * 0 ≤ alpha ≤ 1 ; a smaller value basically means more smoothing
		 * See: http://en.wikipedia.org/wiki/Low-pass_filter#Discrete-time_realization
		 * @default 0.15
		 */
		public var lowPassValue:Number = 0.05;
		
		 
		/**
		 * toggles rounding of data
		 */
		public var round:Boolean = true;
		
		/*
		 * round to nearest nth value
		 */
		public var roundValue:Number = .001;
		
		
		// stores output of low-pass filter
		private var smoothedValue:Number;
		
		
		public function AnalogMapper(pin:Number, cmlID:String, property:String, inMin:Number=0, inMax:Number=1.0, outMin:Number=0.0, outMax:Number=1.0)
		{
			this.pin = pin;
			this.cmlID = cmlID;
			this.property = property;
			this.inMin = inMin;
			this.inMax = inMax;
			this.outMin = outMin;
			this.outMax = outMax;
		}
		
				
		public function fire(pin:Object, value:Number):void {		
			
			if (lowPass) {
				value = lowPassData(value, smoothedValue);
				smoothedValue = value;
			}
			
			if (round)
				value = roundToNearest(roundValue, value);
						
			var obj:* = CMLObjectList.instance.getId(cmlID);
			var newValue:Number = value;
			if (Math.abs(this.inMax-this.inMin) < 0.00001) newValue=value;
			else newValue=(value - this.inMin)*(this.outMax-this.outMin)/(this.inMax-this.inMin) + this.outMin;
						
			if (obj && obj.hasOwnProperty(property)) {
				obj[property] = newValue;
			}
		}
		
		
		function roundToNearest(roundTo:Number, value:Number):Number{
			return Math.round(value/roundTo)*roundTo;
		}
		
		
		 
		/**
		 * @see http://en.wikipedia.org/wiki/Low-pass_filter#Algorithmic_implementation
		 * @see http://developer.android.com/reference/android/hardware/SensorEvent.html#values
		 */
		private function lowPassData(input:Number, output:Number) {
			if (isNaN(output)) return input;
			output = output + lowPassValue * (input - output);
			return output;
		}	
				
		
		public function register(_viewer:ArduinoViewer):void
		{			
			this._viewer = _viewer;
			this._viewer.dispatcher.addAnalogEventListener(pin, fire);
			
			if (pin>=0) fire(pin, _viewer.analogPins[pin]);
		}
		
		public function unregister():void {
			if (this._viewer != null) {
				this._viewer.dispatcher.removeAnalogEventListener(pin, fire);
			}
		}
		
		public function toString():String {
			return "Analog pin: " + pin + " min: " + inMin + " max: " + inMax + " CML ID: " +  cmlID + " property: " + property + " min: " + outMin + " max: " + outMax; 	
		}
		
	}
}