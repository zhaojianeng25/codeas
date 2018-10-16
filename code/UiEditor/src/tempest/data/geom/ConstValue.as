package tempest.data.geom
{
    import flash.filters.*;
    import flash.geom.*;

    public class ConstValue extends Object
    {
        public static const ZeroPoint:Point = new Point();
        public static const ZeroMatrix:Matrix = new Matrix();
        public static const TRAN_HALF_ColorTransform:ColorTransform = new ColorTransform(1, 1, 1, 0.5, 0, 0, 0, 0);
        public static const ZeroColorTransform:ColorTransform = new ColorTransform(1, 1, 1, 1, 0, 0, 0, 0);
        public static const GLOW:GlowFilter = new GlowFilter(16777215);
        public static const SHADOW_CororTranform:ColorTransform = new ColorTransform(0, 0, 0, 0.3, 0, 0, 0, 0);
        public static const Grayscale_Fiter:Array = [new ColorMatrixFilter([0.3086, 0.6094, 0.082, 0, 0, 0.3086, 0.6094, 0.082, 0, 0, 0.3086, 0.6094, 0.082, 0, 0, 0, 0, 0, 1, 0])];
        public static const BLACK_TO_TRAN_MatrixFilter:ColorMatrixFilter = new ColorMatrixFilter([1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0.8, 0.8, 0.8, 0, 0]);
        public static const GREEN_TO_TRAN_MatrixFilter:ColorMatrixFilter = new ColorMatrixFilter([1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1, 0, 0, 1, 0, 1, 0, 0]);
        public static const GREEN_TO_RED_CororTranform:ColorTransform = new ColorTransform(0, 0, 0, 1, 220, 0, 0, 0);

        public function ConstValue()
        {
            return;
        }// end function

    }
}
