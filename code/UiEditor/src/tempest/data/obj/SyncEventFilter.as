package tempest.data.obj
{
    import __AS3__.vec.*;
    import flash.utils.*;

    public class SyncEventFilter extends SyncEvent
    {
        private var _opening:Boolean;
        private var _curObj:GuidObject;
        private var _curEventCount:int;
        private var _eventObjs:Vector.<String>;
        private var _eventParams:ByteArray;
        public static const EV_NEW:int = 0;
        public static const EV_DEL:int = 1;
        public static const EV_UPDATE_I:int = 2;
        public static const EV_UPDATE_S:int = 3;

        public function SyncEventFilter()
        {
            this._opening = false;
            this._curObj = null;
            this._curEventCount = 0;
            this._eventParams = new ByteArray();
            this._eventParams.endian = Endian.LITTLE_ENDIAN;
            this._eventObjs = new Vector.<String>;
            return;
        }// end function

        public function open() : void
        {
            if (!this._opening)
            {
                this._opening = true;
            }
            return;
        }// end function

        public function close() : void
        {
            if (this._opening)
            {
                this._opening = false;
                this._curObj = null;
                this._curEventCount = 0;
                this._eventObjs.length = 0;
                this._eventParams.clear();
            }
            return;
        }// end function

        public function beginPush(param1:GuidObject) : Boolean
        {
            if (this._curObj)
            {
                this.endPush();
            }
            this._curObj = param1;
            this._eventObjs.push(param1.guid);
            this._eventParams.writeShort(0);
            return true;
        }// end function

        public function endPush() : void
        {
            var _loc_1:* = 0;
            if (this._curEventCount)
            {
                _loc_1 = this._eventParams.position;
                this._eventParams.position = this._eventParams.position - 8 * this._curEventCount;
                this._eventParams.position = this._eventParams.position - 2;
                this._eventParams.writeShort(this._curEventCount);
                this._curEventCount = 0;
                this._eventParams.position = _loc_1;
            }
            else
            {
                this._eventObjs.splice((this._eventObjs.length - 1), 1);
                this._eventParams.position = this._eventParams.position - 2;
            }
            this._curObj = null;
            return;
        }// end function

        private function writeParam(param1:int, param2:int, param3:int) : void
        {
            this._eventParams.writeShort(param1);
            this._eventParams.writeShort(param2);
            this._eventParams.writeInt(param3);
            var _loc_4:* = this;
            var _loc_5:* = this._curEventCount + 1;
            _loc_4._curEventCount = _loc_5;
            return;
        }// end function

        public function pushDelete() : void
        {
            this.writeParam(EV_DEL, 0, 0);
            return;
        }// end function

        public function pushNew() : void
        {
            this.writeParam(EV_NEW, 0, 0);
            return;
        }// end function

        public function pushUpdateMask(param1:int, param2:UpdateMask) : void
        {
            var _loc_4:* = 0;
            var _loc_3:* = param2.GetCount();
            if (param1 == TYPE_STRING)
            {
                _loc_4 = 0;
                while (_loc_4 < _loc_3)
                {
                    
                    if (param2.GetBit(_loc_4))
                    {
                        this.writeParam(EV_UPDATE_S, _loc_4, 0);
                    }
                    _loc_4 = _loc_4 + 1;
                }
            }
            else
            {
                _loc_4 = 0;
                while (_loc_4 < _loc_3)
                {
                    
                    if (param2.GetBit(_loc_4))
                    {
                        this.writeParam(EV_UPDATE_I, _loc_4, this._curObj.GetInt32(_loc_4));
                    }
                    _loc_4 = _loc_4 + 1;
                }
            }
            return;
        }// end function

        public function pushBinlog(param1:BinLogStru) : void
        {
            if (param1._atomic_opt != 0)
            {
                return;
            }
            var _loc_2:* = param1._typ == TYPE_STRING ? (EV_UPDATE_S) : (EV_UPDATE_I);
            this.writeParam(_loc_2, param1.index, this._curObj.GetInt32(param1.index));
            return;
        }// end function

        public function beginPop() : void
        {
            this._eventParams.position = 0;
            return;
        }// end function

        public function pop(param1:Vector.<int>) : String
        {
            if (this._eventObjs.length == 0)
            {
                return "";
            }
            param1.length = 0;
            var _loc_2:* = this._eventParams.readShort();
            var _loc_3:* = 0;
            while (_loc_3 < _loc_2)
            {
                
                param1.push(this._eventParams.readShort());
                param1.push(this._eventParams.readShort());
                param1.push(this._eventParams.readInt());
                _loc_3 = _loc_3 + 1;
            }
            return this._eventObjs.shift();
        }// end function

        public function endPop() : void
        {
            if (this._eventObjs.length == 0)
            {
                this._eventParams.clear();
            }
            return;
        }// end function

        public function Clear() : void
        {
            this._curObj = null;
            this._eventObjs = null;
            if (this._eventParams)
            {
                this._eventParams.clear();
                this._eventParams = null;
            }
            return;
        }// end function

    }
}
