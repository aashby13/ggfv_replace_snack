package statemachine
{
	import statemachine.IState;
	
	public class StateMachine
	{
		public var current:String;
		public var previous:String;
		
		private var states:Object;
		private var strict:Boolean;
		
		public var tickCount:int = 0;
		
		public function StateMachine(isStrict:Boolean = true)
		{
			strict = isStrict;
			states = new Object();
		}
		
		public function setState(name:String):void
		{
			
			if(current == null)
			{
				current = name;
				states[current].state.enter();
				return;
			}
			
			if(current == name)
			{
				trace("this object is already in the " + name + " state.");
				return;
			}
			
			if(strict)
			{
				if(states[current].to.indexOf(name) != -1)
				{
					states[current].state.exit();
					previous = current;
					current = name;
				}
				else
				{
					trace("state " + name + " cannot be used while in the " + current + " state.");
					return;
				}
			}
			else
			{
				states[current].state.exit();
				previous = current;
				current = name;
			}
			
			states[current].state.enter();
			tickCount = 0;
		}
		
		public function addState(name:String, stateObj:IState, toStates:Array = null):void
		{
			states[name] = {state:stateObj, to:toStates.toString()};
		}
		
		public function update():void
		{
			states[current].state.update(tickCount++);
		}
	}
}