package tempest.common.net
{
	import flash.events.Event;
	import flash.utils.ByteArray;
	
	import org.osflash.signals.natives.base.SignalSocket;
	
	import tempest.common.net.vo.TPacketIn;
	import tempest.common.net.vo.TPacketOut;
	import tempest.core.IDisposable;
	import tempest.core.ISocket;

	/**
	 * Socket客户端
	 * @author wsk
	 */
	public class TSocket extends SignalSocket implements IDisposable, ISocket
	{
		private static const BUFFER_MAX_SIZE:int=10000;
		public static const STACK_SIZE:int=10;
		private var _buffer:ByteArray=null;
		public var handles:Array=null;
		private var packetsStack:Vector.<TPacketIn>=null;
		private var _encroypt:Function;
		private var _decroypt:Function;
		public var protect:Boolean=false;

		/**
		 * Socket客户端
		 * @param host
		 * @param port
		 */
		public function TSocket(name:String="", throwError:Boolean=false, encroypt:Function=null, decroypt:Function=null)
		{
			_name=name;
			_throwError=throwError;
			_encroypt=encroypt;
			_decroypt=decroypt;
			_buffer=new ByteArray();
			handles=[];
			packetsStack=new Vector.<TPacketIn>();
			this.signals.socketData.addWithPriority(receiveHandler, int.MAX_VALUE);
			this.signals.close.addWithPriority(closehandler, int.MAX_VALUE);
			this.signals.connect.addWithPriority(connectHandle, int.MAX_VALUE);
			this.signals.ioError.addWithPriority(ioErrorHandle, int.MAX_VALUE);
			this.signals.securityError.addWithPriority(securityHandle, int.MAX_VALUE);
		}
		private var _name:String;
		private var _throwError:Boolean;

		public function get name():String
		{
			return _name;
		}

		/**
		 * 批量注册处理函数
		 * @param handlers [[opcode,handle],...]
		 */
		public function mapHandles(handles:Array):void
		{
			handles.forEach(function(item:*, index:int, array:Array):void
			{
				mapHandle(item[0], item[1]);
			});
		}

		/**
		 * 批量注册操作码
		 * @param opcodes [opcode,opcode,...]
		 * @param handle
		 */
		public function mapOpcodes(opcodes:Array, handle:Function):void
		{
			opcodes.forEach(function(item:*, index:int, array:Array):void
			{
				mapHandle(item, handle);
			});
		}

		/**
		 * 批量注册处理类
		 * @param opcode
		 * @param handleCls
		 */
		public function mapHandleCls(opcode:int, handleCls:Class):void
		{
			var handle:IPacketHandler=new handleCls();
			if (handle)
			{
				mapHandle(opcode, handle.handPacket);
			}
		}

		/**
		 * 注册处理类
		 * @param handleClses
		 */
		public function mapHandleClses(handleClses:Array):void
		{
			handleClses.forEach(function(item:*, index:int, array:Array):void
			{
				mapHandleCls(item[0], item[1]);
			});
		}

		/**
		 * 注册处理函数
		 * @param opcode 操作码
		 * @param handle 处理函数
		 */
		public function mapHandle(opcode:int, handle:Function):void
		{
			if (handles[opcode] != null)
			{
				trace("操作码覆盖:{0}", opcode);
			}
			handles[opcode]=handle;
		}

		/**
		 * 批量取消操作码
		 * @param opcodes[opcode,opcode,...]
		 */
		public function unmapOpcodes(opcodes:Array):void
		{
			opcodes.forEach(function(item:*, index:int, array:Array):void
			{
				unmapHandle(int(item));
			});
		}

		/**
		 * 取消操作码
		 * @param opcode
		 */
		public function unmapHandle(opcode:int):void
		{
			handles[opcode]=null;
		}

		/**
		 * 取消所有操作码
		 */
		public function unmapAllHandles():void
		{
			handles=[];
		}

		//接收数据处理
		private function receiveHandler(e:Event):void
		{
			var temp:ByteArray;
			this.readBytes(this._buffer, this._buffer.length, this.bytesAvailable);
			if (this._buffer.length > BUFFER_MAX_SIZE)
			{
				temp=new ByteArray();
				this._buffer.readBytes(temp);
				this._buffer.clear();
				temp.readBytes(this._buffer);
			}
			this.fetchData();
		}

		private function fetchData():void
		{
			var packetIn:TPacketIn;
			while (this._buffer.bytesAvailable >= 4)
			{
				var len:int=this._buffer[this._buffer.position] << 8 | this._buffer[this._buffer.position + 1]; //读取长度
				//长度异常
				if (len < 2)
				{
					this.traceStack();
					trace("data exception!!!len:{0} pos:{1} bytesAvailable:{2}", len, this._buffer.position, this._buffer.bytesAvailable);
					this._buffer.clear();
				}
				//数据不够
				if (this._buffer.bytesAvailable < len + 2)
					return;
				packetIn=new TPacketIn();
				//packetIn.len = len;
				//this._buffer.readUnsignedShort(); //跳过2字节len
				//packetIn.cmd = this._buffer.readUnsignedByte() << 8 | this._buffer.readUnsignedByte();
				this._buffer.readBytes(packetIn, 0, len + 2);
				this.handPacket(packetIn);
			}
		}

		private function handPacket(pk:TPacketIn):void
		{
			var t0:int;
			var t1:int;
			if (protect)
			{
				_decroypt(pk);
			}
			pk.resolve();
			//处理封包
			var handler:Function=handles[pk.cmd];
			if (!(handler == null))
			{
//				try
//				{
//					t0 = getTimer()
				//处理封包
				handler(this, pk);
//				}
//				catch (e:Error)
//				{
//					//DEBUG
//					trace("处理命令发生错误 msg:" + e.message + " pk:" + pk.toString());
//					if (_throwError)
//					{
//						throw e;
//					}
//				}
//				finally
//				{
//					t1 = getTimer() - t0;
//					if (t1 > 15)
//					{
//						trace("!!!handle long time!!![socket:{0} opcode:{1} time:{2}]", this._name, pk.cmd, t1)
//					}
//				}
			}
			else
			{
				trace("未处理操作码:{0}", pk.cmd);
			}
			//////////////////////////////////////包堆栈///////////////////////////
			packetsStack.push(pk);
			if (packetsStack.length > STACK_SIZE)
			{
				packetsStack.shift().clear();
			}
		}

		public function traceStack():void
		{
			var len:int=packetsStack.length;
			for (var i:int=0; i != len; i++)
			{
				trace("PacketStack[{0}] " + packetsStack[i].toString(), i);
			}
		}

		/**
		 * 建立连接
		 * @param e
		 */
		protected function connectHandle(e:Event):void
		{
			_buffer.clear();
			packetsStack.length=0;
			trace("connect" + this.toString());
		}

		/**
		 * 断开连接
		 * @param e
		 */
		protected function closehandler(e:Event):void
		{
			trace("close" + this.toString());
		}

		/**
		 * IO错误 没有找到服务器
		 * @param e
		 */
		protected function ioErrorHandle(e:Event):void
		{
			trace("ioError" + this.toString());
		}

		/**
		 * 安全错误
		 * @param e
		 */
		protected function securityHandle(e:Event):void
		{
			trace("SecurityError" + this.toString());
		}

		/**
		 * 发送封包
		 * @param packet
		 */
		public function send(packet:TPacketOut):void
		{
			packet.resolve();
			if (protect)
			{
				_encroypt(packet);
			}
			if (this.connected)
			{
				this.writeBytes(packet);
				this.flush();
			}
			packet.clear();
		}

		public override function close():void
		{
			super.close();
			this.closehandler(null);
		}

		public function dispose():void
		{
			if (this.connected)
			{
				this.close();
			}
			this.unmapAllHandles();
			this.signals.removeAll();
		}

		public override function toString():String
		{
			return "[TSocket] name:" + _name;
		}
	}
}
