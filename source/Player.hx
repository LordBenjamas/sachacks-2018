package;

import flixel.FlxSprite;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.group.FlxGroup;

class Player extends FlxSprite {
	private var player1:Bool;
	private var rocketGroup:FlxTypedGroup<Rocket>;

	override public function new(X:Int, Y:Int, isPlayer1:Bool, rockets:FlxTypedGroup<Rocket>):Void {
		super(X, Y);

		player1 = isPlayer1;
		rocketGroup = rockets;

		health = 3;

		if (player1) {
			loadGraphic(AssetPaths.playerOne__png, true, 50, 50);
		} else {
			loadGraphic(AssetPaths.playerTwo__png, true, 50, 50);
		}

		width = 34;
		height = 46;

		offset.set(2, 4);

		setFacingFlip(FlxObject.LEFT, true, false);
		setFacingFlip(FlxObject.RIGHT, false, false);
		animation.add("shoot", [10], 6, false);
		animation.add("lr", [0, 1, 2, 3, 4, 5, 6], 6, false);
		animation.add("idle", [8], 6, false);

		// max velocity and drag
		drag.set(1600, 1600);
		maxVelocity.set(250, 900);
		acceleration.y = 620;
	}

	override public function update(elapsed:Float):Void {
		movement(player1);
		shoot(player1);

		if (health <= 0) {
			// Game over
			kill();
		}

		super.update(elapsed);
	}

	private function movement(isPlayer1:Bool):Void {
		var left:Bool;
		var right:Bool;
		acceleration.x = 0;

		if (isPlayer1) {
			left = FlxG.keys.anyPressed([A]);
			right = FlxG.keys.anyPressed([D]);
		} else {
			left = FlxG.keys.anyPressed([J]);
			right = FlxG.keys.anyPressed([L]);
		}

		if (left) {
			acceleration.x = -drag.x;
			if (velocity.y == 0) {
				facing = FlxObject.LEFT;
				animation.play("lr");
			}
		} else if (right) {
			acceleration.x = drag.x;
			if (velocity.y == 0) {
				facing = FlxObject.RIGHT;
				animation.play("lr");
			}
		} else if (velocity.y == 0) {
			animation.play("idle");
		}
	}

	private function shoot(isPlayer1:Bool) {
		var shoot:Bool;
		if (isPlayer1) {
			shoot = FlxG.keys.anyJustPressed([S]);
		} else {
			shoot = FlxG.keys.anyJustPressed([K]);
		}
		if (shoot) {
			var rocket:Rocket = rocketGroup.recycle();
			rocket.reset(x + (width - rocket.width) / 2, y + (height));
			rocket.solid = true;

			if (velocity.y == 0) {
				velocity.y = -0.6 * maxVelocity.y;
			}

			animation.play("shoot");
			FlxG.sound.play(AssetPaths.explode3__wav);
		}
	}
}
