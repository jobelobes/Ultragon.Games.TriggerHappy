using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Microsoft.Xna.Framework.Graphics;
using Microsoft.Xna.Framework.Input;
using Microsoft.Xna.Framework;

namespace TriggerHappy.GameObjects.Modifiers
{
    public class TeleportModifier : TriggerHappy.GameObjects.Modifiers.Modifier
    {
        #region Static Variables
        private static readonly int IncreaseAmount = 2;
        #endregion

        #region Constructors and Finalizers
        public TeleportModifier(Game game, Vector2 position)
            : base(game, Color.Chocolate, position) { }
        #endregion

        #region Overriden Methods
        public override bool CanActivate(Player player)
        {
            throw new NotImplementedException();
        }
        #endregion

    }
}
