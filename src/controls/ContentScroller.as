package controls {
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	
	/**
	 * @author Devon O. Wolfgang
	 * @date 29NOV06
	 * Modified Adam Ashby
	 */
	
	
	public class ContentScroller {
		
		private var _mask:Sprite;
		private var _content:Sprite;
		private var _dragger:Sprite;
		private var _easeRate:Number;
		private var _direction:String;
		private var _bounds:Rectangle;
		private var _setSize:Boolean;
		private var _moveVert:Boolean = false;
		private var _moveHoriz:Boolean = false;
		
		private var _scrollValue:Number;
		private var _orgY:Number;
		private var _orgX:Number;
		private var _delta:Number = 0;
		
		/**
		 *
		 * @param content Sprite which will be scrolled by ContentScroller
		 * @param mask Sprite which will mask the scrolling content (mask should be set in another class)
		 * @param scrollbar Sprite which will be used to do the scrolling
		 * @param ease Number which controls amount of ease in scrolling. Higher the number, the more ease. 0 or 1 will have no ease.
		 * @param direction String specifying the direction of the scroll. Can either be "vertical" or "horizontal".
		 * @param setDraggerSize Boolean which decides whether to stretch the width or height of the scrollbar in proportion to the amount of content.
		 *
		 */
		public function ContentScroller(content:Sprite, mask:Sprite, scrollbar:Sprite, ease:Number = 0, direction:String = "vertical", setDraggerSize:Boolean = false) {
			_setSize = setDraggerSize;
			_content = content;
			_mask = mask;
			_dragger = scrollbar;
			_easeRate = ease;
			
			_dragger.buttonMode = true;
			
			if (_easeRate < 1) _easeRate = 1;
			_direction = direction;
			
			
			switch(_direction) {
				case "horizontal" :
					initHorizontal();
					break;
				case "vertical" :
					initVertical();
					break;
				default :
					trace ("CONTENT SCROLLER ERROR: direction argument should be either \"vertical\" or \"horizontal\".");
					break;
			}
		}
		
		private function initHorizontal():void {
			if (_mask.width < (_content.width - 1)) {
				if (_setSize) _dragger.width = Math.ceil((_mask.width / _content.width) * _mask.width);
				_scrollValue = _mask.width - _dragger.width;
				_orgX = _dragger.x;
				_bounds = new Rectangle(_orgX, _dragger.y, _scrollValue, 0);
				
				addListeners();
			}
		}
		
		private function initVertical():void {
			if (_mask.height < (_content.height - 1)) {
				if (_setSize) _dragger.height = Math.ceil((_mask.height / _content.height) * _mask.height);
				_scrollValue = _mask.height - _dragger.height;
				_orgY = _dragger.y;
				_bounds = new Rectangle(_dragger.x, _orgY, 0, _scrollValue);
				
				addListeners();
			}
		}
		
		private function addListeners():void {
			_dragger.addEventListener(MouseEvent.MOUSE_DOWN, onDraggerPress, false, 0, true);
			_dragger.addEventListener(MouseEvent.MOUSE_UP, onDraggerUp, true, 0, true);
			_dragger.stage.addEventListener(MouseEvent.MOUSE_UP, onDraggerUp, false, 0, true);
			_dragger.stage.addEventListener(MouseEvent.MOUSE_WHEEL, onWheel);
		}
		
		private function onWheel(me:MouseEvent):void
		{

			_delta = me.delta * 4;
			//trace(me.delta);
			
			if (_direction == "vertical") {
				_dragger.y -=  _delta ;
				if(_dragger.y < _bounds.top) _dragger.y = _bounds.top; 
				if(_dragger.y > _bounds.bottom) _dragger.y = _bounds.bottom;
				var ratioV:Number = (_dragger.y - _orgY) / _scrollValue;
				var tyV:Number = _orgY - (_content.height - _mask.height) * ratioV;
				var distV:Number = tyV - _content.y;
				//var moveAmountV:Number = distV / _easeRate;
				_content.y += distV;
			} else if (_direction == "horizontal") {
				_dragger.x -= me.delta;
				if(_dragger.x < _bounds.left) _dragger.y = _bounds.left;
				if(_dragger.x > _bounds.right) _dragger.x = _bounds.right;
				var ratio:Number = (_dragger.x - _orgX) / _scrollValue;
				var tx:Number = _orgX - (_content.width - _mask.width) * ratio;
				var dist:Number = tx - _content.x;
				//var moveAmount:Number = dist / _easeRate;
				_content.x += dist;
			}
			
		}
		
		private function onDraggerPress(me:MouseEvent):void {
			var _ratio:Number = (_dragger.y - _orgY) / _scrollValue;
			var _ty:Number = _orgY - (_content.height - _mask.height) * _ratio;
			_dragger.startDrag(false, _bounds);
			if (_direction == "vertical") {
				_dragger.addEventListener(MouseEvent.MOUSE_MOVE, onVerticalScroll, false, 0, true);
				_dragger.stage.addEventListener(MouseEvent.MOUSE_MOVE, onVerticalScroll, false, 0, true);
			} else if (_direction == "horizontal") {
				_dragger.addEventListener(MouseEvent.MOUSE_MOVE, onHorizontalScroll, false, 0, true);
				_dragger.stage.addEventListener(MouseEvent.MOUSE_MOVE, onHorizontalScroll, false, 0, true);
			}
		}
		
		private function onDraggerUp(me:MouseEvent):void {
			_dragger.stopDrag();
			
			_dragger.removeEventListener(MouseEvent.MOUSE_MOVE , onVerticalScroll);
			_dragger.stage.removeEventListener(MouseEvent.MOUSE_MOVE, onVerticalScroll);
			
			_dragger.removeEventListener(MouseEvent.MOUSE_MOVE , onHorizontalScroll);
			_dragger.stage.removeEventListener(MouseEvent.MOUSE_MOVE, onHorizontalScroll);
		}
		
		private function onVerticalScroll(me:MouseEvent):void {
			me.updateAfterEvent();
			//if (!_content.willTrigger(Event.ENTER_FRAME)) _content.addEventListener(Event.ENTER_FRAME, moveVertical, false, 0, true);
			if (!_moveVert) _content.addEventListener(Event.ENTER_FRAME, moveVertical, false, 0, true);
		}
		
		private function onHorizontalScroll(me:MouseEvent):void {
			me.updateAfterEvent();
			//if (!_content.willTrigger(Event.ENTER_FRAME)) _content.addEventListener(Event.ENTER_FRAME, moveHorizontal, false, 0, true);
			if (!_moveHoriz) _content.addEventListener(Event.ENTER_FRAME, moveVertical, false, 0, true);
		}
		
		private function moveVertical(e:Event):void {
			//trace('moveVertical');
			_moveVert = true;
			var ratio:Number = (_dragger.y - _orgY) / _scrollValue;
			var ty:Number = _orgY - (_content.height - _mask.height) * ratio;
			var dist:Number = ty - _content.y;
			var moveAmount:Number = dist / _easeRate;
			_content.y += moveAmount;
			if (Math.abs(_content.y - ty) < 1) {
				_content.removeEventListener(Event.ENTER_FRAME, moveVertical);
				//_dragger.stage.removeEventListener(MouseEvent.MOUSE_WHEEL, onWheelStart);
				_moveVert = false;
				//_delta = 0;
				_content.y = ty;
			}
		}
		
		private function moveHorizontal(e:Event):void {
			_moveHoriz = true;
			var ratio:Number = (_dragger.x - _orgX) / _scrollValue;
			var tx:Number = _orgX - (_content.width - _mask.width) * ratio;
			var dist:Number = tx - _content.x;
			var moveAmount:Number = dist / _easeRate;
			_content.x += moveAmount;
			if (Math.abs(_content.x - tx) < 1) {
				_content.removeEventListener(Event.ENTER_FRAME, moveHorizontal);
				//_dragger.stage.removeEventListener(MouseEvent.MOUSE_WHEEL, onWheelStart);
				_moveHoriz = false;
				//_delta = 0;
				_content.x = tx;
			}
		}
		
		public function removeAllListeners():void
		{
			_dragger.removeEventListener(MouseEvent.MOUSE_DOWN, onDraggerPress);
			_dragger.removeEventListener(MouseEvent.MOUSE_UP, onDraggerUp);
			_dragger.stage.removeEventListener(MouseEvent.MOUSE_UP, onDraggerUp);
			_dragger.stage.removeEventListener(MouseEvent.MOUSE_WHEEL, onWheel);
			
			_dragger.removeEventListener(MouseEvent.MOUSE_MOVE , onVerticalScroll);
			_dragger.stage.removeEventListener(MouseEvent.MOUSE_MOVE, onVerticalScroll);
			
			_dragger.removeEventListener(MouseEvent.MOUSE_MOVE , onHorizontalScroll);
			_dragger.stage.removeEventListener(MouseEvent.MOUSE_MOVE, onHorizontalScroll);
			
			_content.removeEventListener(Event.ENTER_FRAME, moveHorizontal);
		}
	}
}