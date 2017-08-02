class SceneChar extends SceneBaseChar {
    public constructor() {
        super();
    }
    public watch($obj: Display3D, $syn: boolean = false): void {
        if (!$obj) {
            console.log("面向对象无")
            return;
        }
        var xx: number = $obj.x - this.px;
        var yy: number = $obj.z - this.pz;
        var distance: number = Math.sqrt(xx * xx + yy * yy);
        xx /= distance;
        yy /= distance;
        var angle: number = Math.asin(xx) / Math.PI * 180;
        if (yy <= 0) {
            angle = 180 - angle;
        }
        if (!isNaN(angle)) {
            this.rotationY = angle
        }
    }
}