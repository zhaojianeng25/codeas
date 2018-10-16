package tempest.common.rsl
{
	import org.osflash.signals.ISignal;
	import org.osflash.signals.Signal;
	import org.osflash.signals.utilities.SignalSet;
	import tempest.common.rsl.vo.TRslVO;
	
	public class RlsSignal extends SignalSet
	{
		private var _complete:ISignal;
		private var _error:ISignal;
		private var _progress:ISignal;
		public function RlsSignal()
		{
			super();
		}
		public function get progress():ISignal
		{
			return _progress ||= getSignal("progress",Signal,TRslVO);
		}
		public function get complete():ISignal
		{
			return _complete ||= getSignal("complete",Signal,TRslVO);
		}
		public function get error():ISignal
		{
			return _error ||= getSignal("error",Signal,TRslVO);
		}
	}
}