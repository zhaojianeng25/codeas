class TextRegVo {
    public begin: number
    public end: number
    public color: string
}
class TextRegExp {
    public static item: Array<TextRegVo>;
    public static defaultColor: string = "#000000"
    public constructor() {
    }
    public static pushStr($str: string): void {
        this.item = new Array();
        var patt1: RegExp = /\[\]|\[[A-Za-z0-9]{6}\]/g;
        var arr: RegExpExecArray;
        while ((arr = patt1.exec($str)) != null) {
            // console.log(arr.index + "-" + patt1.lastIndex + ":" + arr);
            var $vo: TextRegVo = new TextRegVo;
            $vo.begin = arr.index
            $vo.end = patt1.lastIndex
            $vo.color = arr.toString();
            $vo.color = $vo.color.replace("[", "");
            $vo.color = $vo.color.replace("]", "");
            //    console.log($baseColor)
            if ($vo.color.length < 5) {
                $vo.color = TextRegExp.defaultColor;
            } else {
                $vo.color = "#" + $vo.color;
            }
            this.item.push($vo)
        }
    }
    public static isColor($index: number, $ctx: CanvasRenderingContext2D): boolean {
        for (var i: number = 0; i < this.item.length; i++) {
            if ($index >= this.item[i].begin && $index < this.item[i].end) {
                if ($ctx) {
                    $ctx.fillStyle = this.item[i].color;
                }
                return true
            }
        }
        return false
    }
    public static getTextMetrics($ctx: CanvasRenderingContext2D, text: string): TextMetrics {
        if (!text) {
            text = ""
        }
        this.pushStr(text);
        var words = text;
        var line = "";
        var ty: number = 0
        for (var n = 0; n < words.length; n++) {
            if (this.isColor(n, $ctx)) {
                continue;
            }
            line += words[n];
        }
        var metrics: TextMetrics = $ctx.measureText(line);
        return metrics;
    }
    public static getTextOnlyTxt($ctx: CanvasRenderingContext2D, text: string): string {
        if (!text) {
            text = ""
        }
        this.pushStr(text);
        var words = text;
        var line = "";
        var ty: number = 0
        for (var n = 0; n < words.length; n++) {
            if (this.isColor(n, $ctx)) {
                continue;
            }
            line += words[n];
        }
        return line;
    }

    public static wrapText($ctx: CanvasRenderingContext2D, text: string, baseColor: string, x: number = 0, y: number = 0,
     maxWidth: number = 500, lineHeight: number = 10,$filterColor:string = "",$filterWidth:number = 4): number {
        TextRegExp.defaultColor = baseColor;

        if($filterColor != ""){
            $ctx.strokeStyle = $filterColor;
            $ctx.lineWidth = $filterWidth;
        }

        this.pushStr(text);
        var words = text;
        var line = "";
        var ty: number = 2  //特殊加上偏移， 还待测试调整
        var $lineNum: number = 1 //行数
        for (var n = 0; words&&n < words.length; n++) {
            if (this.isColor(n, $ctx)) {
                continue;
            }
            var metrics: TextMetrics = $ctx.measureText(line.replace("\n", ""));
            if (metrics.width > maxWidth || words[n] == "\n") {
                ty += lineHeight;
                line = "";
                if (words[n] != "\n") {
                    if($filterColor != ""){
                        $ctx.strokeText(words[n], x, y + ty);
                    }
                    $ctx.fillText(words[n], x, y + ty);
                }
                $lineNum++
            } else {
                if($filterColor != ""){
                    $ctx.strokeText(words[n], x + metrics.width * 1.0, y + ty);
                }
                $ctx.fillText(words[n], x + metrics.width * 1.0, y + ty);
            }
            line += words[n];
        }
        return $lineNum
    }
}
class LabelTextFont {
    /*
    *写入单行颜色字体，字号,对齐，基础颜色 并上传显卡
    */
    public static writeSingleLabel($uiAtlas: UIAtlas, $key: string, $str: string, fontsize: number = 12, $align: string = TextAlign.CENTER, 
        $baseColor: string = "#ffffff", $filterColor: string = "", $filterWidth: number = 4): void {

        if ($baseColor.indexOf("[")!=-1) {  //[00ff00]
            $baseColor = "#" + $baseColor.substr(1, 6);
        }

        var $uiRect: UIRectangle = $uiAtlas.getRec($key);
        var $ctx: CanvasRenderingContext2D = UIManager.getInstance().getContext2D($uiRect.pixelWitdh, $uiRect.pixelHeight, false);

        $ctx.fillStyle = $baseColor
        $ctx.font = (true ? "bolder " : "") + " " + fontsize + "px " + UIData.font;
        var $textMetrics: TextMetrics = TextRegExp.getTextMetrics($ctx, $str)
        var $tx: number = 0
        if ($align == TextAlign.CENTER) {
            $tx = ($uiRect.pixelWitdh - $textMetrics.width) / 2;
        } else if ($align == TextAlign.RIGHT) {
            $tx = ($uiRect.pixelWitdh - $textMetrics.width);
        }
        TextRegExp.wrapText($ctx, $str, $baseColor, $tx, 0, $uiRect.pixelWitdh - (fontsize / 2), 20,$filterColor,$filterWidth);

        $uiAtlas.updateCtx($ctx, $uiRect.pixelX, $uiRect.pixelY);
    }
    /*
  *将单行颜色字写到CTX中
  */
    public static writeSingleLabelToCtx($ctx: CanvasRenderingContext2D, $str: string, fontsize: number = 12, $tx: number = 0, $ty: number = 0, 
        $align: string = TextAlign.CENTER, $baseColor: string = "#ffffff",$filterColor:string = ""): void {
 
        if ($baseColor.indexOf("[") != -1) {  //[00ff00]
            $baseColor = "#" + $baseColor.substr(1, 6);
        }

        $ctx.fillStyle = $baseColor
        $ctx.font = (true ? "bolder " : "") + " " + fontsize + "px " + UIData.font;
        var $textMetrics: TextMetrics = TextRegExp.getTextMetrics($ctx, $str)
        if ($align == TextAlign.CENTER) {
            $tx -= $textMetrics.width / 2;
        } else if ($align == TextAlign.RIGHT) {
            $tx -= $textMetrics.width;
        }
        TextRegExp.wrapText($ctx, $str, $baseColor, $tx, $ty, 9999, 20,$filterColor);
    }

    /*
    *写入普通文字
    */
    public static writeText($uiAtlas: UIAtlas, $key: string,
        $x: number, $y: number,
        $str: string, fontsize: number, fontColor: string, $maxWidth: number = 0, bolder: boolean = false): Array<number> {

        var totalwidthAndheight:Array<number> = new Array

        var uiRect: UIRectangle = $uiAtlas.getRec($key);
        var ctx: CanvasRenderingContext2D = UIManager.getInstance().getContext2D(uiRect.pixelWitdh, uiRect.pixelHeight, false);

        ctx.fillStyle = fontColor;
        ctx.font = (bolder ? "bolder " : "") + fontsize + "px " + UIData.font;

        var $xpos: number = this.getTextxpos(TextAlign.LEFT, ctx);
        if ($maxWidth > 0) {
            totalwidthAndheight = this.wrapText(ctx, $str, $x, $y, $maxWidth, fontsize + 2);
        } else {
            ctx.fillText($str, $x + $xpos, $y);
        }

        $uiAtlas.updateCtx(ctx, uiRect.pixelX, uiRect.pixelY);
        return totalwidthAndheight;
    }

    /*
    *写入普通文字,字数不满足换行时，自动居中。Ctx
    *pixelHeight:Ctx的高
    */
    public static writeTextAutoCenterToCtx(ctx: CanvasRenderingContext2D, $str: string, fontsize: number = 12, $maxWidth: number, pixelHeight: number, $baseColor: string = "#ffffff"): void {

        if ($baseColor.indexOf("[") != -1) {  //[00ff00]
            $baseColor = "#" + $baseColor.substr(1, 6);
        }
        
        ctx.fillStyle = $baseColor
        ctx.font = (true ? "bolder " : "") + " " + fontsize + "px " + UIData.font;
        var $x = 0
        var $y = 0
        var $xpos: number = this.getTextxpos(TextAlign.LEFT, ctx);
        if ($maxWidth > 0) {
            if (!this.isNewline(ctx, $str, $maxWidth)) {
                $y = (pixelHeight / 2) - (fontsize / 2)
            }
            this.wrapText(ctx, $str, $x, $y, $maxWidth, fontsize + 3);
        }
    }


    /*
    *写入普通文字,字数不满足换行时，自动居中。
    */
    public static writeTextAutoCenter($uiAtlas: UIAtlas, $key: string,
        $str: string, fontsize: number, fontColor: string, $maxWidth: number, bolder: boolean = false): void {

        var uiRect: UIRectangle = $uiAtlas.getRec($key);
        var ctx: CanvasRenderingContext2D = UIManager.getInstance().getContext2D(uiRect.pixelWitdh, uiRect.pixelHeight, false);

        ctx.fillStyle = fontColor;
        ctx.font = (bolder ? "bolder " : "") + fontsize + "px " + UIData.font;

        var $x = 0
        var $y = 0
        var $xpos: number = this.getTextxpos(TextAlign.LEFT, ctx);
        if ($maxWidth > 0) {
            if (!this.isNewline(ctx, $str, $maxWidth)) {
                $y = (uiRect.pixelHeight / 2) - (fontsize / 2)
            }
            this.wrapText(ctx, $str, $x, $y, $maxWidth, fontsize + 3);
        }

        $uiAtlas.updateCtx(ctx, uiRect.pixelX, uiRect.pixelY);

    }

    private static isNewline(ctx: CanvasRenderingContext2D, $text: string, $maxWidth: number): boolean {
        var words = $text;
        var metrics = ctx.measureText(words);
        var testWidth = metrics.width;
        if (testWidth > $maxWidth) {
            return true;
        }
        return false;
    }

    public static writeTextToCtx(ctx: CanvasRenderingContext2D,
        $x: number, $y: number,
        $str: string, fontsize: number, fontColor: string, bolder: boolean = false, $maxWidth: number = 0): void {

        ctx.textBaseline = TextAlign.MIDDLE;
        ctx.textAlign = TextAlign.CENTER;
        ctx.fillStyle = fontColor;
        ctx.font = "bolder " + fontsize + "px " + UIData.font;

        var $xpos: number = this.getTextxpos(TextAlign.CENTER, ctx);
        if ($maxWidth > 0) {
            this.wrapText(ctx, $str, $x, $y, $maxWidth, fontsize + 3);
        } else {
            ctx.fillText($str, $x + $xpos, $y);
        }
    }

    private static getTextxpos($textAlign: string, $ctx: CanvasRenderingContext2D): number {

        var $xpos: number = 0;
        if ($textAlign == TextAlign.LEFT) {
            $xpos = 0;
        } else if ($textAlign == TextAlign.RIGHT) {
            $xpos = $ctx.canvas.width;
        } else if ($textAlign == TextAlign.CENTER) {
            $xpos = $ctx.canvas.width / 2;
        }
        return $xpos;
    }

    private static wrapText($ctx: CanvasRenderingContext2D, text: string, $tx: number, $ty: number, maxWidth: number, $th: number):Array<number> {
        var totalWidth:number = 0;
        var totalHeight:number = $ty;
        var words = text;
        var line = "";
        for (var n = 0; n < words.length; n++) {
            if (words[n] == "\n") {
                $ctx.fillText(line, $tx, totalHeight);
                line = "";
                totalHeight += $th;
            } else {
                var testLine = line + words[n];
                var metrics = $ctx.measureText(testLine);
                var testWidth = metrics.width;
                totalWidth = Math.max(totalWidth,testWidth);
                if (testWidth > maxWidth) {
                    $ctx.fillText(line, $tx, totalHeight);
                    line = words[n] + "";
                    totalHeight += $th;
                } else {
                    line = testLine;
                }
            }
        }
        $ctx.fillText(line, $tx, totalHeight);

        //计算高度
        totalHeight = totalHeight - $ty + $th;

        return [totalWidth,totalHeight];
    }

    public static clearLabel($uiAtlas: UIAtlas, $key: string): void {
        var $uiRect: UIRectangle = $uiAtlas.getRec($key);
        var $ctx: CanvasRenderingContext2D = UIManager.getInstance().getContext2D($uiRect.pixelWitdh, $uiRect.pixelHeight, false);
        $uiAtlas.updateCtx($ctx, $uiRect.pixelX, $uiRect.pixelY);
    }


}