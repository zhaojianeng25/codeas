/**
 * Version 0.9.0 https://github.com/yungzhu/morn
 * Feedback yungzhu@gmail.com http://weibo.com/newyung
 * Copyright 2012, yungzhu. All rights reserved.
 * This program is free software. You can redistribute and/or modify it
 * in accordance with the terms of the accompanying license agreement.
 */
package _me  {
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.system.System;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.ui.Keyboard;
	
	/**日志管理器*/
	public class LogManager extends Sprite {
		private var _msgs:Array = [];
		private var _box:Sprite;
		private var _textField:TextField;
		private var _filter:TextField;
		private var _filters:Array = [];
		private var _canScroll:Boolean = true;
		private var _scroll:TextField;
		private static var _instance:LogManager;
		
		public function LogManager() {
			//容器
			_box = new Sprite();
			var boxBmp:Bitmap = new Bitmap( new BitmapData( 400, 800, false, 0x2D2D2D ) );
			boxBmp.alpha = 0.8;
			_box.addChild( boxBmp );
			_box.visible = false;
			addChild(_box);
			//筛选栏
			_filter = new TextField();
			_filter.width = 300;
			_filter.height = 20;
			_filter.type = "input";
			_filter.border = true;
			_filter.textColor = 0xFFFFFF;
			_filter.borderColor = 0x262626;
			_filter.addEventListener(KeyboardEvent.KEY_DOWN, onFilterKeyDown);
			_filter.addEventListener(FocusEvent.FOCUS_OUT, onFilterFocusOut);
			_box.addChild(_filter);
			//控制按钮			
			var clear:TextField = createLinkButton("Clear");
			clear.addEventListener(MouseEvent.CLICK, onClearClick);
			clear.x = 300;
			_box.addChild(clear);
			_scroll = createLinkButton("Pause");
			_scroll.addEventListener(MouseEvent.CLICK, onScrollClick);
			_scroll.x = 335;
			_box.addChild(_scroll);
			var copy:TextField = createLinkButton("Copy");
			copy.addEventListener(MouseEvent.CLICK, onCopyClick);
			copy.x = 370;
			_box.addChild(copy);
			//信息栏
			_textField = new TextField();
			_textField.width = 400;
			_textField.height = 780;
			_textField.y = 20;
			_textField.multiline = true;
			_textField.wordWrap = true;
			_textField.defaultTextFormat = new TextFormat("微软雅黑,宋体,Arial", 12);
			_box.addChild(_textField);
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			_textField.addEventListener(MouseEvent.MOUSE_DOWN, onStartDrag);
			_textField.addEventListener(MouseEvent.MOUSE_UP, onStopDrag);
		}
		
		private function onStartDrag(e:MouseEvent):void
		{
			startDrag();
		}
		
		private function onStopDrag(e:MouseEvent):void
		{
			stopDrag();
		}
		
		public static function getInstance():LogManager
		{
			if ( _instance == null )
				_instance = new LogManager();
			
			return _instance;
		}
		
		private function onAddedToStage(e:Event):void {
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			stage.addEventListener(KeyboardEvent.KEY_DOWN, onStageKeyDown);
			stage.addEventListener(Event.RESIZE, onStageResizeHandler);
			
			modifyPos();
		}
		
		private function createLinkButton(text:String):TextField {
			var tf:TextField = new TextField();
			tf.selectable = false;
			tf.autoSize = "left";
			tf.textColor = 0x0080FF;
			tf.text = text;
			return tf;
		}
		
		private function onCopyClick(e:MouseEvent):void {
			System.setClipboard(_textField.text);
		}
		
		private function onScrollClick(e:MouseEvent):void {
			_canScroll = !_canScroll;
			_scroll.text = _canScroll ? "Pause" : "Start";
			if (_canScroll) {
				refresh(null);
			}
		}
		
		private function onClearClick(e:MouseEvent):void {
			_msgs.length = 0;
			_textField.htmlText = "";
		}
		
		private function onFilterKeyDown(e:KeyboardEvent):void {
			if (e.keyCode == Keyboard.ENTER) {
//				App.stage.focus = _box;
				onFilterFocusOut(null);
			}
		}
		
		private function onFilterFocusOut(e:FocusEvent):void {
			_filters = ( ( null == _filter.text ) || ( "" == _filter.text ) ) ? [] : _filter.text.split(",");
			refresh(null);
		}
		
		private function onStageKeyDown(e:KeyboardEvent):void {
			if ( e.keyCode == Keyboard.F4) { // e.ctrlKey &&
				toggle();
			}
		}
		
		private function onStageResizeHandler( event:Event ):void
		{
			modifyPos();
		}
		
		private function modifyPos():void
		{
			x = stage.stageWidth - width - 10;
			y = stage.stageHeight - height - 220;
		}
		
		/**信息*/
		public function info(... args):void {
			print("info", args, 0xA2A2FF);
		}
		
		/**消息*/
		public function echo(... args):void {
			print("echo", args, 0x00C400);
		}
		
		/**调试*/
		public function debug(... args):void {
			print("debug", args, 0xE1E1E1);
		}
		
		/**错误*/
		public function error(... args):void {
			print("error", args, 0xFF80A9);
		}
		
		/**警告*/
		public function warn(... args):void {
			print("warn", args, 0xFFFF80);
		}
		
		private function print(type:String, args:Array, color:uint):void {
			var msg:String = "<font color='#" + color.toString(16) + "'><b>[" + type + "]</b>" + args.join(" ") + "</font>\n";
			_msgs.push(msg);
			while(_msgs.length > 3000)
			{
				_msgs.shift();
			}
			if (_box.visible) {
				refresh(msg);
			}
		}
		
		/**打开或隐藏面板*/
		private function toggle():void {

			_box.visible = !_box.visible;
			if (_box.visible) 
			{
				refresh(null);
			}
			else
			{
//				onClearClick(null);
			}
		}
		
		/**根据过滤刷新显示*/
		private function refresh(newMsg:String):void {
			var msg:String = "";
			if (newMsg != null) {
				if (isFilter(newMsg)) {
					msg = (_textField.htmlText || "") + newMsg;
					_textField.htmlText = msg;
				}
			} else {
				for each (var item:String in _msgs) {
					if (isFilter(item)) {
						msg += item;
					}
				}
				_textField.htmlText = msg;
			}
			if (_canScroll) {
				_textField.scrollV = _textField.maxScrollV;
			}
		}
		
		/**是否是筛选属性*/
		private function isFilter(msg:String):Boolean {
			if (_filters.length < 1) {
				return true;
			}
			for each (var item:String in _filters) {
				if (msg.indexOf(item) > -1) {
					return true;
				}
			}
			return false;
		}
	}
}