package com.babylonhx.cameras;
import com.babylonhx.math.Vector3;

/**
 * ...
 * @author Krtolica Vujadin
 */
class TouchCamera extends FreeCamera {

	private var _offsetX:Float = null;
	private var _offsetY:Float = null;
	private var _pointerCount:Int = 0;
	private var _pointerPressed:Array<Int> = [];
	private var _onPointerDown:Dynamic;
	private var _onPointerUp:Dynamic;
	private var _onPointerMove:Dynamic;
	
	public var angularSensibility:Float = 200000.0;
	public var moveSensibility:Float = 500.0;

	
	public function new(name:String, position:Vector3, scene:Scene) {
		super(name, position, scene);
	}

	override public function attachControl(?canvas:Dynamic, ?noPreventDefault:Bool): void {
		var previousPosition:Dynamic = null;// { x: 0, y: 0 };
		
		if (this._onPointerDown == null) {

			this._onPointerDown = (evt) => {

				if (!noPreventDefault) {
					evt.preventDefault();
				}

				this._pointerPressed.push(evt.pointerId);

				if (this._pointerPressed.length !== 1) {
					return;
				}

				previousPosition = {
					x: evt.clientX,
					y: evt.clientY
				};
			};

			this._onPointerUp = (evt) => {
				if (!noPreventDefault) {
					evt.preventDefault();
				}

				var index: number = this._pointerPressed.indexOf(evt.pointerId);

				if (index === -1) {
					return;
				}
				this._pointerPressed.splice(index, 1);

				if (index != 0) {
					return;
				}
				previousPosition = null;
				this._offsetX = null;
				this._offsetY = null;
			};

			this._onPointerMove = (evt) => {
				if (!noPreventDefault) {
					evt.preventDefault();
				}

				if (!previousPosition) {
					return;
				}

				var index: number = this._pointerPressed.indexOf(evt.pointerId);

				if (index != 0) {
					return;
				}

				this._offsetX = evt.clientX - previousPosition.x;
				this._offsetY = -(evt.clientY - previousPosition.y);
			};

			this._onLostFocus = () => {
				this._offsetX = null;
				this._offsetY = null;
			};
		}

		canvas.addEventListener("pointerdown", this._onPointerDown);
		canvas.addEventListener("pointerup", this._onPointerUp);
		canvas.addEventListener("pointerout", this._onPointerUp);
		canvas.addEventListener("pointermove", this._onPointerMove);

		BABYLON.Tools.RegisterTopRootEvents([
			{ name: "blur", handler: this._onLostFocus }
		]);
	}

	public detachControl(canvas: HTMLCanvasElement): void {
		if (this._attachedCanvas != canvas) {
			return;
		}

		canvas.removeEventListener("pointerdown", this._onPointerDown);
		canvas.removeEventListener("pointerup", this._onPointerUp);
		canvas.removeEventListener("pointerout", this._onPointerUp);
		canvas.removeEventListener("pointermove", this._onPointerMove);

		BABYLON.Tools.UnregisterTopRootEvents([
			{ name: "blur", handler: this._onLostFocus }
		]);

		this._attachedCanvas = null;
	}

	public _checkInputs(): void {
		if (!this._offsetX) {
			return;
		}
		this.cameraRotation.y += this._offsetX / this.angularSensibility;

		if (this._pointerPressed.length > 1) {
			this.cameraRotation.x += -this._offsetY / this.angularSensibility;
		} else {
			var speed = this._computeLocalCameraSpeed();
			var direction = new BABYLON.Vector3(0, 0, speed * this._offsetY / this.moveSensibility);

			BABYLON.Matrix.RotationYawPitchRollToRef(this.rotation.y, this.rotation.x, 0, this._cameraRotationMatrix);
			this.cameraDirection.addInPlace(BABYLON.Vector3.TransformCoordinates(direction, this._cameraRotationMatrix));
		}
	}
	
}
