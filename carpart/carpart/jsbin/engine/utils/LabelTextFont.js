var TextRegVo = (function () {
    function TextRegVo() {
    }
    return TextRegVo;
})();
var TextRegExp = (function () {
    function TextRegExp() {
    }
    TextRegExp.pushStr = function ($str) {
        this.item = new Array();
        var patt1 = /\[\]|\[[A-Za-z0-9]{6}\]/g;
        var arr;
        while ((arr = patt1.exec($str)) != null) {
            // console.log(arr.index + "-" + patt1.lastIndex + ":" + arr);
            var $vo = new TextRegVo;
            $vo.begin = arr.index;
            $vo.end = patt1.lastIndex;
            $vo.color = arr.toString();
            $vo.color = $vo.color.replace("[", "");
            $vo.color = $vo.color.replace("]", "");
            //    console.log($baseColor)
            if ($vo.color.length < 5) {
                $vo.color = TextRegExp.defaultColor;
            }
            else {
                $vo.color = "#" + $vo.color;
            }
            this.item.push($vo);
        }
    };
    TextRegExp.isColor = function ($index, $ctx) {
        for (var i = 0; i < this.item.length; i++) {
            if ($index >= this.item[i].begin && $index < this.item[i].end) {
                if ($ctx) {
                    $ctx.fillStyle = this.item[i].color;
                }
                return true;
            }
        }
        return false;
    };
    TextRegExp.getTextMetrics = function ($ctx, text) {
        if (!text) {
            text = "";
        }
        this.pushStr(text);
        var words = text;
        var line = "";
        var ty = 0;
        for (var n = 0; n < words.length; n++) {
            if (this.isColor(n, $ctx)) {
                continue;
            }
            line += words[n];
        }
        var metrics = $ctx.measureText(line);
        return metrics;
    };
    TextRegExp.getTextOnlyTxt = function ($ctx, text) {
        if (!text) {
            text = "";
        }
        this.pushStr(text);
        var words = text;
        var line = "";
        var ty = 0;
        for (var n = 0; n < words.length; n++) {
            if (this.isColor(n, $ctx)) {
                continue;
            }
            line += words[n];
        }
        return line;
    };
    TextRegExp.wrapText = function ($ctx, text, baseColor, x, y, maxWidth, lineHeight, $filterColor, $filterWidth) {
        if (x === void 0) { x = 0; }
        if (y === void 0) { y = 0; }
        if (maxWidth === void 0) { maxWidth = 500; }
        if (lineHeight === void 0) { lineHeight = 10; }
        if ($filterColor === void 0) { $filterColor = ""; }
        if ($filterWidth === void 0) { $filterWidth = 4; }
        TextRegExp.defaultColor = baseColor;
        if ($filterColor != "") {
            $ctx.strokeStyle = $filterColor;
            $ctx.lineWidth = $filterWidth;
        }
        this.pushStr(text);
        var words = text;
        var line = "";
        var ty = 2; //特殊加上偏移， 还待测试调整
        var $lineNum = 1; //行数
        for (var n = 0; words && n < words.length; n++) {
            if (this.isColor(n, $ctx)) {
                continue;
            }
            var metrics = $ctx.measureText(line.replace("\n", ""));
            if (metrics.width > maxWidth || words[n] == "\n") {
                ty += lineHeight;
                line = "";
                if (words[n] != "\n") {
                    if ($filterColor != "") {
                        $ctx.strokeText(words[n], x, y + ty);
                    }
                    $ctx.fillText(words[n], x, y + ty);
                }
                $lineNum++;
            }
            else {
                if ($filterColor != "") {
                    $ctx.strokeText(words[n], x + metrics.width * 1.0, y + ty);
                }
                $ctx.fillText(words[n], x + metrics.width * 1.0, y + ty);
            }
            line += words[n];
        }
        return $lineNum;
    };
    TextRegExp.defaultColor = "#000000";
    return TextRegExp;
})();
var LabelTextFont = (function () {
    function LabelTextFont() {
    }
    /*
    *写入单行颜色字体，字号,对齐，基础颜色 并上传显卡
    */
    LabelTextFont.writeSingleLabel = function ($uiAtlas, $key, $str, fontsize, $align, $baseColor, $filterColor, $filterWidth) {
        if (fontsize === void 0) { fontsize = 12; }
        if ($align === void 0) { $align = TextAlign.CENTER; }
        if ($baseColor === void 0) { $baseColor = "#ffffff"; }
        if ($filterColor === void 0) { $filterColor = ""; }
        if ($filterWidth === void 0) { $filterWidth = 4; }
        if ($baseColor.indexOf("[") != -1) {
            $baseColor = "#" + $baseColor.substr(1, 6);
        }
        var $uiRect = $uiAtlas.getRec($key);
        var $ctx = UIManager.getInstance().getContext2D($uiRect.pixelWitdh, $uiRect.pixelHeight, false);
        $ctx.fillStyle = $baseColor;
        $ctx.font = (true ? "bolder " : "") + " " + fontsize + "px " + UIData.font;
        var $textMetrics = TextRegExp.getTextMetrics($ctx, $str);
        var $tx = 0;
        if ($align == TextAlign.CENTER) {
            $tx = ($uiRect.pixelWitdh - $textMetrics.width) / 2;
        }
        else if ($align == TextAlign.RIGHT) {
            $tx = ($uiRect.pixelWitdh - $textMetrics.width);
        }
        TextRegExp.wrapText($ctx, $str, $baseColor, $tx, 0, $uiRect.pixelWitdh - (fontsize / 2), 20, $filterColor, $filterWidth);
        $uiAtlas.updateCtx($ctx, $uiRect.pixelX, $uiRect.pixelY);
    };
    /*
  *将单行颜色字写到CTX中
  */
    LabelTextFont.writeSingleLabelToCtx = function ($ctx, $str, fontsize, $tx, $ty, $align, $baseColor, $filterColor) {
        if (fontsize === void 0) { fontsize = 12; }
        if ($tx === void 0) { $tx = 0; }
        if ($ty === void 0) { $ty = 0; }
        if ($align === void 0) { $align = TextAlign.CENTER; }
        if ($baseColor === void 0) { $baseColor = "#ffffff"; }
        if ($filterColor === void 0) { $filterColor = ""; }
        if ($baseColor.indexOf("[") != -1) {
            $baseColor = "#" + $baseColor.substr(1, 6);
        }
        $ctx.fillStyle = $baseColor;
        $ctx.font = (true ? "bolder " : "") + " " + fontsize + "px " + UIData.font;
        var $textMetrics = TextRegExp.getTextMetrics($ctx, $str);
        if ($align == TextAlign.CENTER) {
            $tx -= $textMetrics.width / 2;
        }
        else if ($align == TextAlign.RIGHT) {
            $tx -= $textMetrics.width;
        }
        TextRegExp.wrapText($ctx, $str, $baseColor, $tx, $ty, 9999, 20, $filterColor);
    };
    /*
    *写入普通文字
    */
    LabelTextFont.writeText = function ($uiAtlas, $key, $x, $y, $str, fontsize, fontColor, $maxWidth, bolder) {
        if ($maxWidth === void 0) { $maxWidth = 0; }
        if (bolder === void 0) { bolder = false; }
        var totalwidthAndheight = new Array;
        var uiRect = $uiAtlas.getRec($key);
        var ctx = UIManager.getInstance().getContext2D(uiRect.pixelWitdh, uiRect.pixelHeight, false);
        ctx.fillStyle = fontColor;
        ctx.font = (bolder ? "bolder " : "") + fontsize + "px " + UIData.font;
        var $xpos = this.getTextxpos(TextAlign.LEFT, ctx);
        if ($maxWidth > 0) {
            totalwidthAndheight = this.wrapText(ctx, $str, $x, $y, $maxWidth, fontsize + 2);
        }
        else {
            ctx.fillText($str, $x + $xpos, $y);
        }
        $uiAtlas.updateCtx(ctx, uiRect.pixelX, uiRect.pixelY);
        return totalwidthAndheight;
    };
    /*
    *写入普通文字,字数不满足换行时，自动居中。Ctx
    *pixelHeight:Ctx的高
    */
    LabelTextFont.writeTextAutoCenterToCtx = function (ctx, $str, fontsize, $maxWidth, pixelHeight, $baseColor) {
        if (fontsize === void 0) { fontsize = 12; }
        if ($baseColor === void 0) { $baseColor = "#ffffff"; }
        if ($baseColor.indexOf("[") != -1) {
            $baseColor = "#" + $baseColor.substr(1, 6);
        }
        ctx.fillStyle = $baseColor;
        ctx.font = (true ? "bolder " : "") + " " + fontsize + "px " + UIData.font;
        var $x = 0;
        var $y = 0;
        var $xpos = this.getTextxpos(TextAlign.LEFT, ctx);
        if ($maxWidth > 0) {
            if (!this.isNewline(ctx, $str, $maxWidth)) {
                $y = (pixelHeight / 2) - (fontsize / 2);
            }
            this.wrapText(ctx, $str, $x, $y, $maxWidth, fontsize + 3);
        }
    };
    /*
    *写入普通文字,字数不满足换行时，自动居中。
    */
    LabelTextFont.writeTextAutoCenter = function ($uiAtlas, $key, $str, fontsize, fontColor, $maxWidth, bolder) {
        if (bolder === void 0) { bolder = false; }
        var uiRect = $uiAtlas.getRec($key);
        var ctx = UIManager.getInstance().getContext2D(uiRect.pixelWitdh, uiRect.pixelHeight, false);
        ctx.fillStyle = fontColor;
        ctx.font = (bolder ? "bolder " : "") + fontsize + "px " + UIData.font;
        var $x = 0;
        var $y = 0;
        var $xpos = this.getTextxpos(TextAlign.LEFT, ctx);
        if ($maxWidth > 0) {
            if (!this.isNewline(ctx, $str, $maxWidth)) {
                $y = (uiRect.pixelHeight / 2) - (fontsize / 2);
            }
            this.wrapText(ctx, $str, $x, $y, $maxWidth, fontsize + 3);
        }
        $uiAtlas.updateCtx(ctx, uiRect.pixelX, uiRect.pixelY);
    };
    LabelTextFont.isNewline = function (ctx, $text, $maxWidth) {
        var words = $text;
        var metrics = ctx.measureText(words);
        var testWidth = metrics.width;
        if (testWidth > $maxWidth) {
            return true;
        }
        return false;
    };
    LabelTextFont.writeTextToCtx = function (ctx, $x, $y, $str, fontsize, fontColor, bolder, $maxWidth) {
        if (bolder === void 0) { bolder = false; }
        if ($maxWidth === void 0) { $maxWidth = 0; }
        ctx.textBaseline = TextAlign.MIDDLE;
        ctx.textAlign = TextAlign.CENTER;
        ctx.fillStyle = fontColor;
        ctx.font = "bolder " + fontsize + "px " + UIData.font;
        var $xpos = this.getTextxpos(TextAlign.CENTER, ctx);
        if ($maxWidth > 0) {
            this.wrapText(ctx, $str, $x, $y, $maxWidth, fontsize + 3);
        }
        else {
            ctx.fillText($str, $x + $xpos, $y);
        }
    };
    LabelTextFont.getTextxpos = function ($textAlign, $ctx) {
        var $xpos = 0;
        if ($textAlign == TextAlign.LEFT) {
            $xpos = 0;
        }
        else if ($textAlign == TextAlign.RIGHT) {
            $xpos = $ctx.canvas.width;
        }
        else if ($textAlign == TextAlign.CENTER) {
            $xpos = $ctx.canvas.width / 2;
        }
        return $xpos;
    };
    LabelTextFont.wrapText = function ($ctx, text, $tx, $ty, maxWidth, $th) {
        var totalWidth = 0;
        var totalHeight = $ty;
        var words = text;
        var line = "";
        for (var n = 0; n < words.length; n++) {
            if (words[n] == "\n") {
                $ctx.fillText(line, $tx, totalHeight);
                line = "";
                totalHeight += $th;
            }
            else {
                var testLine = line + words[n];
                var metrics = $ctx.measureText(testLine);
                var testWidth = metrics.width;
                totalWidth = Math.max(totalWidth, testWidth);
                if (testWidth > maxWidth) {
                    $ctx.fillText(line, $tx, totalHeight);
                    line = words[n] + "";
                    totalHeight += $th;
                }
                else {
                    line = testLine;
                }
            }
        }
        $ctx.fillText(line, $tx, totalHeight);
        //计算高度
        totalHeight = totalHeight - $ty + $th;
        return [totalWidth, totalHeight];
    };
    LabelTextFont.clearLabel = function ($uiAtlas, $key) {
        var $uiRect = $uiAtlas.getRec($key);
        var $ctx = UIManager.getInstance().getContext2D($uiRect.pixelWitdh, $uiRect.pixelHeight, false);
        $uiAtlas.updateCtx($ctx, $uiRect.pixelX, $uiRect.pixelY);
    };
    return LabelTextFont;
})();
//# sourceMappingURL=LabelTextFont.js.map