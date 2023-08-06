A tweak for Earendel's Text Plates mod. Arrowplates creates rotatable entities for the eight
arrow symbols, and automatically converts Text Plates arrows into the new entities. Use this
if you blueprint arrows and want them to still point at the right place when rotating your
blueprint.

There are two new console commands to help with adding this mod to an existing save:

* `/migrate_arrows` finds every arrow text plate on your current surface and
  converts it into a rotatable arrow.
* `/rotate_arrows` rotates every arrow on your current surface ninety degrees
  clockwise. Useful if the arrow entities in your current surface weren't facing
  north before `/migrate_arrows`. Definitely not added because I had
  accidentally made all the arrows in my blueprints face south.

Limitations:
* No automatic conversion of old blueprints. Place the blueprint and select new
  contents for it to get arrowplates.
* When placing an old blueprint, undo won't remove the new arrowplates.
* Extension mods which register additional text plate types (e.g. Even More Text
  Plates) aren't supported. Arrowplates needs to know about all textplate types
  in the data phase to register its entities. We'd have to look through
  registered entities in data-final-fixes and guess which ones were really
  textplates.
* Pipette does not set the textplates GUI to the correct symbol. There's no
  way to tell Text Plates which symbol should be placed next.

This mod is distributed under https://creativecommons.org/licenses/by-nc/4.0/.
