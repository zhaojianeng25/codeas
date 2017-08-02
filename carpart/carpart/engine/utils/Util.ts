function float2int(value) {
    return value | 0;
}

function radian2angle(value: number): number {
    return value / Math.PI * 180;
}

function angle2radian(value: number): number {
    return value / 180 * Math.PI;
}

var keyProp: Array<string> = [
    "生命", "攻击", "防御", "命中", "闪避", "暴击", "坚韧", "攻速", "移速", "忽视防御", "忽视闪避", "生命值回复", "伤害加深", "伤害减免", "反弹伤害", "吸血", "回复效率", "暴击率", "抗暴率", "暴击伤害倍数", "降暴伤害倍数", "命中率", "闪避率", "眩晕", "定身", "沉默", "混乱", "魅惑", "控制增强", "控制减免"
];
function getKeyProById($id: number): string {
    return keyProp[$id];
}
function hexToArgb(expColor: number, is32: boolean = true, color: Vector3D = null): Vector3D {
    if (!color) {
        color = new Vector3D();
    }
    color.w = is32 ? (expColor >> 24) & 0xFF : 0;
    color.x = (expColor >> 16) & 0xFF;
    color.y = (expColor >> 8) & 0xFF;
    color.z = (expColor) & 0xFF;
    return color;
}

function hexToArgbNum(expColor: number, is32: boolean = true, color: Vector3D = null): Vector3D {
    color = hexToArgb(expColor, is32, color);
    color.scaleBy(1 / 0xFF);
    return color;
}

function getBaseUrl(): string {
    if (Scene_data.supportBlob) {
        return "";
    } else {
        return "_base";
    }
}
/**描边路径 */
function strokeFilter(ctx: CanvasRenderingContext2D, width: number, height: number, color: number): void {
    var colorVec: Vector3D = hexToArgb(color);
    var imgData: ImageData = ctx.getImageData(0, 0, width, height);
    var data = imgData.data;

    var targetAry: Array<number> = new Array;
    for (var i: number = 1; i < width - 1; i++) {
        for (var j: number = 0; j < height - 1; j++) {
            var idx: number = getPiexIdx(i, j);
            if (data[idx + 3] == 0) {
                if (getAround(i, j)) {

                    targetAry.push(idx);
                }
            }

        }
    }
    for (var i: number = 0; i < targetAry.length; i++) {
        data[targetAry[i]] = colorVec.x;
        data[targetAry[i] + 1] = colorVec.y;
        data[targetAry[i] + 2] = colorVec.z;
        data[targetAry[i] + 3] = colorVec.w;
    }

    ctx.putImageData(imgData, 0, 0);

    function getPiexIdx(x, y): number {
        return ((y * width) + x) * 4;
    }

    function getAround(x, y): boolean {

        var idx: number
        idx = getPiexIdx(x - 1, y);
        if (data[idx + 3] > 0) {
            return true;
        }
        idx = getPiexIdx(x + 1, y);
        if (data[idx + 3] > 0) {
            return true;
        }
        idx = getPiexIdx(x, y + 1);
        if (data[idx + 3] > 0) {
            return true;
        }
        idx = getPiexIdx(x, y - 1);
        if (data[idx + 3] > 0) {
            return true;
        }
        // idx = getPiexIdx(x - 1, y+1);
        // if (data[idx + 3] > 0) {
        //     return true;
        // }
        // idx = getPiexIdx(x + 1, y+1);
        // if (data[idx + 3] > 0) {
        //     return true;
        // }
        // idx = getPiexIdx(x - 1, y-1);
        // if (data[idx + 3] > 0) {
        //     return true;
        // }
        // idx = getPiexIdx(x + 1, y-1);
        // if (data[idx + 3] > 0) {
        //     return true;
        // }
        return false;
    }

}
function trim(s) {
    return trimRight(trimLeft(s));
}
//去掉左边的空白  
function trimLeft(s) {
    if (s == null) {
        return "";
    }
    var whitespace = new String(" \t\n\r");
    var str = new String(s);
    if (whitespace.indexOf(str.charAt(0)) != -1) {
        var j = 0, i = str.length;
        while (j < i && whitespace.indexOf(str.charAt(j)) != -1) {
            j++;
        }
        str = str.substring(j, i);
    }
    return str;
}

//去掉右边的空白 www.2cto.com   
function trimRight(s) {
    if (s == null) return "";
    var whitespace = new String(" \t\n\r");
    var str = new String(s);
    if (whitespace.indexOf(str.charAt(str.length - 1)) != -1) {
        var i = str.length - 1;
        while (i >= 0 && whitespace.indexOf(str.charAt(i)) != -1) {
            i--;
        }
        str = str.substring(0, i + 1);
    }
    return str;
}



function getRoleUrl(name: string): string {
    if (name.search("2242") != -1) {
        console.log("2242224222422242")
    }
    return "role/" + name + getBaseUrl() + ".txt";
}

function getRoleUIUrl(name: string): string {
    if (name.search("2242") != -1) {
        console.log("2242224222422242")
    }
    return "role/ui/" + name + getBaseUrl() + ".txt";
}


function getSkillUrl(name: string): string {
    if (!name || name.length==0) {
        console.log("没有技能")
    }
    var str: string = "skill/" + name + getBaseUrl() + ".txt";
    return str.replace(".txt", "_byte.txt")
}

function getModelUrl(name: string): string {
    return "model/" + name + getBaseUrl() + ".txt";
}

function getModelUIUrl(name: string): string {
    return "model/ui/" + name + getBaseUrl() + ".txt";
}
function getMapUrl(name: string): string {
    return "map/" + name + ".txt";
}

function getfactionmapUrl(name: number): string {
    return "ui/load/map/world/" + name + ".png";
}
function getZipMapUrl(name: string): string {
    return "map/" + name + "/";
}
function getactivityIconUrl(name: string): string {
    return "ui/load/activity/at/" + name + ".png";
}

function getVipIconUrl(name: number): string {
    return "ui/load/Vip/" + name + ".png";
}

function getFactionBuildMapUrl(name: number): string {
    return "ui/load/map/factionbuildmap/" + name + ".png";
}

function geteqiconIconUrl(name: string): string {
    if (name == "07") {
        console.log("name")
    }
    return "ui/eqicon/" + name + ".png";
}
function getSuccesspromptUrl(name: string): string {
    return "ui/load/toptip/txt/" + name + ".png";
}
function getSkillIconUrl(name: string): string {
    return "ui/skillicon/" + name + ".png";
}
function getload_IconUrl(name: string): string {
    return "ui/load/icon/" + name + ".png";
}
function getload_LogingiftUrl(name: string): string {
    return "ui/load/Logingift/Name/" + name + ".png";
}
function getload_LogingiftInfoUrl(name: string): string {
    return "ui/load/Logingift/Info/" + name + ".png";
}
function getUIIconUrl(name: string): string {
    return "ui/uiicon/" + name + ".png";
}

function getUItimeOutUrl(name: string): string {
    return "ui/load/timeOut/" + name + ".png"
}
function getUIpkGradeUrl(name: string): string {
    return "ui/load/pkGrade/" + name + ".png"
}
function getUItittleUrl(name: string): string {

    return "ui/load/tittle/" + name + ".png";
}
function getOutBossUiUrl(name: string, pre: boolean): string {
    if (pre) {
        return "ui/tittlename/oboss/t_" + name + ".png";
    } else {
        return "ui/tittlename/oboss/" + name + ".png";
    }

}
function traceNoTabelData(): void
{
    console.log("数据表无")
    throw new Error("数据表无");
}


/**将道具中的资源类，转换为消耗资源id */
function getresIdByreward($itemid: number): number {
    switch ($itemid) {
        case 1:
            //元宝
            return 0;
        case 3:
            //身上的银子
            return 2;
        case 11:
            //荣誉
            return 10;
        case 10:
            //帮贡
            return 9;
        case 7:
            //真气
            return 6;
        case 8:
            //兽灵
            return 7;
        case 9:
            //宝石精华
            return 8;
        case 12:
            //斗魂
            return 11;
    }
}


/**将后台名称 2.1001.张三 解析成 张三 */
function getBaseName(name: string): string {
    var ary: Array<string> = name.split(",");
    if (ary.length == 3) {
        return ary[2];
    } else {
        return name;
    }

}

/**将后台名称 2.1001.张三 解析成 1001.张三  跨服使用 */
function getServerAndName(name: string): string {
    var ary: Array<string> = name.split(",");
    if (ary.length == 3) {
        return ary[1] + ary[2];
    } else {
        return name;
    }

}

/** 数字换算成6位 */
function getNumToUnit(total: number): string {
    var str: string = String(total);
    if (total > 999999) {
        var unit: string = "万";
        var a: number = total / 10000;
        var b = Math.floor(a);
        if (b > 9999) {
            a = a / 10000
            unit = "亿";
        }

        var strc: string = String(a);
        str = strc.substring(0, 7) + unit;
    }
    return str;
}
//function trace(message?: any, ...optionalParams: any[]): void {
//    console.log(message, ...optionalParams);
//}
function random($num: number): number {
    return Math.floor(Math.random() * $num);
}
function randomByItem(arr: Array<any>): any {
    return arr[random(arr.length)]
}
function makeArray(a: Array<any>, b: Array<any>): void {
    if (!a) {
        console.log("有错")
    }
    for (var i: number = 0; i < a.length; i++) {
        b.push(a[i])
    }
}


function unZip($aryBuf: ArrayBuffer): ArrayBuffer {
    var compressed: Uint8Array = new Uint8Array($aryBuf);
    //var t = Date.now();
    var inflate = new Zlib.Inflate(compressed);
    var plain: Uint8Array = inflate.decompress();
    //console.log("解压obj",Date.now()-t);
    return plain.buffer;

    // var curTime:number = TimeUtil.getTimer();
    // zip.useWebWorkers = false;
    // zip.createReader(new zip.ArrayBufferReader($aryBuf), function (reader) {
    //     reader.getEntries(function (entries) {
    //         if (entries.length) {

    //             entries[0].getData(new zip.ArrayBufferWriter(), function (text) {
    //                 //_this.loadComplete(text);
    //                 callBack(text);
    //                 reader.close();

    //             });

    //         }
    //     });
    // }, function (error) {
    //     console.log(error);
    // });
}

function getUrlParam(name:string):string {
    var reg = new RegExp("(^|&)" + name + "=([^&]*)(&|$)");
    var r = window.location.search.substr(1).match(reg);
   
    if (r != null) {
        return decodeURI(r[2]);
    } else {
        return null;
    }
}

function copy2clipboard(val:string):void{
    var inputui:HTMLTextAreaElement = document.createElement("textarea")
    //inputui.type = "text";
    inputui.style.fontSize = '12pt';
    inputui.style.position = "absolute";
    inputui.style["z-index"] = -1;

    inputui.style.background = "transparent"
    inputui.style.border = "transparent"
    inputui.style.color = "white";
    inputui.setAttribute('readonly', '');

    document.body.appendChild(inputui);

    inputui.value = val;

    inputui.select();
    inputui.setSelectionRange(0, inputui.value.length);

    try {
        document.execCommand('copy');
    } catch (error) {
        alert("不支持复制");
    }

    setTimeout(function() {
        document.body.removeChild(inputui);
    }, 1000);
    

}