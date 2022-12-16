package statemachine
{
	public interface IState
	{
		function enter():void;
		function update(tickCount:int):void;
		function exit():void;
	}
}